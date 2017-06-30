package mobile.android.demo.bluetooth.chat;



import java.io.IOException;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Service;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.drawable.AnimationDrawable;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Vibrator;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.TextView;

public class RadarLevel2 extends Activity {
	public BluetoothAdapter blueAdapter;
	public BluetoothDevice device;
	public short rssi=0,rssi2=0;
	public final String address="94:CE:2C:12:C9:09";
	//94:CE:2C:12:C9:09 �ڪ������m  �s���
	//E0:63:E5:A2:FA:46 �p�۪������m
	public TextView txt;
	int index = 0,index2 =0,arryindex=0;
	Thread thread;
	Vibrator myVibrator;
	AnimationDrawable anim,anim2;
	Animation anim3,anim4;
	ImageView animimg;
	@SuppressLint("NewApi")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.radar);

		//���ʵe
		anim3 = AnimationUtils.loadAnimation(this, R.anim.radarscale);
		anim4 = AnimationUtils.loadAnimation(this, R.anim.radarscaletosmall);
		animimg = (ImageView)findViewById(R.id.radarimageView1);
		
		
		txt =(TextView)findViewById(R.id.radartextView1);
		myVibrator = (Vibrator) getApplication().getSystemService(Service.VIBRATOR_SERVICE);
		
		blueAdapter = BluetoothAdapter.getDefaultAdapter();
    	IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
		this.registerReceiver(receiver, filter);
		filter = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
		this.registerReceiver(receiver, filter);
		
	}
	@SuppressLint({ "NewApi", "NewApi", "NewApi" })
	public void LayoutClick(View v){
		index2++;
		if (blueAdapter.isDiscovering())
		{
			blueAdapter.cancelDiscovery();
		} 
		blueAdapter.startDiscovery();
		animimg.setImageResource(R.drawable.radaranim1);         
		animimg.startAnimation(anim3);
        
	}
	private final BroadcastReceiver receiver = new BroadcastReceiver(){
		@SuppressLint("NewApi")
		@Override
		public void onReceive(Context arg0, Intent arg1) {
			String action = arg1.getAction();
			
			if(BluetoothDevice.ACTION_FOUND.equals(action)){
				device = arg1.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
				
				if(device.getAddress().equals(address)){
			       rssi = arg1.getShortExtra(BluetoothDevice.EXTRA_RSSI, Short.MIN_VALUE);	
			       txt.append(Short.toString(rssi));
			       //�^�Ӫ��ʵe�w�p��o�C           
			       if(rssi>-30){
			    	   //���O���� -30
			    	   //������� -55
			    	   Intent rely = new Intent();
					   RadarLevel2.this.setResult(RESULT_OK,rely);
					   finish();
			       }else if(rssi<=-30&&rssi>-50){
			    	   //���O���� -30 -50 
			    	   //����O     -55 -75
			    	   animimg.setImageResource(R.drawable.radaranim1red); 
			    	   animimg.startAnimation(anim4);
			       }else if(rssi<=-50&&rssi>-70){
			    	       //���O�����A�令-50 -70
			    	       //����O    �A �令-75 -100 
			    	  animimg.setImageResource(R.drawable.radaranim1yellow); 
			    	  animimg.startAnimation(anim4);
			       }else{
			    	    animimg.startAnimation(anim4);
			       }
			    	   
				}
			}
	       
		 index++; 
		}
		
	};
	
	
}