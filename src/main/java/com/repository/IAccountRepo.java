package com.repository;

import com.model.Account;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

public interface IAccountRepo extends PagingAndSortingRepository<Account,Long> {

    @Query(nativeQuery = true,value = "SELECT * from account where username = :username and password = :password")
    public Account login(@Param("username") String username, @Param("password") String password);

    Account findByUsername(String username);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);

}
