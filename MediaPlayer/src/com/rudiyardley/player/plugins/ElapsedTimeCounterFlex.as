package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	
	import mx.controls.Text;
	import mx.formatters.DateFormatter;

	public class ElapsedTimeCounterFlex extends Text implements IPlugin
	{
		private var _mediaPlayer:IMediaPlayer;
			
		public function init(mediaPlayer:IMediaPlayer):void
		{
			selectable=false;
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.PLAYBACK_MOVED, onPlaybackMoved);
		}
		
		private function onPlaybackMoved(e:MediaPlayerEvent):void
		{
			var numPos:Number = (!isNaN(_mediaPlayer.position))?_mediaPlayer.position:0;
			var pos:Date = new Date(numPos*1000 + 0.01);
			var df:DateFormatter = new DateFormatter()
			df.formatString = 'N:SS';
			var timeStr:String = df.format(pos);
			timeStr = (timeStr == '')?'0:00':timeStr; 
			this.text = timeStr;
		}
		
	}
}