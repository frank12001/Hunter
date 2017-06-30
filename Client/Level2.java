package mobile.android.demo.bluetooth.chat;

import java.io.IOException;

import android.app.Activity;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.widget.TextView;

public class Level2 extends Activity {
	TextView txt;
	MediaPlayer music1;
	int index=0;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.level2);
		txt = (TextView)findViewById(R.id.level2textView1);
		music1 = MediaPlayer.create(this,R.raw.music07);
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
		TimeStart();
	}
	private void TimeStart(){
		 new CountDownTimer(23000,1000){
	            
	            @Override
	            public void onFinish() {	
	            	if(music1!=null){
						 music1.stop();
					      }
	            	Intent rely = new Intent();
					setResult(RESULT_OK,rely);
					finish();
					
	            }

	            @Override
	            public void onTick(long millisUntilFinished) {
	            	switch (index){
	            	case 0:
	            	txt.setText("你已經進入到政府科技指揮監控中心"+"\n"+"我們的目標是藏在科技管理區的一支程式"+"\n"+"你手中握有找尋定點位置的雷達"+"\n"+"綠色代表目標尚未進入範圍內"+"\n"+"黃色代表目標接近中"+"\n"+"紅色代表目標已經非常接近"+"\n"+"現在請利用雷達系統找出科技管理區的位置");
	            	index++;
	            	break;
	            	default:
	            		break;
	            	}
	            }
	            
	        }.start();
	}
	

}
