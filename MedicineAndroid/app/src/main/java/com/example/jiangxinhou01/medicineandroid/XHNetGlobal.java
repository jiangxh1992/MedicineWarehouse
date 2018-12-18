package com.example.jiangxinhou01.medicineandroid;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;

import java.net.Socket;

class XHNetGlobal {
    private static final XHNetGlobal ourInstance = new XHNetGlobal();

    static XHNetGlobal getInstance() {
        return ourInstance;
    }

    private XHNetGlobal() {
    }
    private SocketService socketService = null;
    public ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            SocketService.SocketBinder binder = (SocketService.SocketBinder) iBinder;
            socketService = binder.getService();
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
            socketService = null;
        }
    };
    public static String dynamicIP = "192.168.146.1";
    public static int dynamicPort = 9500;

    // set ip and port
    public void setSocketIPandPort(String ip, int port){
        dynamicIP = ip;
        dynamicPort = port;
    }

    // socket connect status
    public boolean IsSocketConnected(){
        if(socketService == null) return false;
        Socket socket = socketService.getSocket();
        if(socket == null) return false;
        return socket.isConnected();
    }

    // 接收数据回调
    public static Handler msgCBHandler = null;

    // 发送数据
    public void SendMessage(String msg){
        if(socketService == null) return;
        socketService.SendMessage(msg);
    }
}
