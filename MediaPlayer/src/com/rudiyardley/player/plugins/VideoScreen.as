package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.controller.MediaPlayerController;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	import com.rudiyardley.player.model.MediaPlayerModel;
	import com.rudiyardley.reporting.Console;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.utils.Timer;

	public class VideoScreen extends Sprite implements IPlugin
	{
		private var _controller:MediaPlayerController;
		private var _mediaPlayer:IMediaPlayer;
		private var _host:DisplayObjectContainer;
		private var _video:Video;
		private var _width:Number;
		private var _height:Number;
		private var _background:Sprite;
		private var _displayInvalidationTimer:Timer;
		
		public function get video():Video
		{
			return _video;
		}
		
		public function VideoScreen(){}
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			//	add all listeners to the model
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.METADATA_RECEIVED, onMetaDataRecieved);
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.MEDIA_CHANGED, onMediaChanged);
			
			//	Create the background black
			_background = new Sprite();
			_background.graphics.beginFill(0x000000);
			_background.graphics.drawRect(0,0,100,100);
			_background.graphics.endFill();
			addChild(_background);
			
			//	Create the video
			_video = new Video();
			addChild(_video);
			
			//	Update the display
			updateDisplay(_width,_height);
			invalidateDisplay();
		}
		
		/**
		 * 	Display Invalidation
		 **/
		public function invalidateDisplay():void
		{
			if(_displayInvalidationTimer == null)
			{
				_displayInvalidationTimer = new Timer(100,1);
				_displayInvalidationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDisplayInvalidationTimerComplete);
				_displayInvalidationTimer.start();
			}
		}
		
		/**
		 * 	Display Invalidation
		 **/
		private function onDisplayInvalidationTimerComplete(e:TimerEvent):void
		{
			_displayInvalidationTimer.stop();
			_displayInvalidationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDisplayInvalidationTimerComplete);
			_displayInvalidationTimer = null;
			updateDisplay(_width,_height);
		}
		
		
		private function onMediaChanged(e:MediaPlayerEvent):void
		{
			Console.info(this, 'onMediaChanged');
			
			//	hide video
			_video.visible = false;
		//	_background.visible = true;
			
		}
		
		private function onMetaDataRecieved(e:MediaPlayerEvent):void
		{
			Console.info(this, 'onMetaDataRecieved');
			
			//	show the video
			video.visible = true;
			updateDisplay(_width,_height);
			this.invalidateDisplay();
		}
		
		
		private function updateDisplay(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			
			if(_background != null)
			{
				_background.width = unscaledWidth;
				_background.height = unscaledHeight;
			}
			
			if(_video != null)
			{
				if(_mediaPlayer.metaData != null)
				{
					var aspect:Number = _mediaPlayer.metaData.width/_mediaPlayer.metaData.height;
					var screenAspect:Number = unscaledWidth/unscaledHeight;
					
					if(aspect>screenAspect)
					{
						_video.width = unscaledWidth;
						_video.height = unscaledWidth/aspect;
					}
					else if(aspect<screenAspect)
					{
						_video.width = unscaledHeight*aspect;
						_video.height = unscaledHeight;	
					}
					else
					{
						_video.width = unscaledWidth;
						_video.height = unscaledHeight;	
					}
					
				}
				else
				{
					_video.width = unscaledWidth;
					_video.height = unscaledHeight;	
				}
				
				_video.x = _background.width/2 - _video.width/2;
				_video.y = _background.height/2 - _video.height/2;
				
			}	
		}
		
		public override function set width(value:Number):void
		{
			_width = value;
			invalidateDisplay();
		}
		public override function get width():Number
		{
			return _width;
		}
		
		public override function set height(value:Number):void
		{
			_height = value;
			invalidateDisplay();
		}
		
		public override function get height():Number
		{
			return _height;
		}
	}
}