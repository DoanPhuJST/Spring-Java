package com.repository;

import com.model.Account;
import com.model.Rental;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface RentalRepository extends JpaRepository<Rental, Integer> {
    List<Rental> findByVehicleId(Integer vehicleId);
    List<Rental> findByAccount(Account account);
    List<Rental> findByAccountAndStatus(Account account, Rental.TrangThai status);

    @Query("SELECT SUM(r.total) FROM Rental r WHERE r.startDate BETWEEN :startDate AND :endDate")
    BigDecimal calculateTotalRevenueBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}
