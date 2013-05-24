package com.rudiyardley.player.view.animation
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;

	public class ProgrammaticSpinnerAnimation extends Sprite
	{
		
		public var radius:Number = 12;
		public var centreSize:Number = 7;
		public var thickness:Number = 2;
		public var spokes:Number = 12; 
		
		private var _animationTimer:Timer;
		
		public function ProgrammaticSpinnerAnimation()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			_animationTimer = new Timer(80);
			_animationTimer.addEventListener(TimerEvent.TIMER,rotateMe);
			
			var holder:Sprite = new Sprite();
			
			for(var i:int=0; i<spokes;i++)
			{
				var m:Number = i/spokes;
				var spoke:Sprite = new Spoke(radius,centreSize,thickness, 0xFFFFFF);
				var ct:ColorTransform = new ColorTransform(m,m,m);
				spoke.transform.colorTransform = ct;
				spoke.rotation = (i+1)*(360/spokes);
				holder.addChild(spoke);
			}
			addChild(holder);
		}
		
		private function onAdded(e:Event):void
		{
			_animationTimer.start();
		}
		
		private function rotateMe(e:Event):void
		{
			rotation += (360/spokes);
			this.x = this.parent.width/2 - this.width/2;
			this.y = this.parent.height/2 - this.height/2;
			
		}
		
	}
}
	import flash.display.Sprite;
	

class Spoke extends Sprite
{
	public function Spoke(radius:Number,centreSize:Number,thickness:Number,color:int)
	{
		graphics.lineStyle(thickness,color,0);
		graphics.lineTo(0,-centreSize);
		graphics.lineStyle(thickness,color,1);
		graphics.lineTo(0,-radius);
	}
}
