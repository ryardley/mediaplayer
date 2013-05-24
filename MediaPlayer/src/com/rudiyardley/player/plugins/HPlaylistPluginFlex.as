package com.rudiyardley.player.plugins
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import com.rudiyardley.player.app.IMediaPlayer;
	import com.rudiyardley.player.app.IPlugin;
	import com.rudiyardley.player.events.MediaPlayerEvent;
	import com.rudiyardley.player.model.MediaPlaylistIterator;
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;

	public class HPlaylistPluginFlex extends UIComponent implements IPlugin
	{
		public static var PADDING:Number = 10;
		
		private var _mediaPlayer:IMediaPlayer;
		private var _buttons:Array;
		private var _notFirstLayout:Boolean = false;
		private var _holder:UIComponent;
		
		public function HPlaylistPluginFlex()
		{
			super();
			setStyle('horizontalGap', 30);
			_buttons = new Array();
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			_holder = new UIComponent();
			addChild(_holder);
		}
		
		override public function set visible(value:Boolean):void
		{
			if(super.visible != value)
			{
				super.visible = value;
				if(value)
				{
					runDisplayAnimation(.1);
				}	
			}
		}
		
		
		public function runDisplayAnimation(delay:Number=0):void
		{
			for(var i:int=0; i<_buttons.length; i++)
			{
				var button:ThumbnailButton = _buttons[i] as ThumbnailButton;
				button.runAnimation(i*0.1 + delay);
			}
		}
		
		public function init(mediaPlayer:IMediaPlayer):void
		{
			_mediaPlayer = mediaPlayer;
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.PLAYLIST_CHANGED, onPlaylistChanged);
			_mediaPlayer.dispatcher.addEventListener(MediaPlayerEvent.MEDIA_CHANGED, onMediaChanged);
			//onPlaylistChanged(null);
		}
		
		private function onPlaylistChanged(e:MediaPlayerEvent):void
		{
			var iterator:MediaPlaylistIterator = _mediaPlayer.playlist.createIterator();
			
			//Remove all children
			_buttons = new Array();
			
			_holder.parent.removeChild(_holder);
			_holder = null;
			_holder = new UIComponent();	
			_holder.alpha = 0;
			
			TweenMax.to(_holder, 1,{delay:2, ease:Strong.easeOut,alpha:1});
			addChild(_holder);
			
			//_holder = new Sprite();
			//for (var i:int=0; i< numChildren; i++)
			//{
			//	trace('removing: ' + this.getChildAt(i).name)
			//	_holder.removeChild(this.getChildAt(i));
			//}
			
			while(iterator.hasNext())
			{
				
				var button:ThumbnailButton = new ThumbnailButton();
				button.item = iterator.next();
				button.name = button.item.title.split(' ').join('_') + '_mc';
				button.addEventListener(MouseEvent.CLICK, onThumbClick);
				_buttons.push(button);	// add to lookup table
				_holder.addChild(button);
			}
		}
		
		private function getButtonIndex(button:ThumbnailButton):int
		{
			for(var i:int=0;i<_buttons.length;i++)
			{
				if(button == _buttons[i])
				{
					return i;
				}
			}
			return -1;
		}
		
		private function onThumbClick(e:MouseEvent):void
		{
			var button:ThumbnailButton = ThumbnailButton(e.target);
			_mediaPlayer.loadPlaylistIndex(getButtonIndex(button));
		}
		
		private function onMediaChanged(e:MediaPlayerEvent):void
		{
			
			
			
			for(var i:int=0;i<_buttons.length;i++)
			{
				var button:ThumbnailButton = ThumbnailButton(_buttons[i]);
				
				if(_mediaPlayer.currentMedia == button.item)
				{
					button.selected = true;
				}
				else
				{
					button.selected = false;
				}
			}
			if(!_notFirstLayout)
			{
				layoutComponents(false);
				_notFirstLayout = true;
			}
			else
			{
				layoutComponents();
			}
			
			
		}
		
		private function layoutComponents(animating:Boolean=true):void
		{
			var xCursor:Number = 0;
			for (var i:int=0;i<_buttons.length;i++)
			{
				var bt:ThumbnailButton = ThumbnailButton(_buttons[i]);
				if(animating)
				{
					TweenMax.to(bt,1,{
						ease:Strong.easeOut,
						x:xCursor,
						y:ThumbnailButton.HEIGHT - bt.effectiveHeight
					});
				}
				else
				{
					bt.x = xCursor;
					bt.y = ThumbnailButton.HEIGHT - bt.effectiveHeight;
				}
				xCursor += bt.effectiveWidth + PADDING;
			}
			width = xCursor;
			invalidateSize();
		}
		
		
		
	}
}

