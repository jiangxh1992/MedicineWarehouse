package com.example.jiangxinhou01.medicineandroid.Tool;

import com.example.jiangxinhou01.medicineandroid.Model.Account;

public class AccountGlobal {
    private static final AccountGlobal ourInstance = new AccountGlobal();

    public boolean isLogin = false;
    public Account account = new Account();
    public static AccountGlobal getInstance() {
        return ourInstance;
    }

    private AccountGlobal() {
    }
}
