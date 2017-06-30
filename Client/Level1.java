package mobile.android.demo.bluetooth.chat;

 
import java.io.IOException;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class Level1 extends Activity {
	
    RelativeLayout level1;
    TextView txt;
    ImageView img;
    int index=0,index2=0;
    Animation alphaanim1,alphaanim2;
    //alphaanim1�H�J,alphaanim2�H�X
    MediaPlayer music1;
    boolean startgame=false;
	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.level1);
		txt = (TextView)findViewById(R.id.level1textView2);
		img = (ImageView)findViewById(R.id.level1imageView2);
		alphaanim1 = AnimationUtils.loadAnimation(this, R.anim.alphaanim2);
		alphaanim2 = AnimationUtils.loadAnimation(this, R.anim.alphaanim);
		music1 = MediaPlayer.create(this,R.raw.music16);
		level1 = (RelativeLayout)findViewById(R.id.RelativeLayout1);
		
		level1.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				if(startgame==true){
					TimeNext();
				}
			}
			 
		});
		TimeStart();
	}
	private void TimeNext(){
		 new CountDownTimer(5000,1000){
	            
	            @Override
	            public void onFinish() {	            	 
	            	Intent rely = new Intent();
					setResult(RESULT_OK,rely);
					finish();
	            }

	            @Override
	            public void onTick(long millisUntilFinished) {
	            	switch (index2){
	            	case 0:
	            		txt.setText("");
	            		img.setImageResource(R.drawable.number3);
	            		index2++;
	            		break;
	            	case 1:
	            		img.setImageResource(R.drawable.number2);
	            		index2++;
	            		break;
	            	case 2:
	            		img.setImageResource(R.drawable.number1);
	            		index2++;
	            		break;
	            	}
	            }
	            
	        }.start();
	}
	private void TimeStart(){
		 new CountDownTimer(39000,3000){
	            
	            @Override
	            public void onFinish() {
	            	txt.append("\n"+"\n"+"�ǳƦn���I���j��");
	            }

	            @Override
	            public void onTick(long millisUntilFinished) {
	            	switch (index){
	            	case 0:
	            		index++;
	            		break;
	            	case 1:
	            		txt.setTextColor(Color.WHITE);
	            		txt.setText("        ���Ǯɭ�"+"\n"+"\n"+"���q�����o�O���q");
	            		index++;
	            		break;
	            	case 2:
	            		txt.startAnimation(alphaanim2);	
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
	            		index++;
	            		break;
	            	case 3:	            		
	            	    txt.setText("�@�D�Y�a "+"\n"+"�F���P�]�Τĵ��T�V"+"\n"+"�H���ͬ�����`��������"+"\n"+"���F����H���W�[���z�H��ܬF��"+"\n"+"�@�ɬF���M�w�N���ں�����������"+"\n"+"�H���L�k�ۥѷ��q"+"\n"+"�]�N�L�k�q��");
	            	    index++;
	            		break;
	            	case 4:
	            		txt.startAnimation(alphaanim2);
	            	    
	            	    index++;
	            		break;
	            	case 5:
	            		txt.setText("�A�O�@�W�y��"+"\n"+"�{�b���ǳƼ�J�F����ޫ����ʱ�����"+"\n"+"�u�n�����o�é�䤤�����K"+"\n"+"�N����O����@�ϳo�ӥ@��");
	            	    index++;
	            		break;
	            	case 6:
	            		txt.startAnimation(alphaanim2);
	            	    index++;
	            		break;
	            	case 7:
	             	    txt.setText("      �A    "+"\n"+"\n"+"���o���");
	            	    index++;
	            		break;
	            	case 8:
	            		txt.startAnimation(alphaanim2);
	            		if(music1!=null){
		       				 music1.stop();
		       			      }
	            	    index++;
	            		break;
	            	case 9:
	            		txt.setText("");
	            		level1.setBackgroundResource(R.drawable.level1img1);	            		
	            	    index++;
	            		break;
	            	case 10:
	            		txt.setText("�o�̬O�F����ޫ������ߤj��"+"\n"+"�~�O��J���Ĥ@�B");
	            	    index++;
	            		break;
	            	case 11:
	            		txt.setText("�A�����n�����u����������ޤH���~���D���ݵ�"+"\n"+"�~����k�����J��ޫ����ʱ�����"+"\n"+"�ǳƦn�F�ܡH");
	            	    index++;
	            	    startgame=true;
	            		break;
	            	}
	            	
	            }
	            
	        }.start();
	}
	

}
