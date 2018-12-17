package com.example.jiangxinhou01.medicineandroid;

class XHNetGlobal {
    private static final XHNetGlobal ourInstance = new XHNetGlobal();

    static XHNetGlobal getInstance() {
        return ourInstance;
    }

    private XHNetGlobal() {
    }

    public SocketService socketService = null;
}
