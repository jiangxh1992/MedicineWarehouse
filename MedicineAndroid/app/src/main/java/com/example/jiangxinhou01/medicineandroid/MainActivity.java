package com.example.jiangxinhou01.medicineandroid;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.widget.TextView;
import android.widget.Toast;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.net.Socket;
import java.net.UnknownHostException;

public class MainActivity extends AppCompatActivity {

    private TextView mTextMessage;

    // Socket
    private final String SERVER_HOST_IP = "192.168.211.1";
    private final int SERVER_HOST_PORT = 9500;
    private Socket socket;
    private Thread thread;
    private OutputStream outStream;
    private InputStream inputStream;
    private String receive;

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_home:
                    mTextMessage.setText(R.string.title_home);
                    return true;
                case R.id.navigation_dashboard:
                    mTextMessage.setText(R.string.title_dashboard);
                    return true;
                case R.id.navigation_notifications:
                    mTextMessage.setText(R.string.title_notifications);
                    return true;
            }
            return false;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        mTextMessage = (TextView) findViewById(R.id.message);
        BottomNavigationView navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);

        initSocketClient();
    }

    private Handler handler = new Handler(){
        public void handleMessage(android.os.Message msg){
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
                        toastText("服务器数据收到！");
                    }
            }
        };
    };
    public void initSocketClient(){
        new Thread(new Runnable() {
            @Override
            public void run() {
                try{
                    socket = new Socket(SERVER_HOST_IP,SERVER_HOST_PORT);
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
                handler.sendMessage(msg);
            } catch (IOException e){
                e.printStackTrace();
            }
        }
    };

    // defaul toast
    public void toastText(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    public static class IsAndOs{
        public InputStream is;
        public OutputStream os;
    }
}
