package com.rudiyardley.player.controller.states
{
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.controller.MediaPlayerController;
	import com.rudiyardley.player.enums.MediaPlayerStates;
	import com.rudiyardley.reporting.Console;

	public class VideoPausedState extends BaseState implements IState
	{
		
		override public function get name():String
		{
			return MediaPlayerStates.VIDEO_PAUSED;
		}
		
		override public function onEnterState(lastState:String):void
		{
			super.onEnterState(lastState);
			stream.pause();
		}
		
		override public function play():void
		{
			super.play();
			state = MediaPlayerStates.VIDEO_PLAYING;
		};
		
	}
}