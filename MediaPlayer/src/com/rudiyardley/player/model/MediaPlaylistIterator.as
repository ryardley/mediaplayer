package com.rudiyardley.player.model
{
	public class MediaPlaylistIterator
	{
		private var _playlist:MediaPlaylist;
		private var _index:int;
		
		public function MediaPlaylistIterator(playlist:MediaPlaylist)
		{
			_playlist = playlist;
			reset();
		}
		
		public function hasNext():Boolean
		{
			return _index < _playlist.length()-1;
		}
		
		public function current():MediaObject
		{
			return _playlist.getItemAt(_index);
		}
		
		public function setPosition(index:int):void
		{
			_index = index;
		}
		
		public function next():MediaObject
		{
			return _playlist.getItemAt(++_index);
		}
		
		public function reset():void
		{
			_index = -1;
		}
		

	}
}