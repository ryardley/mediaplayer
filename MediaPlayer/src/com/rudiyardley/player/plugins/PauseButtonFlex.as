package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.enums.MediaPlayerStates;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	import com.rudiyardley.player.model.MediaPlayerModel;
	import com.rudiyardley.reporting.Console;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;

	public class PauseButtonFlex extends Button implements IPlugin
	{
		private var _mediaPlayer:IMediaPlayer;
		
		public function PauseButtonFlex()
		{
			super();
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
			mouseEnabled = true;
		}
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			Console.info(this, 'init');
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.STATE_CHANGED, onStateChanged);
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			Console.info(this, 'pause button clicked');
			_mediaPlayer.pause();
		}
		
		private function onStateChanged(e:MediaPlayerEvent):void
		{
			switch(_mediaPlayer.state)
			{
				case MediaPlayerStates.IDLE:
				case MediaPlayerStates.VIDEO_BUFFERING:
				case MediaPlayerStates.VIDEO_ERROR:
				case MediaPlayerStates.VIDEO_LOADING:
				case MediaPlayerStates.VIDEO_PLAYING:
					visible = true;
					break;
				
				case MediaPlayerStates.VIDEO_PAUSED:
					visible = false;
					
					break;
				default:
					break;
			}
			
		}
	}
}