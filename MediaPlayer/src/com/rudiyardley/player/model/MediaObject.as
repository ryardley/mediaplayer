package com.rudiyardley.player.model
{
		
	public class MediaObject
	{
		public var url:String;
		public var thumbnailUrl:String;
		public var title:String;
		
		public function MediaObject(initObj:Object)
		{
			if(initObj != null)
			{
				if(initObj is XML)
				{
					url = initObj.url.text();
					thumbnailUrl = initObj.thumbnailUrl.text();
					title = initObj.title.text();
				}
				else
				{
					url = initObj.url;
					thumbnailUrl = initObj.thumbnailUrl;	
					title = initObj.title;		
				}
			}
		}
	}
}

