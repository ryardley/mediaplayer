package com.rudiyardley.player
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.controller.MediaPlayerController;
	import com.rudiyardley.player.model.MediaObject;
	import com.rudiyardley.player.model.MediaPlaylist;
	
	import flash.events.IEventDispatcher;
	import flash.media.Video;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class MediaPlayerFlex extends UIComponent implements IMediaPlayer
	{
		private var _controller:MediaPlayerController;
		
		public function MediaPlayerFlex()
		{
			super();
			_controller = new MediaPlayerController();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			_controller.width = unscaledWidth;
			_controller.height = unscaledHeight;
		}
		
		public function get dispatcher():IEventDispatcher
		{
			return _controller.model;
		}
		
		private function onCreationComplete(e:FlexEvent):void
		{
			_controller.init(this);
		}
		
		public function get currentMedia():MediaObject
		{
			return _controller.model.currentMedia;
		}
		
		public function get duration():Number
		{
			return _controller.model.duration;
		}
		
		public function get volume():Number
		{
			return _controller.model.volume;
		}
		
		public function get mediaAmountLoaded():Number
		{
			return _controller.model.mediaAmountLoaded;
		}
		
		public function get mediaAmountTotal():Number
		{
			return _controller.model.mediaAmountTotal;
		}
		
		public function get metaData():Object
		{
			return _controller.model.metaData;
		}
		
		public function get position():Number
		{
			return _controller.model.position;
		}
		
		
		public function get videoScreen():Video
		{
			return _controller.model.videoScreen;
		}
		
		public function get state():String
		{
			return _controller.model.state;
		}
		
		public function set plugins(value:Array):void
		{
			_controller.plugins = value;
		}
		
		public function get plugins():Array
		{
			return _controller.plugins;
		}
		
		public function set volume(value:Number):void
		{
			_controller.volume = value;	
		}
		
		public function set fullscreen(value:Boolean):void
		{
			_controller.fullscreen = value;
		}
		
		public function get fullscreen():Boolean
		{
			return _controller.fullscreen;
		}
		
		public function loadMedia(mediaObject:Object):void
		{
			_controller.loadMedia(mediaObject);
		}
		
		public function loadPlaylist(playListObject:Object):void
		{
			_controller.loadPlaylist(playListObject);
		}
		
		public function play():void
		{
			_controller.play();
		}
		
		public function pause():void
		{
			_controller.pause();
		}
		
		
		public function seekStart():void
		{
			_controller.seekStart();
		};
		
		public function seek(position:Number):void
		{
			_controller.seek(position);
		};
		
		public function seekEnd():void
		{
			_controller.seekEnd();
		};
		
		public function get playlist():MediaPlaylist
		{
			return _controller.model.playlist;
		}
		
		
		public function loadPlaylistIndex(index:int):void
		{
			_controller.loadPlaylistIndex(index);
		}
		
		public function get waitingStatus():Boolean
		{
			return _controller.model.waitingStatus;
		}
		
		
		public function mute(onOff:Boolean):void
		{
			_controller.mute(onOff);
		}
		
		
		public function get muted():Boolean
		{
			return _controller.model.muted;
		}
		
		
		public function stop():void
		{
			_controller.stop();
		}
	}
}