package com.rudiyardley.player.app
{
	import flash.events.IEventDispatcher;
	
	public interface IMediaPlayerController
	{
		function set width(value:Number):void;
		function set height(value:Number):void;
		function set volume(value:Number):void;
		function get volume():Number;
		function set fullscreen(value:Boolean):void;
		function get fullscreen():Boolean;
		function loadMedia(mediaObject:Object):void;
		function loadPlaylist(playListObject:Object):void;
		function loadPlaylistIndex(index:int):void;
		function play():void;
		function pause():void;
		function seekStart():void;
		function seek(position:Number):void;
		function seekEnd():void;
		function mute(onOff:Boolean):void;
		function stop():void;
	}
}