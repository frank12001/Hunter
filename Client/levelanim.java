package mobile.android.demo.bluetooth.chat;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.widget.MediaController;
import android.widget.VideoView;

public class levelanim extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.levelanim);
		VideoView video = (VideoView)findViewById(R.id.videoView1);
		MediaController mc = new MediaController(this);
		video.setMediaController(mc);
		video.setVideoURI(Uri.parse("android.resource://"+getPackageName()+"/"+R.raw.movie1));
		video.start();  
		TimeStart();
	}
	private void TimeStart(){
		 new CountDownTimer(7000,7000){
	            
	            @Override
	            public void onFinish() {	            	 
	            	Intent rely = new Intent();
	            	rely.setClass(levelanim.this, Administrator.class);
	            	startActivity(rely);
	            }

	            @Override
	            public void onTick(long millisUntilFinished) {
	            	
	            }
	            
	        }.start();
	

     }
}
