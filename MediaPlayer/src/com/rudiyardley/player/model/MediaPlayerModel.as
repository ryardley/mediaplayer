package com.rudiyardley.player.model
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IMediaPlayerModel;
	import com.rudiyardley.player.controller.MediaPlayerController;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	
	import flash.events.EventDispatcher;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	public class MediaPlayerModel extends EventDispatcher implements IMediaPlayerModel
	{
		
		public var netConnection:NetConnection;
		public var netStream:NetStream;
		public var plugins:Array;
		public var playbackTicker:Timer;
		public var loadInfoTicker:Timer;
		public var controller:MediaPlayerController;
		public var host:IMediaPlayer;
		public var muteVol:Number;
		
		private var _fullscreen:Boolean;
		public function set fullscreen(value:Boolean):void
		{
			_fullscreen = value
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.FULLSCREEN_CHANGED));
		}
		public function get fullscreen():Boolean
		{
			return _fullscreen;
		}
		
		private var _screen:Video;
		public function set videoScreen(value:Video):void
		{
			_screen = value;
		};
		public function get videoScreen():Video
		{
			return _screen;
		};
		
		private var _metaData:Object;
		public function set metaData(value:Object):void
		{
			_metaData = value;
			if(_metaData == null)
			{
				duration = 0;
				position = 0;	
			}
			else
			{
				duration = _metaData.duration;
			}
			 
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.METADATA_RECEIVED));
		}
		public function get metaData():Object
		{
			return _metaData;
		}
		
		
		
		private var _currentMedia:MediaObject;
		public function set currentMedia(value:MediaObject):void
		{
			_currentMedia = value;
			metaData = null;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.MEDIA_CHANGED));
		}
		public function get currentMedia():MediaObject
		{
			return _currentMedia;
		}	

		private var _state:String;
		public function set state(value:String):void
		{
			_state = value;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.STATE_CHANGED));
		}
		public function get state():String
		{
			return _state;
		}		
		
		private var _position:Number;
		public function set position(value:Number):void
		{
			_position = value;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYBACK_MOVED));
		}
		public function get position():Number
		{
			return _position;
		}		
		
		private var _playlist:MediaPlaylist;
		public function set playlist(value:MediaPlaylist):void
		{
			//trace('PLAYLIST CHANGED ABOUT TO BE DISPATCHED')
			_playlist = value;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYLIST_CHANGED));
		}
		public function get playlist():MediaPlaylist
		{
			return _playlist;
		}		
		
		
		private var _playlistIterator:MediaPlaylistIterator;
		public function set playlistIterator(value:MediaPlaylistIterator):void
		{
			_playlistIterator = value;
		}
		public function get playlistIterator():MediaPlaylistIterator
		{
			return _playlistIterator;
		}		
		
		private var _waitingStatus:Boolean;
		public function set waitingStatus(value:Boolean):void
		{
			_waitingStatus = value;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.WAITINGSTATUS_CHANGED));
		}
		public function get waitingStatus():Boolean
		{
			return _waitingStatus;
		}
		
		private var _volume:Number;
		public function set volume(value:Number):void
		{
			_volume = value;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGED));
		}
		public function get volume():Number
		{
			return _volume;
		}	
		
		private var _mediaAmountLoaded:Number;
		public function set mediaAmountLoaded(value:Number):void
		{
			_mediaAmountLoaded = value;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.MEDIA_DATALOADING));
		}
		public function get mediaAmountLoaded():Number
		{
			return _mediaAmountLoaded;
		}		
		
		
		private var _muted:Boolean = false;
		public function set muted(value:Boolean):void
		{
			_muted = value;
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.MUTE_CHANGED));
		}
		public function get muted():Boolean
		{
			return _muted;
		}		
		
		
		private var _mediaAmountTotal:Number;
		public function set mediaAmountTotal(value:Number):void
		{
			if(_mediaAmountTotal != value)
				_mediaAmountTotal = value;
		}
		public function get mediaAmountTotal():Number
		{
			return _mediaAmountTotal;
		}	
		
		private var _duration:Number;
		public function set duration(value:Number):void
		{
			_duration = value;
		}
		public function get duration():Number
		{
			return _duration;
		}		
	
	}
}