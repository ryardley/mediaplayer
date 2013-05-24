package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;

	public class UnmuteButtonFlex extends Button implements IPlugin
	{
		private var _mediaPlayer:IMediaPlayer;
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.MUTE_CHANGED, onMuteChanged);
			this.addEventListener(MouseEvent.CLICK, onClick);
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
			mouseEnabled = true;
		}
		
		private function onClick(e:MouseEvent):void
		{
			_mediaPlayer.mute(false);
		}
		
		private function onMuteChanged(e:MediaPlayerEvent):void
		{
			this.visible = _mediaPlayer.muted;
		}
		
	}
}