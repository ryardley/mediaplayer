package com.rudiyardley.player.app
{
	import flash.events.IEventDispatcher;
	
	public interface IMediaPlayer extends IMediaPlayerController, IMediaPlayerModel
	{
		function get dispatcher():IEventDispatcher
	}
}