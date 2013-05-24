package com.rudiyardley.player.controller.states
{
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.enums.MediaPlayerStates;

	public class VideoSeekState extends BaseState implements IState
	{
		private var _lastState:String;
		private var _position:Number;
		
		override public function get name():String
		{
			return MediaPlayerStates.VIDEO_SEEK;
		}
		
		override public function onEnterState(lastState:String):void
		{
			trace('VIDEO_SEEK.onEnterState');
			super.onEnterState(lastState);
			
			_lastState = lastState;
			stream.pause();
		}
		
		override public function seek(pos:Number):void
		{
			stream.seek(pos);
			_position = pos;
		}
		
		override public function seekEnd():void
		{
			position = _position;
			state = _lastState;
		} 
		
	}
}