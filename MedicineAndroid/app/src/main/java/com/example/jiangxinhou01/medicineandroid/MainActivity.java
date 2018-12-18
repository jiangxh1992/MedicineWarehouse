package com.example.jiangxinhou01.medicineandroid;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity
        implements FirstFragment.OnFragmentInteractionListener,
        HomeFragment.OnFragmentInteractionListener {

    private ViewPager viewpager;
    private List<Fragment>fragments;

    private static Context context = null;
    public static Context getContext(){
        return context;
    }

    // 底部导航事件
    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {
        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_operation:
                    viewpager.setCurrentItem(0);
                    return true;
                case R.id.navigation_account:
                    viewpager.setCurrentItem(1);
                    return true;
                //case R.id.navigation_server:
                  //  viewpager.setCurrentItem(2);
                    //return true;
            }
            return false;
        }
    };

    @Override
    public void onFragmentInteraction(Uri uri) {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();

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

        initViewPager();
    }

    private void initViewPager(){
        viewpager = (ViewPager)findViewById(R.id.viewPager);
        fragments = new ArrayList<Fragment>();
        fragments.add(new FirstFragment());
        fragments.add(new HomeFragment());

        FragmentManager fm = getSupportFragmentManager();
        NavFragmentPagerAdapter fragmentAdapt = new NavFragmentPagerAdapter(fm,fragments);
        viewpager.setAdapter(fragmentAdapt);
        viewpager.setCurrentItem(0);
    }

    public void ConnectSocket(){
        if(XHNetGlobal.getInstance().IsSocketConnected()) {
            XHGlobalTool.toastText("服务器已连接");
        }

        Intent intent = new Intent(getContext(), SocketService.class);
        bindService(intent, XHNetGlobal.getInstance().serviceConnection, BIND_AUTO_CREATE);
    }

    public void DisConnectSocket(){
        if(XHNetGlobal.getInstance().IsSocketConnected()){
            unbindService(XHNetGlobal.getInstance().serviceConnection);
            Intent intent = new Intent(getContext(), SocketService.class);
            stopService(intent);
        }
        XHGlobalTool.toastText("服务器已经断开");
    }
}
