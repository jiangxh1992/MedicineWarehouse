package com.example.jiangxinhou01.medicineandroid.Tool;

import android.annotation.SuppressLint;
import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.net.Socket;
import java.net.UnknownHostException;

public class SocketService extends Service {

    // Socket
    //private  String SERVER_HOST_IP = "192.168.146.1";
    //private  int SERVER_HOST_PORT = 9500;
    private Socket socket;
    private Thread thread;
    private OutputStream outStream;
    private InputStream inputStream;
    private String receive;
    public final IBinder mBinder = new SocketBinder();

    public SocketService() {
    }

    public Socket getSocket() {
        return socket;
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        return mBinder;
    }
    public class SocketBinder extends Binder{
        public SocketService getService(){
            return SocketService.this;
        }
    }
    @Override
    public void onCreate(){
        super.onCreate();
        initSocketClient();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }

    public void SendMessage(final String msg){
        if(socket != null && socket.isConnected()){
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try{
                        if(outStream != null){
                            outStream.write(msg.getBytes("gbk"));
                        }
                    }catch (IOException e){
                        e.printStackTrace();
                    }
                }
            }).start();
        }
        else {
            XHGlobalTool.toastText("服务器未连接！");
        }
    }

    @SuppressLint("HandlerLeak")
    private Handler handler = new Handler(){
        public void handleMessage(Message msg){
            switch(msg.what){
                case 1:
                    IsAndOs stream = (IsAndOs)msg.obj;
                    outStream = stream.os;
                    inputStream = stream.is;
                    thread = new Thread(receivedDataThread);
                    thread.start();
                    break;
                case 2:
                    receive = (String) msg.obj;
                    if(receive != null){
                        XHGlobalTool.toastText("服务器数据收到！："+receive);
                        SendMessage("服务器先生俺收到您的数据了："+receive);
                    }
            }
        };
    };

    public void initSocketClient(){
        new Thread(new Runnable() {
            @Override
            public void run() {
                try{
                    socket = new Socket(XHNetGlobal.dynamicIP,XHNetGlobal.dynamicPort);
                    PrintStream pStream = new PrintStream(socket.getOutputStream(), true, "utf-8");
                    InputStream inStream = socket.getInputStream();
                    IsAndOs io = new IsAndOs();
                    io.is = inStream;
                    io.os = pStream;
                    Message msg = handler.obtainMessage();
                    msg.what = 1;
                    msg.obj = io;
                    handler.sendMessage(msg);
                } catch (UnknownHostException e){
                    e.printStackTrace();
                } catch (IOException e){
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private Runnable receivedDataThread = new Runnable() {
        @Override
        public void run() {
            try{
                byte buffer[] = new byte[1024];
                int count = inputStream.read(buffer);
                String receivedData = new String(buffer,0,count);
                Message msg = handler.obtainMessage();
                msg.what = 2;
                msg.obj = receivedData;
                //handler.sendMessage(msg);

                Message msg2 = XHNetGlobal.msgCBHandler.obtainMessage();
                msg2.obj = receivedData;
                XHNetGlobal.msgCBHandler.sendMessage(msg2);
            } catch (IOException e){
                e.printStackTrace();
            }
        }
    };

    public static class IsAndOs{
        public InputStream is;
        public OutputStream os;
    }
}
