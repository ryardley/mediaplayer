package com.rudiyardley.player.app
{
	import com.rudiyardley.player.model.MediaObject;
	import com.rudiyardley.player.model.MediaPlaylist;
	
	import flash.media.Video;
	
	public interface IMediaPlayerModel
	{
		
		/*public var netConnection:NetConnection;
		public var netStream:NetStream;
		public var plugins:Array;
		public var playbackTicker:Timer;
		public var loadInfoTicker:Timer;
		public function get controller:MediaPlayerController;*/
		//public function get host():DisplayObject;
		function get videoScreen():Video;
		function get metaData():Object;
		function get currentMedia():MediaObject;
		function get state():String;
		function get position():Number;
		function get mediaAmountLoaded():Number;
		function get mediaAmountTotal():Number;
		function get duration():Number;
		function get playlist():MediaPlaylist;
		function get waitingStatus():Boolean;
		function get muted():Boolean;
	}
}