package Games.EightOff
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import SharedClasses.Assistant;
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class SidePile extends Sprite
	{
		private var suit:String;
		private var cards:Array = [];
		private var topCard:Card = null;
		
		private const CARD_WIDTH:int = 65;
		private const CARD_HEIGHT:int = 100;
		
		public function SidePile(suitPar:String)
		{
			this.suit = suitPar;
			drawBorder();
			drawSign();
		}
		
		private function drawSign():void
		{
			var signContainer:Sprite = new Sprite();
			var path:String = "Data/images/Suit/" + this.suit + ".png";
			Assistant.fillContainerWithImg(signContainer, path, 20, 20);
			this.addChild(signContainer);
			signContainer.x = 23;//in the middle
			signContainer.y = 35;
		}
		
		private function drawBorder():void
		{
			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0x0);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(CARD_WIDTH, 0);
			line.graphics.lineTo(CARD_WIDTH, CARD_HEIGHT);
			line.graphics.lineTo(0, CARD_HEIGHT);
			line.graphics.lineTo(0, 0);
			this.addChild(line);
		}
		
		public function pushCard(card:Card):void
		{
			this.addChild(card);
			card.x = 0;
			card.y = 0;
			this.cards.push(card);
			determineTopCard();
		}
		
		private function determineTopCard():void
		{
			this.topCard = this.cards[this.cards.length - 1];
		}
		
		public function get TopCard():Card
		{
			return this.topCard;
		}
		
		public function get Suit():String
		{
			return this.suit;
		}
		
		public function get CardsCount():int
		{
			return this.cards.length;
		}
	}

}