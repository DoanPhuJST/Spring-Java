package com.controller;

import com.model.Account;
import com.model.Rental;
import com.model.Vehicle;
import com.model.dto.RentalRequest;
import com.repository.IAccountRepo;
import com.repository.RentalRepository;
import com.repository.VehicleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Controller
@RequestMapping("/rentals")
public class RentalController {

    @Autowired
    private RentalRepository rentalRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private IAccountRepo accountRepository;

    @PostMapping("/{rentalId}/cancel")
    public String cancelRental(@PathVariable Integer rentalId, Principal principal, RedirectAttributes redirectAttributes) {

        if (principal == null) {
            redirectAttributes.addFlashAttribute("message", "Bạn cần đăng nhập để hủy lịch thuê.");
            return "redirect:/login";
        }

        String username = principal.getName();
        Account account = accountRepository.findByUsername(username);

        if (account == null) {
            redirectAttributes.addFlashAttribute("message", "Không tìm thấy tài khoản.");
            return "redirect:/";
        }

        Optional<Rental> optionalRental = rentalRepository.findById(rentalId);
        if (!optionalRental.isPresent()) {
            redirectAttributes.addFlashAttribute("message", "Không tìm thấy lịch thuê.");
            return "redirect:/my-rentals"; // Redirect về trang lịch sử thuê
        }

        Rental rental = optionalRental.get();

        if (!rental.getAccount().getUsername().equals(account.getUsername())) {
            redirectAttributes.addFlashAttribute("message", "Bạn không có quyền hủy lịch thuê này.");
            return "redirect:/my-rentals";
        }

        if (rental.getStatus() != Rental.TrangThai.choDuyet) {
            redirectAttributes.addFlashAttribute("message", "Chỉ có thể hủy lịch thuê ở trạng thái chờ duyệt.");
            return "redirect:/my-rentals";
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime oneDayBeforeStart = rental.getStartDate().minus(1, ChronoUnit.DAYS);

        if (now.isAfter(oneDayBeforeStart)) {
            redirectAttributes.addFlashAttribute("message", "Chỉ có thể hủy trước ngày thuê 1 ngày.");
            return "redirect:/my-rentals";
        }

        rental.setStatus(Rental.TrangThai.daHuy);
        rentalRepository.save(rental);

        redirectAttributes.addFlashAttribute("message", "Hủy lịch thuê thành công.");
        return "redirect:/my-rentals";
    }

    @PostMapping()
    public String createRental(@RequestParam("vehicleId") Integer vehicleId,
                               @RequestParam("startDate") String startDateStr,
                               @RequestParam("endDate") String endDateStr,
                               Principal principal) {

        if (principal == null) {
            return "redirect:/login";
        }

        String username = principal.getName();
        Account account = accountRepository.findByUsername(username);

        if (account == null) {
            return "redirect:/";
        }

        Optional<Vehicle> vehicle = vehicleRepository.findById(vehicleId);
        if (!vehicle.isPresent()) {
            return "redirect:/"; // Hoặc trang chi tiết xe
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate startDate = LocalDate.parse(startDateStr, formatter);
        LocalDate endDate = LocalDate.parse(endDateStr, formatter);

        if (endDate.isBefore(startDate) || endDate.isEqual(startDate)) {
            return "redirect:/vehicle/" + vehicleId; // Trở lại trang chi tiết xe
        }

        List<Rental> existingRentals = rentalRepository.findByVehicleId(vehicleId);
        boolean isConflict = existingRentals.stream().anyMatch(existingRental -> {
            LocalDate existingStartDate = existingRental.getStartDate().toLocalDate();
            LocalDate existingEndDate = existingRental.getEndDate().toLocalDate();
            return !(endDate.isBefore(existingStartDate) || startDate.isAfter(existingEndDate));
        });

        if (isConflict) {
            return "redirect:/vehicle/" + vehicleId;
        }

        Rental rental = new Rental();
        rental.setAccount(account);
        rental.setVehicle(vehicle.get());
        rental.setStartDate(startDate.atStartOfDay());
        rental.setEndDate(endDate.atTime(23, 59, 59));
        //Tính tiền thuê
        long days = ChronoUnit.DAYS.between(startDate, endDate) + 1;
        BigDecimal bigDecimalDays = BigDecimal.valueOf(days);
        rental.setTotal(BigDecimal.valueOf(vehicle.get().getPrice().multiply(bigDecimalDays).intValue()));

        rentalRepository.save(rental);
        return "redirect:/my-rentals";
    }

    @GetMapping("/monthly-revenue")
    public String showMonthlyRevenue(Model model) {
        return "/admin/monthlyRevenue.jsp"; // Trả về trang JSP
    }

    @GetMapping("/monthly-revenue/data")
    @ResponseBody
    public List<Map<String, Object>> getMonthlyRevenueData(@RequestParam(required = false) Integer year) {
        if (year == null) {
            year = LocalDate.now().getYear();
        }

        List<Map<String, Object>> revenueData = new ArrayList<>();

        for (int month = 1; month <= 12; month++) {
            YearMonth yearMonth = YearMonth.of(year, month);
            LocalDate startOfMonth = yearMonth.atDay(1);
            LocalDate endOfMonth = yearMonth.atEndOfMonth();

            // Chuyển đổi LocalDate thành LocalDateTime
            LocalDateTime startDateTime = startOfMonth.atStartOfDay();
            LocalDateTime endDateTime = endOfMonth.atTime(23, 59, 59, 999999999); // Hoặc atEndOfDay() nếu bạn dùng Java 8+

            BigDecimal monthlyRevenue = rentalRepository.calculateTotalRevenueBetween(startDateTime, endDateTime);
            if (monthlyRevenue == null) {
                monthlyRevenue = BigDecimal.ZERO;
            }

            Map<String, Object> monthData = new HashMap<>();
            monthData.put("month", month);
            monthData.put("year", year);
            monthData.put("revenue", monthlyRevenue);
            revenueData.add(monthData);
        }

        return revenueData;
    }
}
