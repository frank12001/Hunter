package mobile.android.demo.bluetooth.chat;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class Level4 extends Activity {
    
	RelativeLayout layout;
	int index=0;
	TextView txt;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.level4);
		layout = (RelativeLayout)findViewById(R.id.Level4Layout);
		txt = (TextView)findViewById(R.id.level4textView1);
		TimeStart();
	}  
	private void TimeStart(){
		 new CountDownTimer(10000,1000){
	            
	            @Override
	            public void onFinish() {	            	 
	            	Intent rely = new Intent();
					setResult(RESULT_OK,rely);
					finish();
	            }

	            @Override
	            public void onTick(long millisUntilFinished) {
	            	switch (index){
	            	case 0:
	            		index++;
	            		break;
	            	case 1:
	            	    layout.setBackgroundResource(R.drawable.level4img4);
	            	    txt.setText("監控系統內藏有一個藏寶庫"+"\n"+"這個寶庫只能利用自己的力量才能夠解開"+"\n"+"而我們所要找的機密程式正在裡面"+"\n"+"拿出你的實力"+"\n"+"將這個關卡突破吧");
	            	    index++;
	            	break;
	            	case 2:
	            		txt.append("\n"+"找個朋友一起玩吧？");
	            		index++;
	            	default:
	            		break;
	            	
	            	}
	            }
	            
	        }.start();
	}

}
