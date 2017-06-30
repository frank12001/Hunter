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
	            	txt.setText("�A�w�g�i�J��F����ޫ����ʱ�����"+"\n"+"�ڭ̪��ؼЬO�æb��޺޲z�Ϫ��@��{��"+"\n"+"�A�⤤������M�w�I��m���p�F"+"\n"+"���N��ؼЩ|���i�J�d��"+"\n"+"����N��ؼб���"+"\n"+"����N��ؼФw�g�D�`����"+"\n"+"�{�b�ЧQ�ιp�F�t�Χ�X��޺޲z�Ϫ���m");
	            	index++;
	            	break;
	            	default:
	            		break;
	            	}
	            }
	            
	        }.start();
	}
	

}
