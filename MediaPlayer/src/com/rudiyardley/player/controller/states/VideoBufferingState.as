package com.rudiyardley.player.controller.states
{
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.controller.MediaPlayerController;
	import com.rudiyardley.player.enums.MediaPlayerStates;

	public class VideoBufferingState extends BaseState implements IState
	{

		override public function get name():String
		{
			return MediaPlayerStates.VIDEO_BUFFERING;
		}
		
		override public function onEnterState(lastState:String):void
		{
			super.onEnterState(lastState);
			waitingStatus = true;
		}
		
	}
}