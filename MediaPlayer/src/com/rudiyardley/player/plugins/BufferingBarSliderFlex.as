package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IMediaPlayerController;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	import com.rudiyardley.reporting.Console;
	
	import mx.controls.HSlider;

	public class BufferingBarSliderFlex extends HSlider implements IPlugin 
	{
		
		private var _mediaPlayer:IMediaPlayer;
		
		public function BufferingBarSliderFlex()
		{
			super();
		}
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			Console.info(this, 'init');
			_mediaPlayer = mediaPlayer;
			
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.MEDIA_DATALOADING, onMediaData);
			enabled = false;
		}

		private function onMediaData(e:MediaPlayerEvent):void
		{	
			maximum = _mediaPlayer.mediaAmountTotal;
			minimum = 0;
			value = _mediaPlayer.mediaAmountLoaded;
		}
		
		
	}
}