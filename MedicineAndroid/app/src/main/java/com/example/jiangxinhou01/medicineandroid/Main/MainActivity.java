package com.example.jiangxinhou01.medicineandroid.Main;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;

import com.example.jiangxinhou01.medicineandroid.Main.Login.AccountFormFragment;
import com.example.jiangxinhou01.medicineandroid.Main.Login.LoginFormFragment;
import com.example.jiangxinhou01.medicineandroid.Main.Login.SignInFormFragment;
import com.example.jiangxinhou01.medicineandroid.R;
import com.example.jiangxinhou01.medicineandroid.Tool.NavFragmentPagerAdapter;
import com.example.jiangxinhou01.medicineandroid.Tool.SocketService;
import com.example.jiangxinhou01.medicineandroid.Tool.XHGlobalTool;
import com.example.jiangxinhou01.medicineandroid.Tool.XHNetGlobal;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity
        implements FirstFragment.OnFragmentInteractionListener,
        LoginFragment.OnFragmentInteractionListener,
        HomeFragment.OnFragmentInteractionListener,
        AccountFormFragment.OnFragmentInteractionListener,
        LoginFormFragment.OnFragmentInteractionListener,
        SignInFormFragment.OnFragmentInteractionListener{

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
                case R.id.navigation_first:
                    viewpager.setCurrentItem(0);
                    return true;
                case R.id.navigation_login:
                    viewpager.setCurrentItem(1);
                    return true;
                case R.id.navigation_home:
                    viewpager.setCurrentItem(2);
                    return true;
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
        fragments.add(new LoginFragment());
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
