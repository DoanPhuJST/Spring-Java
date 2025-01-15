package com.controller;

import com.model.Account;
import com.model.Role;
import com.repository.IAccountRepo;
import com.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

@Controller
public class AccountController {
    @Autowired
    AccountService accountService;

    @Autowired
    HttpSession httpSession;

    @Autowired
    private IAccountRepo accountRepository;

    @Autowired
    PasswordEncoder passwordEncoder;

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("account", new Account());
        return "/register.jsp";
    }

    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("account", new Account());
        return "/login.jsp";
    }

    @PostMapping("/register")
    public String registerAccount(@Valid @ModelAttribute("account") Account account, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            return "/register.jsp";
        }

        if (accountRepository.existsByUsername(account.getUsername())) {
            model.addAttribute("usernameError", "Tên đăng nhập đã tồn tại");
            return "/register.jsp";
        }

        if (accountRepository.existsByEmail(account.getEmail())) {
            model.addAttribute("emailError", "Email đã được sử dụng");
            return "/register.jsp";
        }
        Role role = new Role();
        role.setId(2);
        account.setPassword(passwordEncoder.encode(account.getPassword()));
        account.setRole(role);
        accountRepository.save(account);
        redirectAttributes.addFlashAttribute("message", "Đăng ký thành công!");
        return "redirect:/login"; // Chuyển hướng đến trang đăng nhập
    }

}
