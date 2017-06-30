package mobile.android.demo.bluetooth.chat;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class Level3 extends Activity {
	
    RelativeLayout layout;
    TextView txt;
    int index=0;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.level3);
		layout = (RelativeLayout)findViewById(R.id.level3Layout);
		txt = (TextView)findViewById(R.id.level3textView1);
		TimeStart();
	}
	public void level3click(View v){
		Intent rely = new Intent();
		setResult(RESULT_OK,rely);
		finish();
	} 
	public void TimeStart(){
		 new CountDownTimer(15000,3000){
	            
	            @Override
	            public void onFinish() {	            	 
	            	Intent rely = new Intent();
					Bundle bundle = new Bundle();
					rely.putExtras(bundle);
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
	            	    layout.setBackgroundResource(R.drawable.level3img2);
	            	    txt.setText("�A�ثe���b��޺޲z�ި�ϥ~"+"\n"+"�b��W�����W�C��f�t�X���ϧ�"+"\n"+"�䤤���@�ӬO�i�J��޺޲z�Ϫ����T�K�X"+"\n"+"�иյۥηӬ۾��ǰe�{�ҹϧ�"+"\n"+"�H�i�J��޺޲z�Ϥ�");
	            	    index++;
	            	break;
	            	case 2:
	            	    index++;
	            	break;

	            	}

	            }
	            
	        }.start();
	}
	

}
