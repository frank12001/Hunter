package mobile.android.demo.bluetooth.chat;


import java.util.Timer;
import java.util.TimerTask;


import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;


public class Administrator extends Activity {
	Button bt1;
	String s;
	boolean firsttime=true;
    int clo = 0;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.administrator);
		
		
		bt1 = (Button)findViewById(R.id.adminbutton1);
		bt1.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {				
				Intent i = new Intent();
				i.setClass(Administrator.this,Level1.class);
				startActivityForResult(i,1);
				
			}
			
		});
		spark();
	}
	//RESULT_CANCELED<<回傳的第二種狀態
	//在Manifest 中加入 android:screenOrientation="landscape" 表示該class 以橫向顯示
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		switch(requestCode){
		case 1:
			if(resultCode == RESULT_OK){
				Bundle b = data.getExtras();
				Intent i = new Intent();
				i.setClass(Administrator.this,Level12.class);
				startActivityForResult(i,2);
			}
			break;
		case 2:
			if(resultCode == RESULT_OK){
			Bundle c = data.getExtras();
			Intent a = new Intent();
			a.setClass(Administrator.this,Level14.class);
			a.putExtra("key2",Integer.parseInt(c.getString("key1")) );
			startActivityForResult(a,3);
			}else if(resultCode == RESULT_CANCELED){
				Intent a = new Intent();
				a.setClass(Administrator.this,Level1false.class);
				startActivity(a);
			}
			break;
		case 3:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				a.setClass(Administrator.this,Level2.class);
				startActivityForResult(a,4);
				}  
			break;
		case 4:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				a.setClass(Administrator.this,RadarLevel2.class);
				startActivityForResult(a,5);
				}
			break;
		case 5:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				a.setClass(Administrator.this,Level3.class);
				startActivityForResult(a,6);
				}
			break;
		case 6:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				//暫時重 CameraLevel3.class 改成  Level4.class
				a.setClass(Administrator.this,CameraLevel3.class);
				startActivityForResult(a,7);
				} 
			break;
		case 7:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				a.setClass(Administrator.this,Level4.class);
				startActivityForResult(a,8);
				}else if(resultCode == RESULT_CANCELED){
					Intent a = new Intent();
					a.setClass(Administrator.this,CameraLevel3.class);
					startActivityForResult(a,7);
				}
			break;
		case 8:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				a.setClass(Administrator.this,BluetoothChat.class);
				startActivityForResult(a,9);
				}
			break;
		case 9:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				a.setClass(Administrator.this,Level5.class);
				startActivityForResult(a,10);
				}else if(resultCode == RESULT_FIRST_USER){
					Intent a = new Intent();
					a.setClass(Administrator.this,Level6ending2.class);
					startActivityForResult(a,12);
				}
			break;
		case 10:
			if(resultCode == RESULT_OK){
				Bundle c = data.getExtras();
				Intent a = new Intent();
				a.setClass(Administrator.this,Level52.class);
				startActivityForResult(a,11);
				}
			break;
		case 11:
			if(resultCode == RESULT_OK){
				Intent a = new Intent();
				a.setClass(Administrator.this,Level6ending.class);
				startActivityForResult(a,12);
				}else if(resultCode == RESULT_CANCELED){				
					Intent a = new Intent();
					a.setClass(Administrator.this,Level6ending2.class);
					startActivityForResult(a,12);
				}
			break;
		default:
			break;
		}
	}
	public void spark(){
		
		Timer timer = new Timer();
		TimerTask task = new TimerTask(){

			@Override
			public void run() {
				 runOnUiThread(new Runnable() {
                     public void run() {
                             if (clo == 0) {
                                     clo = 1;
                                     bt1.setTextColor(Color.TRANSPARENT);
                             } else {
                                     if (clo == 1) {
                                             clo = 2;
                                             bt1.setTextColor(Color.YELLOW);
                                     } else {
                                             clo = 0;
                                             bt1.setTextColor(Color.RED);
                                     }
                             }
                     }
             });
				
			}
			
		};
		timer.schedule(task, 1, 1000);
	}
	
	

   

}
