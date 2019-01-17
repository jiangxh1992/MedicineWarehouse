package com.example.jiangxinhou01.medicineandroid.Main.Login;

import android.annotation.SuppressLint;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.example.jiangxinhou01.medicineandroid.R;
import com.example.jiangxinhou01.medicineandroid.Tool.AccountGlobal;
import com.example.jiangxinhou01.medicineandroid.Tool.XHGlobalTool;
import com.example.jiangxinhou01.medicineandroid.Tool.XHNetGlobal;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link SignInFormFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link SignInFormFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class SignInFormFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    private EditText input_username;
    private EditText input_password;
    private EditText input_confirm;
    private Button btn_sginin;

    public SignInFormFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment SignInFormFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static SignInFormFragment newInstance(String param1, String param2) {
        SignInFormFragment fragment = new SignInFormFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_sign_in_form, container, false);
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnFragmentInteractionListener) {
            mListener = (OnFragmentInteractionListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }

    @SuppressLint("HandlerLeak")
    @Override
    public void onStart() {
        super.onStart();
        input_username = (EditText)getView().findViewById(R.id.input_signin_username);
        input_password = (EditText)getView().findViewById(R.id.input_signin_password);
        input_confirm = (EditText)getView().findViewById(R.id.input_signin_confirm);
        btn_sginin = (Button)getView().findViewById(R.id.btn_signin_signin);

        btn_sginin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String username = input_username.getText().toString();
                String password = input_password.getText().toString();
                String confirm = input_confirm.getText().toString();
                if(password.length() <= 0 || confirm.length() <= 0){
                    XHGlobalTool.toastText("输入不能为空！");
                    return;
                }
                if(password != confirm){
                    XHGlobalTool.toastText("密码两次输入不一致！");
                    return;
                }

                JSONObject jsonObj = new JSONObject();
                try{
                    jsonObj.put("type",100);
                    jsonObj.put("name",username);
                    jsonObj.put("password",password);
                    XHNetGlobal.getInstance().SendMessage(jsonObj.toString());
                }catch (JSONException e){
                    e.printStackTrace();
                }
            }
        });

        if(XHNetGlobal.msgHandlerSignin == null){
            // 服务器响应
            XHNetGlobal.msgHandlerSignin  = new Handler(){
                public void handleMessage(Message msg){
                    String jsonStr = (String)msg.obj;
                    try{
                        JSONObject json = new JSONObject(jsonStr);
                        if(json.getInt("status") == 0){
                            XHGlobalTool.toastText("注册成功！");
                            ViewPager viewPager = (ViewPager)getParentFragment().getView().findViewById(R.id.loginViewPager);
                            viewPager.setCurrentItem(1);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                    }
                }
            };
        }
    }
}