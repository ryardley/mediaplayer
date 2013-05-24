package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	import com.rudiyardley.reporting.Console;
	
	import mx.controls.HSlider;
	import mx.events.SliderEvent;

	public class SeekbarSliderFlex extends HSlider implements IPlugin 
	{
		
		private var _mediaPlayer:IMediaPlayer;
		
		public function SeekbarSliderFlex()
		{
			super();
			
		}
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			Console.info(this, 'init');
			_mediaPlayer = mediaPlayer;
			
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.PLAYBACK_MOVED, onPlaybackMoved);
			
			addEventListener(SliderEvent.THUMB_PRESS, onThumbPress);
			addEventListener(SliderEvent.THUMB_DRAG, onThumbDrag);
			addEventListener(SliderEvent.THUMB_RELEASE, onThumbRelease);
			addEventListener(SliderEvent.CHANGE, onChange);
			this.sliderThumbClass = ThumbClass;
		}

		private function onPlaybackMoved(e:MediaPlayerEvent):void
		{	
			maximum = _mediaPlayer.duration;
			minimum = 0;
			value = _mediaPlayer.position;
		}
		
		private function onThumbPress(e:SliderEvent):void
		{
			_mediaPlayer.seekStart();
		}
		
		private function onThumbDrag(e:SliderEvent):void
		{
			_mediaPlayer.seek(e.value);
		}
		
		private function onThumbRelease(e:SliderEvent):void
		{
			_mediaPlayer.seekEnd();
		}
		
		private function onChange(e:SliderEvent):void
		{
			_mediaPlayer.seekStart();
			_mediaPlayer.seek(e.value);
			_mediaPlayer.seekEnd();
		}
		
	}
}
	import mx.core.UIComponent;
	import mx.controls.sliderClasses.SliderThumb;
	

class ThumbClass extends SliderThumb
{
	public function ThumbClass()
	{
		this.useHandCursor = true;
		this.buttonMode = true;
		this.mouseChildren = false;
		
	}	
}