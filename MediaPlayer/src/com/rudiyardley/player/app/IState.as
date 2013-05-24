package com.rudiyardley.player.app
{
	import com.rudiyardley.player.events.MediaPlayerEvent;
	
	public interface IState extends IMediaPlayerController
	{
		function get name():String;
		
		function onExitState(nextState:String):void;
		function onEnterState(lastState:String):void;
		
	}
}