package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	
	import mx.controls.Text;
	import mx.formatters.DateFormatter;

	public class TotalTimeCounterFlex extends Text implements IPlugin
	{
		private var _mediaPlayer:IMediaPlayer;
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			selectable=false;
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener( MediaPlayerEvent.METADATA_RECEIVED, onMetaData );
		}
		
		private function onMetaData(e:MediaPlayerEvent):void
		{
			var numPos:Number = (!isNaN(_mediaPlayer.duration))?_mediaPlayer.duration:0;
			var pos:Date = new Date(numPos*1000 + 0.01);
			var df:DateFormatter = new DateFormatter(); 
			df.formatString = 'N:SS';
			
			this.text = df.format(pos);
		}
		
	}
}