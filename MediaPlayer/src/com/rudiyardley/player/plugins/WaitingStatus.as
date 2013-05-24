package com.rudiyardley.player.plugins
{
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	import com.rudiyardley.player.view.animation.ProgrammaticSpinnerAnimation;
	
	import flash.display.Sprite;

	public class WaitingStatus extends Sprite implements IPlugin
	{
		
		
		private var _mediaPlayer:IMediaPlayer;
		
		public function WaitingStatus()
		{
			super();
			//addChild(new ProgrammaticSpinnerAnimation());
			addChild(new ProgrammaticSpinnerAnimation());
			visible = false;
		}
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.WAITINGSTATUS_CHANGED, onWaitingStatusChanged);
		}
		
		private function onWaitingStatusChanged(e:MediaPlayerEvent):void
		{
			if(parent != null)
			{
//				/trace('onWaitingStatusChanged');
				parent.setChildIndex(this, parent.numChildren-1);
				x = parent.width/2;// - width/2;
				y = parent.height/2;// - height/2;
				visible = _mediaPlayer.waitingStatus;
			}
		}
	}
}