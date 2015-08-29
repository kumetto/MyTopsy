package Games.GrandFather
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author
	 */
	public class DeckPile extends Sprite
	{
		private var cardsInDeckPile:Array = [];
		private var topCard:Card;
		
		private const CARD_WIDTH:int = 65;
		private const CARD_HEIGHT:int = 100;
		
		public function DeckPile()
		{
			drawBorder();
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
			this.cardsInDeckPile.push(card);
			this.addChild(card);
			card.x = 0;
			card.y = 0;
			this.topCard = card;
		}
		
		public function giveTopCard():Card
		{
			var currentTopCard:Card = this.topCard;
			this.removeChild(this.topCard);
			this.cardsInDeckPile.pop();
			if (this.cardsInDeckPile.length != 0)
			{
				this.topCard = this.cardsInDeckPile[cardsInDeckPile.length - 1];
			}
			if (this.cardsInDeckPile.length == 0)
			{
				this.topCard = null;
			}
			return currentTopCard;
		}
		
		public function get Cards():Array
		{
			this.topCard = null;
			return this.cardsInDeckPile;
		}
		
		public function get TopCard():Card
		{
			return this.topCard;
		}
	}

}