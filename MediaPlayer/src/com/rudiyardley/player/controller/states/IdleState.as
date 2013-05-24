package com.rudiyardley.player.controller.states
{
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.controller.MediaPlayerController;
	import com.rudiyardley.player.enums.MediaPlayerStates;

	public class IdleState extends BaseState implements IState
	{
		override public function get name():String
		{
			return MediaPlayerStates.IDLE;
		}
		
		override public function onEnterState(lastState:String):void
		{
		//	if(stream!=null)
		//		stream.close();
			this.waitingStatus = false;
		}
	}
}