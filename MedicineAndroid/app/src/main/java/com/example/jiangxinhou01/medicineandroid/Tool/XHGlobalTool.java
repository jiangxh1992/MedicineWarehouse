package com.example.jiangxinhou01.medicineandroid.Tool;

import android.widget.Toast;

import com.example.jiangxinhou01.medicineandroid.Main.MainActivity;

public class XHGlobalTool {
    private static final XHGlobalTool ourInstance = new XHGlobalTool();

    public static XHGlobalTool getInstance() {
        return ourInstance;
    }

    private XHGlobalTool() {
    }

    // defaul toast
    public static void toastText(String message) {
        Toast.makeText(MainActivity.getContext(), message, Toast.LENGTH_SHORT).show();
    }
}
