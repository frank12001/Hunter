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
    //alphaanim1淡入,alphaanim2淡出
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
	            	txt.append("\n"+"\n"+"準備好請點擊大門");
	            }

	            @Override
	            public void onTick(long millisUntilFinished) {
	            	switch (index){
	            	case 0:
	            		index++;
	            		break;
	            	case 1:
	            		txt.setTextColor(Color.WHITE);
	            		txt.setText("        有些時候"+"\n"+"\n"+"正義不見得是正義");
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
	            	    txt.setText("世道崩壞 "+"\n"+"政府與財團勾結狼狽"+"\n"+"人民生活於水深火熱之中"+"\n"+"為了防止人民增加智慧以抵抗政府"+"\n"+"世界政府決定將網際網路完全封鎖"+"\n"+"人民無法自由溝通"+"\n"+"也就無法叛變");
	            	    index++;
	            		break;
	            	case 4:
	            		txt.startAnimation(alphaanim2);
	            	    
	            	    index++;
	            		break;
	            	case 5:
	            		txt.setText("你是一名獵手"+"\n"+"現在正準備潛入政府科技指揮監控中心"+"\n"+"只要能夠獲得藏於其中的秘密"+"\n"+"就有能力能夠拯救這個世界");
	            	    index++;
	            		break;
	            	case 6:
	            		txt.startAnimation(alphaanim2);
	            	    index++;
	            		break;
	            	case 7:
	             	    txt.setText("      你    "+"\n"+"\n"+"做得到嗎");
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
	            		txt.setText("這裡是政府科技指揮中心大樓"+"\n"+"才是潛入的第一步");
	            	    index++;
	            		break;
	            	case 11:
	            		txt.setText("你必須要完成只有內部高科技人員才知道的問答"+"\n"+"才有辦法能夠潛入科技指揮監控中心"+"\n"+"準備好了嗎？");
	            	    index++;
	            	    startgame=true;
	            		break;
	            	}
	            	
	            }
	            
	        }.start();
	}
	

}
