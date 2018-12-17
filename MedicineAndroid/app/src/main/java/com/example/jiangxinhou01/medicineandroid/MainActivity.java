package com.example.jiangxinhou01.medicineandroid;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MenuItem;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private static Context context = null;
    private TextView mTextMessage;

    public static Context getContext(){
        return context;
    }
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
        context = getApplicationContext();
        mTextMessage = (TextView) findViewById(R.id.message);
        BottomNavigationView navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);

        // 连接服务器
        ConnectSocket();

        //XHNetGlobal.getInstance().SendMessage("服务器你好！");

        XHNetGlobal.msgCBHandler = new Handler(){
            public void handleMessage(Message msg){
                String dataStr = (String)msg.obj;
                XHGlobalTool.toastText("服务器返回数据："+dataStr);
            }
        };
    }

    @Override
    protected void onDestroy(){
        super.onDestroy();
        DisConnectSocket();
    }

    private void ConnectSocket(){
        Intent intent = new Intent(getContext(), SocketService.class);
        bindService(intent, XHNetGlobal.getInstance().serviceConnection, BIND_AUTO_CREATE);
    }

    private void DisConnectSocket(){
        unbindService(XHNetGlobal.getInstance().serviceConnection);
        Intent intent = new Intent(getContext(), SocketService.class);
        stopService(intent);
    }
}
