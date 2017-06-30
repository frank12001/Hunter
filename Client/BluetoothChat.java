package mobile.android.demo.bluetooth.chat;


import java.io.IOException;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.inputmethod.EditorInfo;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;


@SuppressLint({ "NewApi", "NewApi", "NewApi", "NewApi", "NewApi", "NewApi", "NewApi" })
public class BluetoothChat extends Activity
{
 
	private static final String TAG = "BluetoothChat";
	private static final boolean D = true;

	public static final int MESSAGE_STATE_CHANGE = 1;
	public static final int MESSAGE_READ = 2;
	public static final int MESSAGE_WRITE = 3;
	public static final int MESSAGE_DEVICE_NAME = 4;
	public static final int MESSAGE_TOAST = 5;

	public static final String DEVICE_NAME = "device_name";
	public static final String TOAST = "toast";

	private static final int REQUEST_CONNECT_DEVICE = 1;
	private static final int REQUEST_ENABLE_BT = 2;

	private TextView mTitle;
	private ListView mConversationView;
	private EditText mOutEditText;
	private Button mSendButton;

	private String mConnectedDeviceName = null;
	private ArrayAdapter<String> mConversationArrayAdapter;
	private StringBuffer mOutStringBuffer;
	private BluetoothAdapter mBluetoothAdapter = null;
	private BluetoothChatService mChatService = null;
	
	int score=0,team=0,me=0;
	private ImageView numberimg;
	int whichpic=10;
	boolean startgame=false;
	Animation rotate;
	Button bt2;
	//測試score的TextView
	TextView txt;
	MediaPlayer music1;
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		if (D)
			Log.e(TAG, "+++ ON CREATE +++");

		requestWindowFeature(Window.FEATURE_CUSTOM_TITLE);
		setContentView(R.layout.main);
		getWindow().setFeatureInt(Window.FEATURE_CUSTOM_TITLE,
				R.layout.custom_title);
		music1 = MediaPlayer.create(this,R.raw.music16);
		musicStart();
		mTitle = (TextView) findViewById(R.id.title_left_text);
		mTitle.setText(R.string.app_name);
		mTitle = (TextView) findViewById(R.id.title_right_text);

		mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

