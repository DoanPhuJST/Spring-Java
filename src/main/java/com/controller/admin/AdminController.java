package com.controller.admin;
import com.model.Account;
import com.model.Rental;
import com.model.Vehicle;
import com.model.dto.RentalRequest;
import com.repository.IAccountRepo;
import com.repository.RentalRepository;
import com.repository.VehicleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private RentalRepository rentalRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private IAccountRepo accountRepository;
    @GetMapping()
    public String manageRentals(Model model, @RequestParam(defaultValue = "0") int page,
                                @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Rental> rentalPage = rentalRepository.findAll(pageable);
        model.addAttribute("rentals", rentalPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", rentalPage.getTotalPages());
        return "/admin/rentals.jsp";
    }

    @PostMapping("/rentals/{rentalId}/approve")
    public String approveRental(@PathVariable Integer rentalId, RedirectAttributes redirectAttributes) {
        Optional<Rental> optionalRental = rentalRepository.findById(rentalId);
        if (!optionalRental.isPresent()) {
            redirectAttributes.addFlashAttribute("message", "Không tìm thấy đơn thuê.");
        } else {
            Rental rental = optionalRental.get();
            rental.setStatus(Rental.TrangThai.daDuyet);
            rentalRepository.save(rental);
            redirectAttributes.addFlashAttribute("message", "Đã duyệt đơn thuê thành công.");
        }
        return "redirect:/admin";
    }

    @PostMapping("/rentals/{rentalId}/cancel")
    public String cancelRental(@PathVariable Integer rentalId, RedirectAttributes redirectAttributes) {
        Optional<Rental> optionalRental = rentalRepository.findById(rentalId);
        if (!optionalRental.isPresent()) {
            redirectAttributes.addFlashAttribute("message", "Không tìm thấy đơn thuê.");
        } else {
            Rental rental = optionalRental.get();
            if (rental.getStatus() != Rental.TrangThai.choDuyet) {
                redirectAttributes.addFlashAttribute("message", "Chỉ có thể hủy đơn thuê ở trạng thái chờ duyệt.");
            } else {
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime oneDayBeforeStart = rental.getStartDate().minus(1, ChronoUnit.DAYS);

                if (now.isAfter(oneDayBeforeStart)) {
                    redirectAttributes.addFlashAttribute("message", "Chỉ có thể hủy trước ngày thuê 1 ngày.");
                } else {
                    rental.setStatus(Rental.TrangThai.daHuy);
                    rentalRepository.save(rental);
                    redirectAttributes.addFlashAttribute("message", "Đã hủy đơn thuê thành công.");
                }

            }
        }
        return "redirect:/admin";
    }
}
