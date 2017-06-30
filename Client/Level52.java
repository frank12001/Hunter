package mobile.android.demo.bluetooth.chat;

import java.io.IOException;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AbsoluteLayout;
import android.widget.Button;
import android.widget.TextView;

@SuppressLint("NewApi")
public class Level52 extends Activity implements SensorEventListener{
  
	Button bt1;
	TextView txt1,txt2,txt3;
	MediaPlayer music1,music2;
	int number=0;
	boolean startgame=false;
	float touthY;
	String text;
    @SuppressLint({ "NewApi", "NewApi", "NewApi", "NewApi" })
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.level52);
           
        SensorManager sensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
        
        bt1 = (Button)findViewById(R.id.level52button1);
        
        
        bt1.setOnTouchListener(new Button.OnTouchListener(){

			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				touthY = arg1.getY();
				switch (arg1.getAction()){
				case MotionEvent.ACTION_DOWN:
			     	 startgame=true;
					 return true;
				case MotionEvent.ACTION_UP:
					 startgame=false;
					 if(bt1.getTop()>0&&bt1.getTop()<12){
						Intent rely = new Intent();
						setResult(RESULT_OK,rely);
						finish();
					 }else{
						 Intent rely = new Intent();
						 setResult(RESULT_CANCELED,rely);
						 finish();
					 }
					 return true;
				case MotionEvent.ACTION_MOVE:
					 if(number==16){
						 if(touthY<0){
							 bt1.setLayoutParams(new AbsoluteLayout.LayoutParams(bt1.getWidth(),bt1.getHeight(),(int)bt1.getLeft(), (int)touthY+bt1.getTop()));
                             if(bt1.getTop()>0&&bt1.getTop()<12){
                            	 if(music2!=null){
                    				 music2.stop();
                    			 }
                    			 try {
                					music2.prepare();
                				} catch (IllegalStateException e) {
                					// TODO Auto-generated catch block
                					e.printStackTrace();
                				} catch (IOException e) {
                					// TODO Auto-generated catch block
                					e.printStackTrace();
                				}
                    			 music2.start();
                             }
						 }
					 }
				}
				return false;
			}
        	 
        });
       
        music1 = MediaPlayer.create(this,R.raw.music);
        music2 = MediaPlayer.create(this,R.raw.music2);
        
        //Gyroscope
        sensorManager.registerListener(this,sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE),SensorManager.SENSOR_DELAY_GAME);
        //Orientation
        sensorManager.registerListener(this,sensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION),SensorManager.SENSOR_DELAY_GAME);
        
    }
    
    
   
    @SuppressLint({ "NewApi", "NewApi", "NewApi", "NewApi", "NewApi", "NewApi" })
	@Override
	public void onSensorChanged(SensorEvent event) {
		// TODO Auto-generated method stub
    	switch(event.sensor.getType())
    	{
    	  case Sensor.TYPE_ORIENTATION :
    		  if(startgame==true){
    		  if(number<=14){
    		  if((event.values[2]>0)&&(event.values[2]<1)){
    			 if(music1!=null){
    				 music1.stop();
    			 }
    			 try {
					music1.prepare();
				} catch (IllegalStateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
    			 music1.start();
    			 number++;
    		  }
    		 }else if(number==15){
    			 if(music2!=null){
    				 music2.stop();
    			 }
    			 try {
					music2.prepare();
				} catch (IllegalStateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
    			 music2.start();
    			 number++;
    		 
    		 }else {}
    	  }else {number=0;}
    		  break;
    	}
		
	}
	@Override
	public void onAccuracyChanged(Sensor arg0, int arg1) {
		// TODO Auto-generated method stub
		
	}

	
}
