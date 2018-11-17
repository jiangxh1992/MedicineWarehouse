package com.example.xinhou.medicinewarehouseandroid;

import android.content.ServiceConnection;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;
import android.content.ComponentName;
import android.os.IBinder;
import android.content.Intent;



public class MainActivity extends AppCompatActivity {
    private TextView txt_output = null;

    private ServiceConnection sc;
    public SocketService socketService;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        txt_output.setText("socket connected!");
    }

    @Override
    public void onBackPressed() {
        System.exit(0);
    }

    private void bindSocketService() {

        /*通过binder拿到service*/
        sc = new ServiceConnection() {
            @Override
            public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
                SocketService.SocketBinder binder = (SocketService.SocketBinder) iBinder;
                socketService = binder.getService();

            }

            @Override
            public void onServiceDisconnected(ComponentName componentName) {

            }
        };


        Intent intent = new Intent(getApplicationContext(), SocketService.class);
        bindService(intent, sc, BIND_AUTO_CREATE);
    }

    //@OnClick(R.id.sendBtn)
    public void onViewClicked() {

        //String data = contentEt.getText().toString().trim();

        //socketService.sendOrder(data);
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();

        unbindService(sc);

        Intent intent = new Intent(getApplicationContext(), SocketService.class);

        stopService(intent);

    }
}
