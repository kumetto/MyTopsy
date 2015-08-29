package Games.TopsyTurvyQueens
{
	import flash.display.Sprite;
	import flash.text.*
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author SS
	 */
	public class TopsyMenuButton extends Sprite
	{
		private var buttonText:String;
		private var _width:int;
		private var _height:int;
		private var _alpha:Number;
		private var _buttonColor:uint;
		private var _textPaddingTop:int;
		private var _elipseHeight:int;
		private var _elipseWidth:int;
		
		public function TopsyMenuButton(width:int, height:int, elipseWidth:int,elipseHeight:int, text:String, buttonMode:Boolean = true, buttonColor:uint = 0, alpha:Number = 0.5, textPaddingTop:Number = 0)
		{
			_width = width;
			_height = height;
			_buttonColor = buttonColor;
			_alpha = alpha;
			this.buttonText = text;
			_textPaddingTop = textPaddingTop;
			_elipseHeight = elipseHeight;
			_elipseWidth = elipseWidth;
			if (buttonMode)
			{
				this.buttonMode = true;
			}
			
			init();
			drawText();
		}
		
		private function init():void
		{
			var btn:Sprite = new Sprite();
			btn.graphics.lineStyle(1, 0, _alpha);
			btn.graphics.beginFill(_buttonColor, _alpha);
			btn.graphics.drawRoundRect(0, 0,_width,_height,_elipseWidth,_elipseHeight);
			btn.graphics.endFill();
			addChild(btn);
			btn.addEventListener(MouseEvent.MOUSE_OVER, addGlow, false, 0, true);
			btn.addEventListener(MouseEvent.MOUSE_OUT, removeGlow, false, 0, true);
		}
		
		private function drawText():void
		{
			var tField:TextField = new TextField();
			tField.y = _textPaddingTop;
			tField.height = 30;
			tField.width = _width - 10;
			tField.x = 5;
			var txtFormat:TextFormat = new TextFormat('Comic Sans MS', 15, 0xFFFFFF,true);
			txtFormat.align = "center";
			tField.defaultTextFormat = txtFormat;
			tField.mouseEnabled = false;
			tField.text = buttonText;
			addChild(tField);
			tField.addEventListener(MouseEvent.MOUSE_OVER, addGlow, false, 0, true);
			tField.addEventListener(MouseEvent.MOUSE_OUT, removeGlow, false, 0, true);
		}
	
		private function addGlow(e:MouseEvent):void 
		{
			TweenMax.to(e.currentTarget,1,{glowFilter:{color:0xFFFFFF, alpha:1, blurX:50, blurY:50}});
		}
		private function removeGlow(e:MouseEvent):void 
		{
			TweenMax.to(e.currentTarget,1,{glowFilter: { alpha: 0 }});
		}
		
	}
}