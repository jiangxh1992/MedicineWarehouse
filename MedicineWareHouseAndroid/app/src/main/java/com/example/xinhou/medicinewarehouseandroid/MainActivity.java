package com.example.xinhou.medicinewarehouseandroid;

import android.content.ServiceConnection;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.content.ComponentName;
import android.os.IBinder;
import android.content.Intent;


public class MainActivity extends AppCompatActivity {
    private TextView txt_output = null;
    private Button btn_go = null;

    private ServiceConnection sc;
    public SocketService socketService;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        bindSocketService();

        txt_output = (TextView)findViewById(R.id.mw_output);
        txt_output.setText("socket connected!");
        btn_go = (Button)findViewById(R.id.button);
        btn_go.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                socketService.sendOrder("123321test");
            }
        });
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

    @Override
    protected void onDestroy() {
        super.onDestroy();

        unbindService(sc);

        Intent intent = new Intent(getApplicationContext(), SocketService.class);

        stopService(intent);

    }
}
