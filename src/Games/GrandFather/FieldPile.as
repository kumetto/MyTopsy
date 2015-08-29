package Games.GrandFather
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author Mitko
	 */
	public class FieldPile extends Sprite
	{
		private var cardsInFieldPile:Array = [];
		private var topCard:Card;
		
		private const CARD_WIDTH:int = 65;
		private const CARD_HEIGHT:int = 100;
		
		public function FieldPile(fieldPileIndexPar:int)
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
			this.topCard = card;
			this.addChild(card);
			
			if (this.cardsInFieldPile.length == 0)
			{
				card.x = 0;
				card.y = 0;
			}
			
			else if (this.cardsInFieldPile.length == 1)
			{
				card.x = 10;
				card.y = 0;
			}
			this.cardsInFieldPile.push(card);
		}
		
		public function giveTopCard():Card
		{
			var currentTopCard:Card = this.topCard;
			this.removeChild(this.topCard);
			this.cardsInFieldPile.pop();
			if (this.cardsInFieldPile.length == 1)
			{
				var lastIndex:int = cardsInFieldPile.length - 1;
				this.topCard = this.cardsInFieldPile[lastIndex];
			}
			if (this.cardsInFieldPile.length == 0)
			{
				this.topCard = null;
			}
			return currentTopCard;
		}
		
		public function get TopCard():Card
		{ 				
			
			return this.topCard;
		}
		
		public function get CardsCount():int
		{ 		
			var cardsInThisFieldPile:int = this.cardsInFieldPile.length;
			return cardsInThisFieldPile;
		}
	
	}

}