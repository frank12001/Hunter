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
	            		Question.setText("�b�𪬵��c���A�ܤ֭n���@�S�w�`�I�٬� ? ");
	        		    CK1.setText("��(root)");
	        		    CK2.setText("���I(top)");
	        		    CK3.setText("�D�`�I(main)");
	            		WhichAns++;
	            		break;
	            	case 1:                  
	                    if(CK1.isChecked()){TotalScore++;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		
	                    WhichAns++;
	        		    Question.setText("�Ĥ@�Ӫ���ɦV�y������ ? ");
	        		    CK1.setText("C");
	        		    CK2.setText("small talk");
	        		    CK3.setText("PASCAL");
	                    break;
	            	case 2:
	            		if(CK1.isChecked()){TotalScore--;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore++;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("�U�C��̬���Ķ���y��(Interpreted Languages) ? ");
	            		 CK1.setText("Delphi");
		        		 CK2.setText("ABAP");
		        		 CK3.setText("C++");
	            		 break;
	            	case 3:
	            		if(CK1.isChecked()){TotalScore--;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore++;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("�U�C��̫D<����ɦV>�y��  ? ");
	            		 CK1.setText("C++");
		        		 CK2.setText("Delphi");
		        		 CK3.setText("Java");
	            		 break;
	            	case 4: 
	            		if(CK1.isChecked()){TotalScore++;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("�U�C�����D���|(Stack)�ƨ� ? ");
	            		 CK1.setText("�ƶ��R��");
		        		 CK2.setText("��n��");
		        		 CK3.setText("�\�Фl");
	            		 break;
	            	case 5:
	            		if(CK1.isChecked()){TotalScore++;CK1.setChecked(false);}
	                    if(CK2.isChecked()){TotalScore--;CK2.setChecked(false);}
	                    if(CK3.isChecked()){TotalScore--;CK3.setChecked(false);}
	            		 WhichAns++;
	            		 Question.setText("                                 ��襤 1 2 3    ");
	            		 CK1.setText("�ڭ̬O");
		        		 CK2.setText("��ިt");
		        		 CK3.setText("���M�Ĥ���");
	            		 break;
	            	}
	            }
	            
	        }.start();
	}

}
