package com.controller.admin;

import com.model.Vehicle;
import com.repository.VehicleRepository;
import com.repository.VehicleTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;

@Controller
public class VehicleController {

    @Autowired
    private VehicleRepository vehicleRepository;
    @Autowired
    private VehicleTypeRepository vehicleTypeRepository;
    private static String UPLOADED_FOLDER = "E:\\web_thue_xe_spring_jsp-master\\web_thue_xe_spring_jsp-master\\src\\main\\webapp/images/";

    @GetMapping("/admin/vehicles")
    public String manageVehicles(Model model, @RequestParam(defaultValue = "0") int page,
                                 @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Vehicle> vehiclePage = vehicleRepository.findAll(pageable);
        model.addAttribute("vehicles", vehiclePage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", vehiclePage.getTotalPages());
        return "/admin/vehicles.jsp";
    }

    @GetMapping("/admin/vehicles/add")
    public String showAddVehicleForm(Model model) {
        model.addAttribute("vehicleTypes", vehicleTypeRepository.findAll());
        model.addAttribute("vehicle", new Vehicle()); // Để form có object để binding
        return "/admin/addVehicle.jsp";
    }

    @PostMapping("/admin/vehicles/add")
    public String addVehicle(@ModelAttribute Vehicle vehicle, @RequestParam("file") MultipartFile file, RedirectAttributes redirectAttributes) {
        if (!file.isEmpty()) {
            try {
                byte[] bytes = file.getBytes();
                Path path = Paths.get(UPLOADED_FOLDER + file.getOriginalFilename());
                Files.write(path, bytes);
                vehicle.setImage("/images/" +file.getOriginalFilename());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        vehicleRepository.save(vehicle);
        redirectAttributes.addFlashAttribute("message", "Đã thêm xe thành công.");
        return "redirect:/admin/vehicles";
    }

    @GetMapping("/admin/vehicles/{id}/edit")
    public String showEditVehicleForm(@PathVariable Integer id, Model model) {
        Optional<Vehicle> vehicle = vehicleRepository.findById(id);
        if (vehicle.isPresent()) {
            model.addAttribute("vehicle", vehicle.get());
            model.addAttribute("vehicleTypes", vehicleTypeRepository.findAll());
            return "/admin/editVehicle.jsp";
        } else {
            return "redirect:/admin/vehicles";
        }
    }

    @PostMapping("/admin/vehicles/{id}/edit")
    public String editVehicle(@PathVariable Integer id, @ModelAttribute Vehicle vehicle, @RequestParam("file") MultipartFile file,RedirectAttributes redirectAttributes) {
        Optional<Vehicle> existingVehicle = vehicleRepository.findById(id);
        if (existingVehicle.isPresent()) {
            Vehicle vehicleUpdate = existingVehicle.get();
            vehicleUpdate.setBienSo(vehicle.getBienSo());
            vehicleUpdate.setCompany(vehicle.getCompany());
            vehicleUpdate.setContent(vehicle.getContent());
            vehicleUpdate.setPrice(vehicle.getPrice());
            vehicleUpdate.setStatus(vehicle.getStatus());
            vehicleUpdate.setVehicleType(vehicle.getVehicleType());
            if (!file.isEmpty()) {
                try {
                    byte[] bytes = file.getBytes();
                    Path path = Paths.get(UPLOADED_FOLDER + file.getOriginalFilename());
                    Files.write(path, bytes);
                    vehicleUpdate.setImage("/images/" + file.getOriginalFilename());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            vehicleRepository.save(vehicleUpdate);
            redirectAttributes.addFlashAttribute("message", "Đã sửa xe thành công.");
        }
        return "redirect:/admin/vehicles";
    }

    @PostMapping("/admin/vehicles/{id}/delete")
    public String deleteVehicle(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        vehicleRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Đã xóa xe thành công.");
        return "redirect:/admin/vehicles";
    }
}
