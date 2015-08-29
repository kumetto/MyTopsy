package SharedClasses 
{
	import flash.display.Sprite;
	import flash.text.*
	
	/**
	 * ...
	 * @author Jordan
	 */
	public class Button extends Sprite
	{
		private var buttonText:String;
		private var _width:int;
		private var _alpha:Number;
		
		public function Button(width:int, text:String, buttonMode:Boolean = true,_alpha:Number = 0.5)
		{
			this._width = width;
			this.buttonText = text;
			this._alpha = _alpha;
			
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
			btn.graphics.lineStyle(1);
			btn.graphics.beginFill(0, _alpha);
			btn.graphics.drawRect(0, 0, _width, 40);
			btn.graphics.endFill();
			addChild(btn);
		}
		
		private function drawText():void
		{
			var tField:TextField = new TextField();
			tField.y = 10;
			tField.height = 20;
			tField.width = _width - 10;
			tField.x = 10
			tField.defaultTextFormat = new TextFormat('Arial', 15, 0xffffff);
			tField.mouseEnabled = false;
			tField.text = buttonText;
			addChild(tField);
		}
	}
}