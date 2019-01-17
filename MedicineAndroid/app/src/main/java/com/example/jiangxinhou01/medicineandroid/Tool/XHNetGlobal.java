package com.example.jiangxinhou01.medicineandroid.Tool;

import android.annotation.SuppressLint;
import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.Socket;

public class XHNetGlobal {
    private static final XHNetGlobal ourInstance = new XHNetGlobal();

    public static XHNetGlobal getInstance() {
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


    // 发送数据
    public void SendMessage(String msg){
        if(socketService == null) return;
        socketService.SendMessage(msg);
    }

    // 接收数据回调
    public static Handler msgCBHandler = null;
    // 消息分发
    public static Handler msgHandlerLogin = null; // 登录
    public static Handler msgHandlerMedicineUnit = null; // 请求单元机
    public static Handler msgHandlerMatchUnit = null; // 单元机匹配
    public static Handler msgHandlerMedicinePlus = null; // 补药

    public static Handler msgHandlerSignin = null; // 注册

    // 消息注册
    @SuppressLint("HandlerLeak")
    public static void initMsgListener(){
        /* 服务器返回数据 */
        if(msgCBHandler == null){
            msgCBHandler = new Handler(){
                public void handleMessage(Message msg){
                    String dataStr = (String)msg.obj;
                    try {
                        JSONObject json = new JSONObject(dataStr);
                        int type = json.getInt("type");
                        switch (type){
                            case 0:
                                if(msgHandlerLogin != null)
                                    msgHandlerLogin.sendMessage(msg);
                                break;
                            case 1:
                                if(msgHandlerMedicineUnit != null)
                                    msgHandlerMedicineUnit.sendMessage(msg);
                                break;
                            case 2:
                                if(msgHandlerMatchUnit != null)
                                    msgHandlerMatchUnit.sendMessage(msg);
                                break;
                            case 3:
                                if(msgHandlerMedicinePlus != null)
                                    msgHandlerMedicinePlus.sendMessage(msg);
                                break;
                            case 100:
                                if(msgHandlerSignin != null)
                                    msgHandlerSignin.sendMessage(msg);
                                break;
                            default:
                                break;
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                    }
                }
            };
        }
    }
}
