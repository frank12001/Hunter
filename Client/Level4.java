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
	            	    txt.setText("�ʱ��t�Τ��æ��@�����_�w"+"\n"+"�o���_�w�u��Q�Φۤv���O�q�~����Ѷ}"+"\n"+"�ӧڭ̩ҭn�䪺���K�{�����b�̭�"+"\n"+"���X�A����O"+"\n"+"�N�o�����d��}�a");
	            	    index++;
	            	break;
	            	case 2:
	            		txt.append("\n"+"��ӪB�ͤ@�_���a�H");
	            		index++;
	            	default:
	            		break;
	            	
	            	}
	            }
	            
	        }.start();
	}

}