import mx.core.UIComponent;
import mx.controls.Image;
import mx.containers.Canvas;
import com.rudiyardley.player.model.MediaObject;
import flash.display.Sprite;
import com.greensock.TweenMax;
import com.greensock.easing.Strong;
import flash.events.MouseEvent;
import mx.managers.ToolTipManager;
import flash.events.Event;
import mx.events.ToolTipEvent;

class ThumbnailButton extends UIComponent
{
	public static const WIDTH:Number = 60;
	public static const HEIGHT:Number = 38;
	public static const WIDTH_MIN:Number = 48;
	public static const HEIGHT_MIN:Number = 30;
	public static const PADDING:Number = 4;
	public static const PADDING_MIN:Number = 4;
	
	private var _backgroundSprite:Sprite;
	private var _image:Image;
	
	
	public function ThumbnailButton()
	{
		super();
		
		mouseChildren = false;
		mouseEnabled = true;
		buttonMode = true;
		useHandCursor = true;
		
		_backgroundSprite = new Sprite();
		_backgroundSprite.graphics.beginFill(0xFFFFFF);
		_backgroundSprite.graphics.drawRect(0,0,WIDTH+PADDING_MIN,HEIGHT+PADDING_MIN);
		_backgroundSprite.graphics.endFill();
		effectiveHeight = HEIGHT+PADDING_MIN;
		effectiveWidth = WIDTH+PADDING_MIN;

		addChild(_backgroundSprite);
		
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		
		
	}
	
	private function onAdded(e:Event):void
	{
		addEventListener(ToolTipEvent.TOOL_TIP_SHOW, editTip);
	}
	
	private function editTip(e:ToolTipEvent):void
	{
		if(this.hitTestPoint(this.mouseX,this.mouseY));
			ToolTipManager.currentToolTip.text = _item.title;
	}
	
	private var _yCache:Number;
	public function runAnimation(delay:Number=0):void
	{
		_yCache = this.y;
		this.y += 20;
		this.alpha = 0;
		TweenMax.to(this, 0.5,{ease:Strong.easeOut, delay:delay, y: _yCache, alpha:1}); 
	}
	
	private var _selected:Boolean;
	public function set selected(value:Boolean):void
	{
		_selected = value;
		
		var imageW:Number;
		var imageH:Number;
		var bgW:Number;
		var bgH:Number;
		var imageX:Number;
		var imageY:Number;
		
		if(_selected)
		{
			imageW = WIDTH;
			imageH = HEIGHT;
			
			effectiveWidth = bgW = imageW+PADDING;
			effectiveHeight = bgH = imageH+PADDING;
			
			imageX = bgW/2 - imageW/2;
			imageY = bgH/2 - imageH/2;
			
			TweenMax.to(_backgroundSprite, 1, {ease:Strong.easeOut,width:bgW,height:bgH});
			TweenMax.to(_image, 1, {ease:Strong.easeOut,width:imageW, height:imageH,x:imageX,y:imageY});
			
		}
		else
		{
			imageW = WIDTH_MIN;
			imageH = HEIGHT_MIN;
			
			effectiveWidth = bgW = imageW+PADDING_MIN;
			effectiveHeight = bgH = imageH+PADDING_MIN;
		
			imageX = bgW/2 - imageW/2;
			imageY = bgH/2 - imageH/2;
			
			TweenMax.to(_backgroundSprite, 1, {ease:Strong.easeOut,width:bgW,height:bgH});
			TweenMax.to(_image, 1, {ease:Strong.easeOut,width:imageW, height:imageH,x:imageX,y:imageY});
		}
		
	}
	public function get selected():Boolean
	{
		return _selected;
	}
	
	public var effectiveWidth:Number;
	public var effectiveHeight:Number;
	
	private var _item:MediaObject;
	public function set item(value:MediaObject):void
	{
		
		_item = value;
		this.toolTip = _item.title;
		
		_image = new Image();
		_image.source = _item.thumbnailUrl;
		_image.width = WIDTH;
		_image.height = HEIGHT;
		_image.x = _backgroundSprite.width/2 - _image.width/2;
		_image.y = _backgroundSprite.height/2 - _image.height/2;
		
		addChild(_image);
	}
	
	override protected function measure():void
	{
		this.measuredWidth = WIDTH;
		this.measuredHeight = HEIGHT;
	}
	
	public function get item():MediaObject
	{
		return _item;
	}
}