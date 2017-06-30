package mobile.android.demo.bluetooth.chat;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.net.Socket;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

public class CameraLevel3 extends Activity {
	private Bitmap bitmap1;
	TextView txt;
	byte[] bb;
	String currectS="48",str;
	int index=0;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.cameralevel3);
        txt = (TextView)findViewById(R.id.cameralevel3textView1);
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(intent,1);
    }
    public void LayoutClick(View v){
    	 Intent rely = new Intent();
		 setResult(RESULT_CANCELED,rely);
		 finish();
    }
    protected void onActivityResult(int requesCode, int resultCode,Intent data)
    {
    	if(requesCode == 1)
    	{
    		if(resultCode == Activity.RESULT_OK)
    		{
    			Bitmap b = (Bitmap)data.getExtras().get("data");
    			int h = b.getHeight();
    			int w = b.getWidth();
    			bitmap1 = Bitmap.createBitmap(w, h, Config.ARGB_8888);
    			
    			for(int i = 1;i < w;i++)
    				for(int j = 1;j < h;j++)			
				            bitmap1.setPixel(i, j, b.getPixel(i, j));
    			
    			ByteArrayOutputStream stream = new ByteArrayOutputStream();
    			bitmap1.compress(Bitmap.CompressFormat.JPEG,100 , stream);
    			bb = stream.toByteArray();
    			
    			Thread t = new thread();
     			t.start();
    		}
    	}
    	super.onActivityResult( requesCode , resultCode, data);
    }
    private Handler hand = new Handler(){

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			msg.getData();    		
			txt.setText((CharSequence) msg.getData().get("key"));
			str = msg.getData().get("key").toString();
			if(str.equals(currectS)==true){
				txt.setText("     圖像解鎖正確"+"\n"+"管制監控系統即將解除");
				GoNext();
			}else{
				txt.setText("   警告：圖像錯誤！圖像錯誤！"+"\n"+"\n"+"請盡速拍攝另一個畫面以免被逮捕"+"\n"+"\n"+"        點擊螢幕重拍");				
			}
			
		}
    	
    };
    private void GoNext(){
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
	            		index++;
	            		break;
	            	}
	            }
	            
	        }.start();
	}
    class thread extends Thread{

		@Override
		public void run() {
			
			try
			{
				Socket socket = new Socket("192.168.1.67",3000 );
                DataOutputStream out = new DataOutputStream(new BufferedOutputStream(socket.getOutputStream()));
                                     
                int k=bb.length;
                String sx = String.valueOf(k);
                byte[] dd = sx.getBytes();
                
                out.write(dd);
                
                byte[] cc=new byte[1];  cc[0]=10;
                out.write(cc);
                
                out.write(bb);
                
              
                out.flush();
                
                InputStream is = socket.getInputStream();
       		    int ans = is.read();
       		    String s3 = Integer.toString(ans); 		    
                out.close();
                Message msg = new Message();
                Bundle bundle = new Bundle();
                bundle.putString("key", s3);
                msg.setData(bundle);
                hand.sendMessage(msg);
                
			}
			catch(Exception e)
			{
				Toast.makeText(getApplicationContext(),"mistake",Toast.LENGTH_SHORT).show(); 
			}
		}
		
	}
    
}