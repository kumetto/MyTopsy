package Games.Alternations
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
	public class AlternationHelpMenu extends Sprite
	{
		private var TxtBox:TextField = new TextField();
		private var backGround:Sprite = new Sprite();
		
		public function AlternationHelpMenu()
		{
			loadBackground();
			loadText();
		}
		
		private function loadBackground():void
		{
			addChild(backGround);
			backGround.alpha = 0.2;
			backGround.graphics.beginFill(0x000000);
			backGround.graphics.drawRect(0, 0, 500, 350);
			backGround.graphics.endFill();
		}
		
		private function loadText():void
		{
			var TxtBoxTextFormat:TextFormat = new TextFormat();
			TxtBox.setTextFormat(TxtBoxTextFormat);
			TxtBox.defaultTextFormat = new TextFormat('Comic Sans MS', 20, 0xFFFFFF, 'bold');
			TxtBox.text = "All top cards of tableau piles are available to play.You can move cards from one tableau pile to another one.You may build tableau piles down regardless of suit.You can move either a single card or a set of cards.When one of the piles becomes empty you can fill the space with any available single card or set of cards.If, during play, any of closed becomes the top card of a pile, it is automatically turned over. ";
			TxtBox.x = 50;
			TxtBox.wordWrap = true;
			TxtBox.mouseEnabled = false;
			TxtBox.selectable = false;
			TxtBox.textColor = 0xFFFFFF;
			TxtBox.height = 350;
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