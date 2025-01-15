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
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/rentals")
public class RentalControllerAPI {

    @Autowired
    private RentalRepository rentalRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private IAccountRepo accountRepository;



    @GetMapping("/{vehicleId}")
    public ResponseEntity<List<LocalDate>> getRentalDates(@PathVariable Integer vehicleId) { // Bỏ start và end
        List<Rental> rentals = rentalRepository.findByVehicleId(vehicleId); // Lấy tất cả rentals

        List<LocalDate> bookedDates = rentals.stream()
                .flatMap(rental -> {
                    LocalDate startDateRental = rental.getStartDate().toLocalDate();
                    LocalDate endDateRental = rental.getEndDate().toLocalDate();
                    return startDateRental.datesUntil(endDateRental.plusDays(1)); // Include the end date
                })
                .distinct()
                .collect(Collectors.toList());

        return ResponseEntity.ok(bookedDates);
    }
}
