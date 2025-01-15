package com.repository;
import com.model.Vehicle;
import com.model.VehicleType;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, Integer> {
    List<Vehicle> findByVehicleType(VehicleType vehicleType, Pageable pageable);
    List<Vehicle> findByVehicleType(VehicleType vehicleType);
    @Query("SELECT v FROM Vehicle v WHERE v.vehicleType.name = :category AND v.id NOT IN (SELECT r.vehicle.id FROM Rental r WHERE (:startDate BETWEEN r.startDate AND r.endDate) OR (:endDate BETWEEN r.startDate AND r.endDate) OR (r.startDate BETWEEN :startDate AND :endDate))")
    List<Vehicle> findAvailableVehicles(@Param("category") String category, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    List<Vehicle> findByVehicleTypeName(String name);

}


