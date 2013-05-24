package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	
	import mx.controls.Text;

	public class VideoTitleFlex extends Text implements IPlugin
	{
	
		private var _mediaPlayer:IMediaPlayer
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener( MediaPlayerEvent.METADATA_RECEIVED, onMetaData );
		}
		
		private function onMetaData(e:MediaPlayerEvent):void
		{
			this.text = _mediaPlayer.currentMedia.title;
		}
	}
}