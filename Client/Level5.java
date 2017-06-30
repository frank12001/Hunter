package mobile.android.demo.bluetooth.chat;

import java.io.IOException;

import android.app.Activity;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.widget.TextView;

public class Level5 extends Activity {
 
	TextView txt;
	int index=0;
	MediaPlayer music1;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.level5);
		txt = (TextView)findViewById(R.id.level5textView1);
		music1 = MediaPlayer.create(this,R.raw.music19);
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
		 new CountDownTimer(6000,1000){
	            
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
	            		txt.setText("恭喜你已經拿到了封鎖秘密程式的寶箱"+"\n"+"在開啟寶箱時必須要小心"+"\n"+"若是一不小心放手或是開啟失敗"+"\n"+"造成大量雜音則可能會被管理人員發現"+"\n"+"而使任務失敗"+"\n"+"現在請先利用左右搖擺將密碼解除"+"\n"+"再小心翼翼的將鎖由下而上慢慢解開"+"\n"+"任務提示：途中請勿將手指離開鎖頭！");
	            		index++;
	            		break;
	            	default:
	            		break;
	            	}
	            	
	            }
	            
	        }.start();
	}
}
