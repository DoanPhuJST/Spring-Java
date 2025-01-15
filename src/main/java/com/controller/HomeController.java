package com.controller;

import com.model.Account;
import com.model.Rental;
import com.model.Vehicle;
import com.model.VehicleType;
import com.repository.IAccountRepo;
import com.repository.RentalRepository;
import com.repository.VehicleRepository;
import com.repository.VehicleTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
public class HomeController {
    @Autowired
    private RentalRepository rentalRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private IAccountRepo accountRepository;

    @Autowired
    private VehicleTypeRepository vehicleTypeRepository;

    @GetMapping("/home")
    public String home(Model model) {
        // Lấy tất cả các loại xe
        List<VehicleType> allVehicleTypes = vehicleTypeRepository.findAll();

        // Tạo một Map để lưu trữ top 4 xe cho mỗi loại
        Map<VehicleType, List<Vehicle>> topVehiclesByType = new HashMap<>();

        // Lặp qua từng loại xe
        for (VehicleType vehicleType : allVehicleTypes) {
            // Lấy top 6 xe cho loại xe hiện tại
            Pageable pageable = PageRequest.of(0, 6);
            List<Vehicle> topVehicles = vehicleRepository.findByVehicleType(vehicleType, pageable);
            topVehiclesByType.put(vehicleType, topVehicles);
        }

        model.addAttribute("allVehicleTypes", allVehicleTypes);
        model.addAttribute("topVehiclesByType", topVehiclesByType);

        return "/index.jsp";
    }

    @GetMapping("/search")
    public String searchVehicles(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "pickupDate", required = false) String pickupDateStr,
            @RequestParam(name = "returnDate", required = false) String returnDateStr,
            Model model) {

        List<Vehicle> vehicles = null;
        if (category != null && pickupDateStr != null && returnDateStr != null) {
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate pickupDate = LocalDate.parse(pickupDateStr,dateFormatter);
            LocalDate returnDate = LocalDate.parse(returnDateStr,dateFormatter);
            LocalDateTime pickupDateTime = pickupDate.atTime(LocalTime.MIN);
            LocalDateTime returnDateTime = returnDate.atTime(LocalTime.MAX);
            vehicles = vehicleRepository.findAvailableVehicles(category, pickupDateTime, returnDateTime);
        } else if(category!=null){
            vehicles = vehicleRepository.findByVehicleTypeName(category);
        } else {
            vehicles = vehicleRepository.findAll();
        }

        model.addAttribute("vehicles", vehicles);
        model.addAttribute("allVehicleTypes", vehicleTypeRepository.findAll());
        return "/category.jsp";
    }



    @GetMapping("/category/{id}")
    public String category(Model model, @PathVariable int id) {
        VehicleType vehicleType = vehicleTypeRepository.getById(id);
        List<Vehicle> vehicles = vehicleRepository.findByVehicleType(vehicleType);
        model.addAttribute("vehicles", vehicles);
        model.addAttribute("allVehicleTypes", vehicleTypeRepository.findAll());
        return "/category.jsp";
    }

    @GetMapping("/vehicle/{vehicleId}")
    public String vehicleDetails(@PathVariable Integer vehicleId, Model model) {
        Optional<Vehicle> vehicle = vehicleRepository.findById(vehicleId);
        if (vehicle.isPresent()) {
            model.addAttribute("vehicle", vehicle.get());
            model.addAttribute("allVehicleTypes", vehicleTypeRepository.findAll());
            return "/car.jsp";
        } else {
            return "redirect:/home";
        }
    }

    @GetMapping("/my-rentals")
    public String myRentals(Model model, Principal principal, @RequestParam(name = "status", required = false) String status) {
        if (principal == null) {
            return "redirect:/login"; // Redirect nếu chưa đăng nhập
        }

        String username = principal.getName();
        Account account = accountRepository.findByUsername(username);

        if (account == null) {
            return "redirect:/";
        }

        List<Rental> rentals;
        if (status != null && !status.isEmpty()) {
            try {
                Rental.TrangThai trangThai = Rental.TrangThai.valueOf(status);
                rentals = rentalRepository.findByAccountAndStatus(account, trangThai);
            } catch (IllegalArgumentException e) {
                rentals = rentalRepository.findByAccount(account);
            }
        } else {
            rentals = rentalRepository.findByAccount(account);
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        model.addAttribute("rentals", rentals);
        model.addAttribute("formatter", formatter);
        model.addAttribute("allVehicleTypes", vehicleTypeRepository.findAll());
        return "/myRentals.jsp";
    }

}