		if (mBluetoothAdapter == null)
		{
			Toast.makeText(this, "目前手機不支援藍芽.",
					Toast.LENGTH_LONG).show();
			finish();
			return;
		}
	}

	@Override
	public void onStart()
	{
		super.onStart();
		if (D)
			Log.e(TAG, "++ ON START ++");

		if (!mBluetoothAdapter.isEnabled())
		{
			Intent enableIntent = new Intent(
					BluetoothAdapter.ACTION_REQUEST_ENABLE);
			startActivityForResult(enableIntent, REQUEST_ENABLE_BT);
		}
		else
		{
			if (mChatService == null)
				setupChat();
		}
	}

	@Override
	public synchronized void onResume()
	{
		super.onResume();
		if (D)
			Log.e(TAG, "+ ON RESUME +");

		if (mChatService != null)
		{
			if (mChatService.getState() == BluetoothChatService.STATE_NONE)
			{
				mChatService.start();
			}
		}
	}

	private void setupChat()
	{
		Log.d(TAG, "setupChat()");

		mConversationArrayAdapter = new ArrayAdapter<String>(this,
				R.layout.message);
		mConversationView = (ListView) findViewById(R.id.in);
		mConversationView.setAdapter(mConversationArrayAdapter);

		mOutEditText = (EditText) findViewById(R.id.edit_text_out);
		mOutEditText.setOnEditorActionListener(mWriteListener);
		
		txt = (TextView)findViewById(R.id.textView1);
		bt2 = (Button)findViewById(R.id.mainbutton2);
		
		numberimg = (ImageView)findViewById(R.id.imageView1);
		
		numberimg.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				startgame=true;
				timeStart();
			}
			
		});
        rotate = AnimationUtils.loadAnimation(this, R.anim.ratate1);
		mSendButton = (Button) findViewById(R.id.button_send);
		mSendButton.setOnClickListener(new OnClickListener()
		{
			public void onClick(View v)
			{
				mSendButton.startAnimation(rotate);
				String message = "1";
				sendMessage(message);
				if(startgame=true){
				score++;
				me++;
				}
			}
		});

		mChatService = new BluetoothChatService(this, mHandler);

		mOutStringBuffer = new StringBuffer("");
	}

	@Override
	public synchronized void onPause()
	{
		super.onPause();
		if (D)
			Log.e(TAG, "- ON PAUSE -");
	}

	@Override
	public void onStop()
	{
		super.onStop();
		if (D)
			Log.e(TAG, "-- ON STOP --");
	}

	@Override
	public void onDestroy()
	{
		super.onDestroy();
		if (mChatService != null)
			mChatService.stop();
		if (D)
			Log.e(TAG, "--- ON DESTROY ---");
	}

	private void ensureDiscoverable()
	{
		if (D)
			Log.d(TAG, "ensure discoverable");
		if (mBluetoothAdapter.getScanMode() != BluetoothAdapter.SCAN_MODE_CONNECTABLE_DISCOVERABLE)
		{
			Intent discoverableIntent = new Intent(
					BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE);
			discoverableIntent.putExtra(
					BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, 300);
			startActivity(discoverableIntent);
		}
	}

	private void sendMessage(String message)
	{
		if (mChatService.getState() != BluetoothChatService.STATE_CONNECTED)
		{
			Toast.makeText(this, R.string.not_connected, Toast.LENGTH_SHORT)
					.show();
			return;
		}

		if (message.length() > 0)
		{
			byte[] send = message.getBytes();
			mChatService.write(send);
			mOutStringBuffer.setLength(0);
			mOutEditText.setText(mOutStringBuffer);
		}
	}

	private TextView.OnEditorActionListener mWriteListener = new TextView.OnEditorActionListener()
	{
		public boolean onEditorAction(TextView view, int actionId,
				KeyEvent event)
		{
			if (actionId == EditorInfo.IME_NULL
					&& event.getAction() == KeyEvent.ACTION_UP)
			{
				String message = "1";
				sendMessage(message);
			}
			if (D)
				Log.i(TAG, "END onEditorAction");
			return true;
		}
	};

	private final Handler mHandler = new Handler()
	{
		@Override
		public void handleMessage(Message msg)
		{
			switch (msg.what)
			{
				case MESSAGE_STATE_CHANGE:
					if (D)
						Log.i(TAG, "MESSAGE_STATE_CHANGE: " + msg.arg1);
					switch (msg.arg1)
					{
						case BluetoothChatService.STATE_CONNECTED:
							mTitle.setText(R.string.title_connected_to);
							mTitle.append(mConnectedDeviceName);
							mConversationArrayAdapter.clear();
							break;
						case BluetoothChatService.STATE_CONNECTING:
							mTitle.setText(R.string.title_connecting);
							break;
						case BluetoothChatService.STATE_LISTEN:
						case BluetoothChatService.STATE_NONE:
							mTitle.setText(R.string.title_not_connected);
							break;
					}
					break;
				case MESSAGE_WRITE:
					byte[] writeBuf = (byte[]) msg.obj;
					String writeMessage = new String(writeBuf);
					//mConversationArrayAdapter.add("Me:  " + writeMessage);
					break;
				case MESSAGE_READ:
					byte[] readBuf = (byte[]) msg.obj;
					String readMessage = new String(readBuf, 0, msg.arg1);
					//mConversationArrayAdapter.add(mConnectedDeviceName + ":  "+ readMessage+score);
					if(startgame=true){
					bt2.startAnimation(rotate);	
					score++;
					team++;
					}
					break;
				case MESSAGE_DEVICE_NAME:
					mConnectedDeviceName = msg.getData().getString(DEVICE_NAME);
					Toast.makeText(getApplicationContext(),
							"Connected to " + mConnectedDeviceName,
							Toast.LENGTH_SHORT).show();
					break;
				case MESSAGE_TOAST:
					Toast.makeText(getApplicationContext(),
							msg.getData().getString(TOAST), Toast.LENGTH_SHORT)
							.show();
					break;
			}
		}
	};

	public void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		if (D)
			Log.d(TAG, "onActivityResult " + resultCode);
		switch (requestCode)
		{
			case REQUEST_CONNECT_DEVICE:
				if (resultCode == Activity.RESULT_OK)
				{
					String address = data.getExtras().getString(
							DeviceListActivity.EXTRA_DEVICE_ADDRESS);

					BluetoothDevice device = mBluetoothAdapter
							.getRemoteDevice(address);
					mChatService.connect(device);
				}
				break;
			case REQUEST_ENABLE_BT:
				if (resultCode == Activity.RESULT_OK)
				{
					setupChat();
				}
				else
				{
					Log.d(TAG, "BT not enabled");
					Toast.makeText(this, R.string.bt_not_enabled_leaving,
							Toast.LENGTH_SHORT).show();
					finish();
				}
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu)
	{
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.option_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
			case R.id.scan:
				Intent serverIntent = new Intent(this, DeviceListActivity.class);
				startActivityForResult(serverIntent, REQUEST_CONNECT_DEVICE);
				return true;
			case R.id.discoverable:
				ensureDiscoverable();
				return true;
		}
		return false;
	}


	public void timeStart(){
	    new CountDownTimer(11000,1000){
	    	
			@Override
			public void onFinish() {
				whichpic=10;
				startgame=false;
				txt.append(String.valueOf(score));
				//設定過關的圈數 ， 整隊的 參數是score
				if(score>10){
					 musicClose();
					 Intent rely = new Intent();
					 setResult(RESULT_OK,rely);
					 finish();
				}else{
					score=0;
					Intent rely = new Intent();
					setResult(RESULT_FIRST_USER,rely);
					finish();
				}
				
			}
 
			@Override
			public void onTick(long millisUntilFinished) {
				 switch (whichpic){
				 case 10:
					 startgame=true;
					 numberimg.setImageResource(R.drawable.number10);
					 break;
				 case 9:
					 numberimg.setImageResource(R.drawable.number9);
					 break;
				 case 8:
					 numberimg.setImageResource(R.drawable.number8);
					 break;
				 case 7:
					 numberimg.setImageResource(R.drawable.number7);
					 break;
				 case 6:
					 numberimg.setImageResource(R.drawable.number6);
					 break;
				 case 5:
					 numberimg.setImageResource(R.drawable.number5);
					 break;
				 case 4:
					 numberimg.setImageResource(R.drawable.number4);
					 break;
				 case 3:
					 numberimg.setImageResource(R.drawable.number3);
					 break;
				 case 2:
					 numberimg.setImageResource(R.drawable.number2);
					 break;
				 case 1:
					 numberimg.setImageResource(R.drawable.number1);
					 break;
				 }
				 whichpic--;
			}
	   	
	    }.start();
	    }
	public void musicStart(){
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
	public void musicClose(){
		if(music1!=null){
			 music1.stop();
		      }
	}

}