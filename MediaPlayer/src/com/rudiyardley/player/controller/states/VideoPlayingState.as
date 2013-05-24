package com.rudiyardley.player.controller.states
{
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.enums.MediaPlayerStates;
	import com.rudiyardley.reporting.Console;

	public class VideoPlayingState extends BaseState implements IState
	{
		
		override public function get name():String
		{
			return MediaPlayerStates.VIDEO_PLAYING;
		}
		
		override public function onEnterState(lastState:String):void
		{
			super.onEnterState(lastState);
			waitingStatus = false;
			switch(lastState)
			{
				case MediaPlayerStates.VIDEO_PAUSED:
				case MediaPlayerStates.VIDEO_SEEK:
					stream.resume();
					break;
			}
			playbackMovedTicker.start();
		}
		
		override public function onExitState(nextState:String):void
		{
			super.onExitState(nextState);
			playbackMovedTicker.stop();
		}
		
		override public function pause():void
		{
			super.pause();
			state = MediaPlayerStates.VIDEO_PAUSED;
		};
	}
}