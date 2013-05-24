package com.rudiyardley.player.controller.states
{
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.controller.MediaPlayerController;
	import com.rudiyardley.player.enums.MediaPlayerStates;
	import com.rudiyardley.player.model.MediaObject;
	import com.rudiyardley.player.model.MediaPlaylist;
	import com.rudiyardley.reporting.Console;
	
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.utils.Timer;

	public class BaseState extends EventDispatcher implements IState
	{
		private var _context:MediaPlayerController;
			
		public function BaseState()
		{
		}
		
		public function set height(value:Number):void
		{
			
		}
		
		public function set width(value:Number):void
		{
			
		}
		
		
		public function get playbackMovedTicker():Timer
		{
			return _context.model.playbackTicker;
		}
		
		public function get loadInfoTicker():Timer
		{
			return _context.model.loadInfoTicker;
		}
		
		public function get position():Number
		{
			return _context.model.position;
		}
		
		public function set position(value:Number):void
		{
			_context.model.position = value;
		}
		
		public function set playlist(value:MediaPlaylist):void
		{
			_context.model.playlist = value;
		}
		public function get playlist():MediaPlaylist
		{
			return _context.model.playlist;
		}

		public function set context(value:MediaPlayerController):void
		{
			_context = value;
		}
		
		public function get context():MediaPlayerController
		{
			return _context;
		}
		
		public function set state(value:String):void
		{
			_context.state = value;
		}
		
		public function get state():String
		{
			return _context.state;
		}
		

		public function set stream(value:NetStream):void
		{
			_context.model.netStream = value;
		}
		
		public function get stream():NetStream
		{
			return _context.model.netStream;
		}
		

		public function set currentMedia(value:MediaObject):void
		{
			_context.model.currentMedia = value;
		}
		
		public function get currentMedia():MediaObject
		{
			return _context.model.currentMedia;
		}
		
		public function get name():String
		{
			return null;
		}
			
		public function onExitState(nextState:String):void
		{
			Console.info(this, "nextState = "+nextState);
		}
		
		public function set fullscreen(value:Boolean):void
		{
			var host:DisplayObject;
			var pnt:Point;
			if(value)
			{
				try
				{
					host = DisplayObject(_context.model.host);
					pnt = host.parent.localToGlobal(new Point(host.x,host.y));
					host.stage["fullScreenSourceRect"] = new Rectangle(pnt.x,pnt.y,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
					host.stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				catch(e:Error)
				{
					Console.error(this, 'Error going fullscreen');
				}
			}
			else
			{
				try
				{
					host = DisplayObject(_context.model.host);
					host.stage.displayState = StageDisplayState.NORMAL;
				}
				catch(e:Error)
				{
					Console.error(this, 'Error releasing fullscreen');
				}
			}
		}
		
		public function set waitingStatus(value:Boolean):void
		{
			_context.model.waitingStatus = value;
		}
		public function get waitingStatus():Boolean
		{
			return _context.model.waitingStatus;
		}
		
		public function get fullscreen():Boolean
		{
			return _context.model.fullscreen;
		}
		
		public function onEnterState(lastState:String):void
		{
			Console.info(this, "lastState = "+lastState);
		}
		
		public function loadMedia(mediaObject:Object):void
		{
			Console.info(this, "loadMedia("+MediaObject(mediaObject).url+")");
			_context.model.currentMedia = mediaObject as MediaObject;
			state = MediaPlayerStates.VIDEO_LOADING;
		}
		
		public function loadPlaylist(playListObject:Object):void
		{
			playlist = new MediaPlaylist(playListObject);
		}
		
		public function play():void
		{
			Console.info(this, 'play()');
		}
		
		
		public function pause():void
		{
			Console.info(this, 'pause()');
		}
		
		public function set volume(value:Number):void
		{
			var transform:SoundTransform = new SoundTransform();
			transform.volume = value;
			stream.soundTransform = transform;
			_context.model.volume = value;
		}
		
		public function get volume():Number
		{
			return _context.model.volume;
		}
		
		public function seekStart():void
		{
			state = MediaPlayerStates.VIDEO_SEEK;
		}
		
		public function seekEnd():void
		{
			
		}
		
		public function seek(position:Number):void
		{
			
		}
		
		public function loadPlaylistIndex(index:int):void
		{
		
		}
		
		
		public function stop():void
		{
			stream.pause();
			stream.close();
		}
		
		public function mute(onOff:Boolean):void{}
	}
}