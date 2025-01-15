package com.controller.admin;

import com.model.VehicleType;
import com.repository.VehicleTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.Optional;

@Controller
public class VehicleTypeController {

    @Autowired
    private VehicleTypeRepository vehicleTypeRepository;

    @GetMapping("/admin/vehicleTypes")
    public String manageVehicleTypes(Model model, @RequestParam(defaultValue = "0") int page,
                                     @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<VehicleType> vehicleTypePage = vehicleTypeRepository.findAll(pageable);
        model.addAttribute("vehicleTypes", vehicleTypePage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", vehicleTypePage.getTotalPages());
        return "/admin/vehicleTypes.jsp";
    }

    @PostMapping("/admin/vehicleTypes/add")
    public ResponseEntity<?> addVehicleType(@Valid @ModelAttribute VehicleType vehicleType, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body("Dữ liệu không hợp lệ.");
        }
        vehicleTypeRepository.save(vehicleType);
        return ResponseEntity.ok("Đã thêm loại xe thành công.");
    }

    @GetMapping("/admin/vehicleTypes/{id}")
    public ResponseEntity<VehicleType> getVehicleType(@PathVariable Integer id) {
        Optional<VehicleType> vehicleType = vehicleTypeRepository.findById(id);
        return vehicleType.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/admin/vehicleTypes/{id}/edit")
    public ResponseEntity<?> editVehicleType(@PathVariable Integer id, @Valid @ModelAttribute VehicleType vehicleType, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body("Dữ liệu không hợp lệ.");
        }
        Optional<VehicleType> existingVehicleType = vehicleTypeRepository.findById(id);
        if (existingVehicleType.isPresent()) {
            VehicleType vehicleTypeUpdate = existingVehicleType.get();
            vehicleTypeUpdate.setName(vehicleType.getName());
            vehicleTypeRepository.save(vehicleTypeUpdate);
            return ResponseEntity.ok("Đã sửa loại xe thành công.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/admin/vehicleTypes/{id}/delete")
    public ResponseEntity<?> deleteVehicleType(@PathVariable Integer id) {
        try {
            vehicleTypeRepository.deleteById(id);
            return ResponseEntity.ok("Đã xóa loại xe thành công.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Không thể xóa loại xe này vì có ràng buộc.");
        }
    }
}
