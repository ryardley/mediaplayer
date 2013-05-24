package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	import com.rudiyardley.player.model.MediaPlayerModel;
	import com.rudiyardley.reporting.Console;
	
	import mx.controls.HSlider;
	import mx.events.SliderEvent;

	public class VolumeBarSliderFlex extends HSlider implements IPlugin 
	{
		
		private var _mediaPlayer:IMediaPlayer;
		private var _dragging:Boolean;
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			Console.info(this, 'init');
			
			_dragging = false;
			liveDragging = true;
			
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.VOLUME_CHANGED, onVolumeChanged);
			
			minimum = 0;
			maximum = 1;
			
			addEventListener(SliderEvent.THUMB_PRESS, onThumbPress);
			addEventListener(SliderEvent.THUMB_DRAG, onThumbDrag);
			addEventListener(SliderEvent.THUMB_RELEASE, onThumbRelease);
			addEventListener(SliderEvent.CHANGE, onChange);
		}

		private function onVolumeChanged(e:MediaPlayerEvent):void
		{	
			if(!_dragging)
				value = _mediaPlayer.volume;
		}
		
		private function onThumbPress(e:SliderEvent):void
		{
			_dragging = true;
		}
		
		private function onThumbDrag(e:SliderEvent):void
		{
			
		}
		
		private function onThumbRelease(e:SliderEvent):void
		{
			_dragging = false;
		}
		
		private function onChange(e:SliderEvent):void
		{
			
			_mediaPlayer.volume = e.value;
		}
		
		
	}
}