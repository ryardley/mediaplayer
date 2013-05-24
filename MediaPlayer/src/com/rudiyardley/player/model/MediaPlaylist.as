package com.rudiyardley.player.model
{
	import com.rudiyardley.reporting.Console;
	
	public class MediaPlaylist
	{
		private var _col:Array;
		
		public function MediaPlaylist(playListObject:Object)
		{
			clear();
			
			_col = [];
			var list:* = null;
			
			if(playListObject is XML)
			{
				list = playListObject.item;
			}
			else if(playListObject is XMLList)
			{
				list = playListObject;
			}
			else if(playListObject is Array)
			{
				list = playListObject
			}
			
			for each (var item:* in list)
			{
				_col.push(new MediaObject(item));
			}
		}
		
		public function createIterator(type:String=null):MediaPlaylistIterator
		{
			var iterator:MediaPlaylistIterator = new MediaPlaylistIterator(this);
			
			return iterator;
		}
		
		public function getItemAt(index:int):MediaObject
		{
			return _col[index] as MediaObject;
		}
		
		public function length():int
		{
			return _col.length;
		}
		
		public function get isEmpty() : Boolean
		{
			return ( size == 0 );
		};
		
		public function get size() : int
		{
			return _col.length;
		};
		
		public function add( o : * ) : Boolean
		{
			
			if(!(o is MediaObject))
			{
				Console.error(this, 'object is not MediaObject');
			}
			
			var alreadyContains:Boolean = contains(o);
			_col.push(o);
			return alreadyContains;
		};
		
		public function clear() : void
		{
			_col = new Array();
		};
		public function contains( o : * ) : Boolean
		{
			var c:Boolean = false;
			for(var i:int=0;i<_col.length;i++)
			{
				if(_col[i] == o)
				{
					c = true;
				}
			}
			
			return c;
		};
		
		public function remove( o : * ) : Boolean
		{
			
			var r:Boolean = false;
			for(var i:int=0;i<_col.length;i++)
			{
				if(_col[i] == o)
				{
					_col.splice(i,1);
					r = true;
				}
			}
			
			return r;
		};
		
		public function toArray() : Array
		{
			return _col;
		};
		
	}
}

	
