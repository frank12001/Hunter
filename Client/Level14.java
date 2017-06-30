package mobile.android.demo.bluetooth.chat;

import java.io.IOException;

import android.app.Activity;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.TextView;

public class Level14 extends Activity {
	 
    int score=0,index=0;
    String s;
    TextView top,down;
    MediaPlayer music1,music2;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.level14);
		top = (TextView)findViewById(R.id.level14textView1);
		down= (TextView)findViewById(R.id.level14textView2);
		music1 = MediaPlayer.create(this,R.raw.sound94);
		music2 = MediaPlayer.create(this,R.raw.sound92);
		Intent i = this.getIntent();
        score = i.getIntExtra("key2", 1);
		if(score<=1){
			top.setText("EEEEEEEE");
			down.setText("���I�z");
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
		}else if(score>=2&&score<=3){
			top.setText("AAA");
			down.setText("�{�Ҧ��\");
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
		}else if(score>=4&&score<=5){
			top.setText("SSS");
			down.setText("�A�O��");
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
		}
		TimeStart();
	}
	public void level14onclick(View v){
		Intent rely = new Intent();
		setResult(RESULT_OK,rely);
		finish();
	}
	private void TimeStart(){
		 new CountDownTimer(3000,1000){
	            
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
	            		if(score<=1){
	            			top.setText("\n"+"�A���ӬO�s�Ӫ��a�H  ");
	            			down.setText("   �h�m�m�n�ܡH");
	            		}else if(score>=2&&score<=3){
	            			top.setText("\n"+" �q�L�{�ҡA�гq�L�C  ");
	            			down.setText("");
	            		}else if(score>=4&&score<=5){
	            			top.setText(" ��ӬO��  ");
	            			down.setText(" �Э�̧ڭ̪��M���q !!");
	            		}
	            		index++;
	            		break;
	            	}
	            }
	            
	        }.start();
	}
	

}
