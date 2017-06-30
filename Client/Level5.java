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
	            		txt.setText("���ߧA�w�g����F���꯵�K�{�����_�c"+"\n"+"�b�}���_�c�ɥ����n�p��"+"\n"+"�Y�O�@���p�ߩ��άO�}�ҥ���"+"\n"+"�y���j�q�����h�i��|�Q�޲z�H���o�{"+"\n"+"�Өϥ��ȥ���"+"\n"+"�{�b�Х��Q�Υ��k�n�\�N�K�X�Ѱ�"+"\n"+"�A�p���l�l���N��ѤU�ӤW�C�C�Ѷ}"+"\n"+"���ȴ��ܡG�~���ФűN������}���Y�I");
	            		index++;
	            		break;
	            	default:
	            		break;
	            	}
	            	
	            }
	            
	        }.start();
	}
}
