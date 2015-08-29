package SharedClasses
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Kaloqn
	 */
	public class TimerCounter extends Sprite
	{
		private var tHours:String;
		private var tMinutes:String;
		private var tSeconds:String;
		private var seconds:Number;
		private var minutes:Number;
		private var hours:Number;
		private var tField:TextField;
		private var _timerTxtColor:uint;
		private var textSize:int;
		
		public function TimerCounter(timerTxtColor:uint = 0, textSizePar:int = 15)
		{
			_timerTxtColor = timerTxtColor;
			this.textSize = textSizePar;
			loadTimer();
		}
		
		private function loadTimer():void
		{
			
			seconds = Math.floor(0);
			minutes = Math.floor(seconds / 60);
			hours = Math.floor(minutes / 60);
			
			hours %= 24;
			minutes %= 60;
			seconds %= 60;
			
			var timer:Timer = new Timer(1000);
			
			tField = new TextField();
			
			var txtFormat:TextFormat = new TextFormat('Comic Sans MS', this.textSize, _timerTxtColor, true);
			txtFormat.align = "center";
			tField.defaultTextFormat = txtFormat;
			tField.mouseEnabled = false;
			addChild(tField);
			
			timer.addEventListener(TimerEvent.TIMER, clock);
			timer.start();
		}
		
		public function get GetTime():String
		{
			return tField.text;
		}
		
		private function clock(evt:TimerEvent):void
		{
			tHours = (hours < 10) ? "0" + hours.toString() : hours.toString();
			tMinutes = (minutes < 10) ? "0" + minutes.toString() : minutes.toString();
			tSeconds = (seconds < 10) ? "0" + seconds.toString() : seconds.toString();
			
			seconds += 1;
			
			if (seconds > 59)
			{
				minutes += 1;
				seconds = 00;
			}
			tField.text = String(tHours + ":" + tMinutes + ":" + tSeconds);
		}
	}
}