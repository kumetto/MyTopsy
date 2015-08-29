package Games.Prison
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Kaloqn
	 */
	public class PrisonHelpMenu extends Sprite
	{
		private var TxtBox:TextField = new TextField();
		private var backGround:Sprite = new Sprite();
		
		public function PrisonHelpMenu()
		{
			loadBackground();
			loadText();
		}
		
		private function loadBackground():void
		{
			addChild(backGround);
			backGround.alpha = 0.2;
			backGround.graphics.beginFill(0x000000);
			backGround.graphics.drawRect(0, 0, 500, 300);
			backGround.graphics.endFill();
		}
		
		private function loadText():void
		{
			var TxtBoxTextFormat:TextFormat = new TextFormat();
			TxtBox.setTextFormat(TxtBoxTextFormat);
			TxtBox.defaultTextFormat = new TextFormat('Comic Sans MS', 20, 0xFFFFFF, 'bold');
			TxtBox.text = "The top cards of tableau piles and cards from cells are available to play. You may build tableau piles down in suit. Only one card at a time can be moved. The top card of any tableau pile can also be moved to any cell. Each cell may contain only one card. Cards in the cells can be moved to the foundation piles or back to the tableau piles, if possible.";
			TxtBox.x = 50;
			TxtBox.wordWrap = true;
			TxtBox.mouseEnabled = false;
			TxtBox.selectable = false;
			TxtBox.textColor = 0Xffffff;
			TxtBox.height = 300;
			TxtBox.width = 400;
			TxtBox.border = false;
			TxtBox.borderColor = 0X000000;
			addChild(TxtBox);
			TxtBox.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownScroll);
		}
		
		private function mouseDownScroll(event:MouseEvent):void
		{
			TxtBox.scrollV++;
		}
	}
}