package com.rudiyardley.player.controller
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IMediaPlayerController;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.app.IState;
	import com.rudiyardley.player.controller.states.BaseState;
	import com.rudiyardley.player.controller.states.IdleState;
	import com.rudiyardley.player.controller.states.VideoBufferingState;
	import com.rudiyardley.player.controller.states.VideoErrorState;
	import com.rudiyardley.player.controller.states.VideoLoadingState;
	import com.rudiyardley.player.controller.states.VideoPausedState;
	import com.rudiyardley.player.controller.states.VideoPlayingState;
	import com.rudiyardley.player.controller.states.VideoSeekState;
	import com.rudiyardley.player.enums.MediaPlayerStates;
	import com.rudiyardley.player.model.MediaPlayerModel;
	import com.rudiyardley.player.model.MediaPlaylist;
	import com.rudiyardley.player.plugins.VideoScreen;
	import com.rudiyardley.player.plugins.WaitingStatus;
	import com.rudiyardley.reporting.Console;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class MediaPlayerController implements IMediaPlayerController
	{

		private var _host:DisplayObjectContainer;
		
		public var model:MediaPlayerModel;
		
		private var _states:Dictionary;
		//private var _state:String = IDLE;
		private var _aspectRatio:Number;
		private var _stateDirty:Boolean;
		private var _currentState:IState;
		private var _width:Number;
		private var _height:Number;
		private var _videoScreen:VideoScreen;
		
		public function set plugins(value:Array):void
		{
			model.plugins = value;
		}
		public function get plugins():Array
		{
			return model.plugins;
		}
		
		public function MediaPlayerController()
		{
			

			// Set up a lookup table for our states
			_states = new Dictionary();
			_states[MediaPlayerStates.IDLE] = new IdleState();
			_states[MediaPlayerStates.VIDEO_BUFFERING] = new VideoBufferingState();
			_states[MediaPlayerStates.VIDEO_LOADING] = new VideoLoadingState();
			_states[MediaPlayerStates.VIDEO_PAUSED] = new VideoPausedState();
			_states[MediaPlayerStates.VIDEO_PLAYING] = new VideoPlayingState();
			_states[MediaPlayerStates.VIDEO_SEEK] = new VideoSeekState();
			_states[MediaPlayerStates.VIDEO_ERROR] = new VideoErrorState();
			
			for each(var st:BaseState in _states)
			{
				st.context = this;
			}
			
			//	Setup model
			model = new MediaPlayerModel();
			model.controller = this;
			
			//	Set up states
			_currentState = _states[MediaPlayerStates.IDLE];
			state = MediaPlayerStates.IDLE;
			
			//	Setup playback and loadInfoTicker tickers
			model.playbackTicker = new Timer(500);
			model.playbackTicker.addEventListener(TimerEvent.TIMER, onPlaybackTimer);
			
			model.loadInfoTicker = new Timer(500);
			model.loadInfoTicker.addEventListener(TimerEvent.TIMER, onLoadInfoTimer);
			
			
		}
		
		
		private function onPlaybackTimer(e:TimerEvent):void
		{
			model.position = model.netStream.time;
		}
		
		private function onLoadInfoTimer(e:TimerEvent):void
		{
			model.mediaAmountTotal = model.netStream.bytesTotal;
			model.mediaAmountLoaded = model.netStream.bytesLoaded;
			
			if(model.mediaAmountLoaded == model.mediaAmountTotal && model.mediaAmountTotal > 2000)
			{
				model.loadInfoTicker.stop();
			}
		}
		
		
		
		public function init(host:IMediaPlayer):void
		{
			//	Will be called after the host is ready
			model.host = host;
			
			//	Setup the video screen
			_videoScreen = new VideoScreen();
			_videoScreen.init(host);
			_videoScreen.video.smoothing = true;
			_videoScreen.width = (!isNaN(_width))?_width:_videoScreen.width;
			_videoScreen.height = (!isNaN(_height))?_height:_videoScreen.height;
			model.videoScreen = _videoScreen.video;
			Sprite(host).addChild(_videoScreen);
			
			//	Setup Waiting Status
			var waitingStatus:WaitingStatus = new WaitingStatus();
			waitingStatus.init(host);
			Sprite(host).addChild(waitingStatus);
			
			//	Listen to fullscreen events and broadcast them to listeners
			DisplayObject(host).addEventListener(Event.ADDED_TO_STAGE,
				function():void
				{
					var stage:Stage = DisplayObject(model.host).stage; 
					stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullscreenChanged);
					var displayState:String = stage.displayState;
					
					model.fullscreen = (stage.displayState == StageDisplayState.FULL_SCREEN);
				}		
			);
			
			
			
			//	Initialize all plugins
			for each(var plugin:IPlugin in model.plugins)
			{
				plugin.init(model.host);
			}
			
			//	Setup connection
			var connection:NetConnection;
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			connection.connect(null);
			
			//	Setup client
			var streamClient:Object;
			streamClient = new Object();
			streamClient.onMetaData = metadataHandler;
			streamClient.onPlayStatus = statusHandler;
			
			//	Setup stream
			var stream:NetStream = new NetStream(connection)
	 		stream.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asErrorHandler);
			stream.client = streamClient;
			//stream.bufferTime = 15;
			
			//	set properties on model
			model.netConnection = connection;
			model.netStream = stream;
			model.videoScreen.attachNetStream(stream);
			
			model.volume = stream.soundTransform.volume;
			model.muted = false;
			
		}
		
		private function onFullscreenChanged(e:FullScreenEvent):void
		{
			model.fullscreen = e.fullScreen;
		}
		
		private function asErrorHandler(e:AsyncErrorEvent):void
		{
			trace('async error!');
		}
		
		private function statusHandler(e:NetStatusEvent):void
		{
			Console.info(this, 'status: '+e.info.code);
			switch(e.info.code)
			{
				case 'NetStream.Play.Start':
					state = MediaPlayerStates.VIDEO_PLAYING;
					break;
					
				case 'NetStream.Buffer.Full':
					if(state == MediaPlayerStates.VIDEO_BUFFERING)
					state = MediaPlayerStates.VIDEO_PLAYING;
					break;
				case 'NetStream.Buffer.Empty':
					state = MediaPlayerStates.VIDEO_BUFFERING;
					break;
				case 'NetStream.Play.Stop':
					if(model.netStream.bytesLoaded == model.netStream.bytesTotal)
					{
						state = MediaPlayerStates.IDLE;
						if(model.playlist != null&&model.playlistIterator.hasNext())
						{
							loadMedia(model.playlistIterator.next());
						}
					}
					break;
			}
		}
		
		private function metadataHandler(obj:Object):void
		{
			model.metaData = obj; 
		}
		
		private function IOErrorHandler(e:IOErrorEvent):void
		{
			trace('ERROR: '+e.text);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			trace('ERROR: '+e.text);
		}
		
		public function set width(value:Number):void
		{
			_width = value
			if(_videoScreen != null)
				_videoScreen.width = _width;
		}
		
		public function set height(value:Number):void
		{
			_height = value
			if(_videoScreen != null)
				_videoScreen.height = _height;
		}
		
		private function hasInit():Boolean
		{
			return (_host != null);
		}
		
		public function set state(value:String):void
		{
			if(model.state != value)
			{
				
				if(_states[value] != null)
				{
					var lastState:IState = _currentState;
					var nextState:IState = _states[value];
					lastState.onExitState(nextState.name);
					_currentState = nextState;
					_currentState.onEnterState(lastState.name);
					model.state = value;
				}
				else
				{
					throw new Error('State: ' + model.state + ' doesn\'t exist');
				}
			}
		}
		
		public function get state():String
		{
			return model.state;
		}

		public function set volume(value:Number):void
		{
			_currentState.volume = value;
		}
		
		public function get volume():Number
		{
			return model.volume;
		}
		
		public function set fullscreen(value:Boolean):void
		{
			_currentState.fullscreen = value;
		}
		
		
		public function get fullscreen():Boolean
		{
			return model.fullscreen;
		}
		
		public function loadMedia(mediaObject:Object):void
		{
			//throw new Error('Where are we in the stack?');
			_currentState.loadMedia(mediaObject);
		}
		
		public function loadPlaylist(playListObject:Object):void
		{
			model.playlist = new MediaPlaylist(playListObject);
			model.playlistIterator = model.playlist.createIterator();
			
			//loadMedia(model.playlistIterator.next());
		}
		
		public function play():void
		{
			_currentState.play();
		}
		
		public function pause():void
		{
			_currentState.pause();
		}

		
		public function seekStart():void
		{
			_currentState.seekStart();
		};
		
		public function seek(position:Number):void
		{
			_currentState.seek(position);
		};
		
		public function seekEnd():void
		{
			_currentState.seekEnd();
		};
		
		public function loadPlaylistIndex(index:int):void
		{
			if(index != -1)
			{
				model.playlistIterator.setPosition(index);
				loadMedia(model.playlist.getItemAt(index));
			}
		}


		public function mute(onOff:Boolean):void
		{
			if(onOff)
			{
				model.muteVol = model.volume;
				volume = 0;
				model.muted = true;
			}
			else
			{
				volume = model.muteVol;
				model.muted = false;
			}
			
		}
		
		
		public function stop():void
		{
			_currentState.stop();
		}

	}
}