package com.example.jiangxinhou01.medicineandroid;

import android.widget.Toast;
import android.content.Context;
class XHGlobalTool {
    private static final XHGlobalTool ourInstance = new XHGlobalTool();

    static XHGlobalTool getInstance() {
        return ourInstance;
    }

    private XHGlobalTool() {
    }

    // defaul toast
    public static void toastText(String message) {
        Toast.makeText(MainActivity.getContext(), message, Toast.LENGTH_LONG).show();
    }
}
