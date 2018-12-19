package com.example.jiangxinhou01.medicineandroid.Tool;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.List;

public class NavFragmentPagerAdapter extends FragmentPagerAdapter {
    private List<Fragment> fragmentLst;
    private FragmentManager fragmentMgr;

    public NavFragmentPagerAdapter(FragmentManager fm, List<Fragment> lst){
        super(fm);
        fragmentLst = lst;
        fragmentMgr = fm;
    }

    @Override
    public int getCount(){
        return fragmentLst.size();
    }

    @Override
    public Fragment getItem(int i) {
        return fragmentLst.get(i);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }
}
