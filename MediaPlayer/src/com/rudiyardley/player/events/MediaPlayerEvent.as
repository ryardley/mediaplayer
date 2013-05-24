package com.rudiyardley.player.events
{
	import flash.events.Event;
	
	public class MediaPlayerEvent extends Event
	{
		public static const METADATA_RECEIVED:String = 'METADATA_RECEIVED';
		public static const MEDIA_CHANGED:String = 'MEDIA_CHANGED';
		public static const PLAYBACK_MOVED:String = 'PLAYBACK_MOVED';
		public static const MEDIA_DATALOADING:String = 'MEDIA_DATALOADING';
		public static const STATE_CHANGED:String = 'STATE_CHANGED';
		public static const VOLUME_CHANGED:String = 'VOLUME_CHANGED';
		public static const FULLSCREEN_CHANGED:String = 'FULLSCREEN_CHANGED';
		public static const PLAYLIST_CHANGED:String = 'PLAYLIST_CHANGED';
		public static const WAITINGSTATUS_CHANGED:String = 'WAITINGSTATUS_CHANGED';
		public static const MUTE_CHANGED:String = 'MUTE_CHANGED';
		
		public var data:*;
		
		public function MediaPlayerEvent(type:String, data:*=null)
		{
			super(type);
			this.data = data;
		}
		
		override public function clone():Event
		{
			return new MediaPlayerEvent(this.type,this.data);
		}
		
	}
}