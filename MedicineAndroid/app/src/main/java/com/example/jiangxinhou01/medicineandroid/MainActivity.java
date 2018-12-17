package com.example.jiangxinhou01.medicineandroid;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.ViewPager;
import android.support.v4.view.PagerAdapter;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    private static Context context = null;
    private List<Fragment> fragments;
    private FragmentManager fragmentManager;

    private class FragmentAdaptor extends PagerAdapter{
        private List<Fragment> fragments;
        private Context mContext;
        public FragmentAdaptor(List<Fragment> frags, Context mContext){
            fragments = frags;
            this.mContext = mContext;
        }

        @Override
        public boolean isViewFromObject(@NonNull View view, @NonNull Object o) {
            return false;
        }

        @Override
        public int getCount(){
            return fragments.size();
        }
    }


    public static Context getContext(){
        return context;
    }

    // 底部导航事件
    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {
        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_home:
                    return true;
                case R.id.navigation_dashboard:
                    return true;
                case R.id.navigation_notifications:
                    return true;
            }
            return false;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();
        setUI();

        // 连接服务器
        ConnectSocket();

        // 服务器返回数据
        XHNetGlobal.msgCBHandler = new Handler(){
            public void handleMessage(Message msg){
                String dataStr = (String)msg.obj;
                XHGlobalTool.toastText("服务器返回数据："+dataStr);
                XHNetGlobal.getInstance().SendMessage("服务器你好！");
            }
        };
    }

    @Override
    protected void onDestroy(){
        super.onDestroy();
        DisConnectSocket();
    }

    // 初始化
    private void initUI(){
        context = getApplicationContext();
        // 底部导航事件注册
        BottomNavigationView navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);

        //fragments.add(new HomeFragment());

        // viewpager
        //ViewPager viewPager = (ViewPager)findViewById(R.id.viewPager);
        //FragmentAdaptor adaptor = new FragmentAdaptor(fragments, getContext());
        //viewPager.setAdapter(adaptor);
    }

    // UI配置
    private void setUI(){

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
