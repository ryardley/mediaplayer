package com.rudiyardley.player.controller.states
{
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.enums.MediaPlayerStates;
	import com.rudiyardley.reporting.Console;

	public class VideoLoadingState extends BaseState implements IState
	{
		
		override public function get name():String
		{
			return MediaPlayerStates.VIDEO_LOADING;
		}
		
		override public function onEnterState(lastState:String):void
		{
			super.onEnterState(lastState);
			
			Console.info(this,'onEnterState closing stream');
			//stream.close();
			Console.info(this,'playing url:' + currentMedia.url);
			waitingStatus = true;
			try
			{
				
				stream.play(currentMedia.url);
				
			}
			catch(e:Error)
			{
				trace('ERROR:'+e.message);
			}
			
			
			loadInfoTicker.start();
			volume = stream.soundTransform.volume;
		}
		
		
	}
}