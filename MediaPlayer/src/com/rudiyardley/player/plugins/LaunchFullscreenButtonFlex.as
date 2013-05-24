package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import mx.controls.Button;
	import mx.core.Application;

	public class LaunchFullscreenButtonFlex extends Button implements IPlugin
	{
		private var _mediaPlayer:IMediaPlayer;
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			_mediaPlayer = mediaPlayer;
			
			Application(Application.application).stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullscreenChanged);
			
			
			
			//_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.FULLSCREEN_CHANGED, onFullscreenChanged);
			this.addEventListener(MouseEvent.CLICK, onClick);
			onFullscreenChanged(null);
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
			mouseEnabled = true;
			
		}
		
		private function onClick(e:MouseEvent):void
		{
			_mediaPlayer.fullscreen = true;
		}
		
		private function onFullscreenChanged(e:Event):void
		{
			this.visible = !(Application(Application.application).stage.displayState == StageDisplayState.FULL_SCREEN) 
				&& (Capabilities.playerType != "Desktop");
		}
		
	}
}