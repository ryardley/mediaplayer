package iluka.utils
{
	import com.rudiyardley.reporting.Console;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class MouseIdleTimer extends EventDispatcher
	{
		public static const NOT_IDLE:String = "NOT_IDLE";
		public static const IDLE:String = "IDLE";
		
		private var _scope:DisplayObject;
		private var _mouseMoveTimer:Timer;
		
		public function MouseIdleTimer(scope:DisplayObject, waitTimeSeconds:Number)
		{
			Console.info(this,"MouseIdleTimer()");
			
			_scope = scope;
			_mouseMoveTimer = new Timer(waitTimeSeconds*1000, 1);
			_mouseMoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchIdle);
			
		}
		
		public function start():void
		{
			Console.info(this,"start()");
			_mouseMoveTimer.start();
			_scope.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_scope.addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveHandler);
		}
		
		public function stop():void
		{
			Console.info(this,"stop()");
			_mouseMoveTimer.stop();
			_scope.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_scope.removeEventListener(MouseEvent.MOUSE_DOWN, mouseMoveHandler);
		}
		
		private function mouseMoveHandler(e:Event=null):void
		{
			_mouseMoveTimer.stop();
			_mouseMoveTimer.start();
			dispatchEvent(new Event(NOT_IDLE));
		}
		
		private function dispatchIdle(e:Event=null):void
		{
			Console.info(this,"dispatchIdle()");
			dispatchEvent(new Event(IDLE));
		}
		
		
	}
}