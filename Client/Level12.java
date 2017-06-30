package mobile.android.demo.bluetooth.chat;


import java.io.IOException;

import android.app.Activity;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;

public class Level12 extends Activity {
	
	public CheckBox CK1,CK2,CK3;
	int TotalScore=0,WhichAns=0;
	TextView Question;
	String Evalute;
	MediaPlayer music1;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.level13);
		Question = (TextView)findViewById(R.id.level13textView1);
		CK1 = (CheckBox)findViewById(R.id.level13checkBox1);
		CK2 = (CheckBox)findViewById(R.id.level13checkBox2);
		CK3 = (CheckBox)findViewById(R.id.level13checkBox3);
		music1 = MediaPlayer.create(this,R.raw.music20);
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
	public void TimeStart(){
		 new CountDownTimer(21000,3000){
	            
	            @Override
	            public void onFinish() {
	            	if(music1!=null){
	   				 music1.stop();
	   			      }
	            	if(TotalScore>=0){ 
	            	Intent rely = new Intent();
					Bundle bundle = new Bundle();
					bundle.putString("key1",String.valueOf(TotalScore));
					rely.putExtras(bundle);
					setResult(RESULT_OK,rely);
					finish();
	            	}else{	            	
	            	Intent rely = new Intent();
					Bundle bundle = new Bundle();
					bundle.putString("key1",String.valueOf(TotalScore));
					rely.putExtras(bundle);
					setResult(RESULT_CANCELED,rely);
					finish();
					}
	            }

	            @Override
	            public void onTick(long millisUntilFinished) {
	            	switch (WhichAns){
	            	case 0:
	            		Question.setText("在樹狀結構中，至少要有一特定節點稱為 ? ");
	        		    CK1.setText("根(root)");
	        		    CK2.setText("頂點(top)");
	        		    CK3.setText("主節點(main)");
	            		WhichAns++;
	            		break;
	            	case 1:                  
	                    if(CK1.isChecked()){TotalScore++;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		
	                    WhichAns++;
	        		    Question.setText("第一個物件導向語言為何 ? ");
	        		    CK1.setText("C");
	        		    CK2.setText("small talk");
	        		    CK3.setText("PASCAL");
	                    break;
	            	case 2:
	            		if(CK1.isChecked()){TotalScore--;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore++;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("下列何者為直譯式語言(Interpreted Languages) ? ");
	            		 CK1.setText("Delphi");
		        		 CK2.setText("ABAP");
		        		 CK3.setText("C++");
	            		 break;
	            	case 3:
	            		if(CK1.isChecked()){TotalScore--;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore++;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("下列何者非<物件導向>語言  ? ");
	            		 CK1.setText("C++");
		        		 CK2.setText("Delphi");
		        		 CK3.setText("Java");
	            		 break;
	            	case 4: 
	            		if(CK1.isChecked()){TotalScore++;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("下列哪項非堆疊(Stack)事例 ? ");
	            		 CK1.setText("排隊買票");
		        		 CK2.setText("堆積木");
		        		 CK3.setText("蓋房子");
	            		 break;
	            	case 5:
	            		if(CK1.isChecked()){TotalScore++;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("                                 批改中 1 2 3    ");
	            		 CK1.setText("我們是");
		        		 CK2.setText("資管系");
		        		 CK3.setText("畢專第六組");
	            		 break;
	            	}
	            }
	            
	        }.start();
	}

}
