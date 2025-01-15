package com.config;

import com.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;

@EnableWebSecurity
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private AccountService accountService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    private RequestCache requestCache = new HttpSessionRequestCache();

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(accountService).passwordEncoder(passwordEncoder());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().ignoringAntMatchers("/**");
        http.authorizeRequests()
                .antMatchers("/home","/api/rentals**").permitAll()
                .antMatchers("/rentals/**","/my-rentals").hasAnyAuthority("ROLE_USER", "ROLE_ADMIN")
                .antMatchers("/admin").hasRole("ADMIN")
                .and()
                .formLogin().loginPage("/login")
                .successHandler(successHandler()) // Sử dụng bean successHandler
                .and()
                .logout().and().csrf().disable();;
    }

    @Bean
    public AuthenticationSuccessHandler successHandler() {
        return new CustomSuccessHandler(requestCache);
    }

    public static class CustomSuccessHandler implements AuthenticationSuccessHandler {

        private final RequestCache requestCache;

        public CustomSuccessHandler(RequestCache requestCache) {
            this.requestCache = requestCache;
        }

        @Override
        public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
            String redirectUrl = requestCache.getRequest(request, response) != null ? requestCache.getRequest(request, response).getRedirectUrl() : null;

            if (redirectUrl != null) {
                requestCache.removeRequest(request, response);
                response.sendRedirect(redirectUrl);
                return;
            }

            Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
            for (GrantedAuthority authority : authorities) {
                if (authority.getAuthority().equals("ROLE_ADMIN")) {
                    response.sendRedirect("/admin");
                    return;
                } else if (authority.getAuthority().equals("ROLE_USER")) {
                    response.sendRedirect("/home");
                    return;
                }
            }

            response.sendRedirect("/home"); // Redirect mặc định nếu không có role cụ thể
        }
    }
}