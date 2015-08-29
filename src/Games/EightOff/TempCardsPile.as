package Games.EightOff
{
	import flash.display.Sprite;
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class TempCardsPile extends Sprite
	{
		private var cards:Array;
		private var firstCard:Card;
		private var cardsCount:int = 0;
		
		private var interval:int = 20;
		
		public function pushCard(card:Card):void
		{
			this.cards = [];
			this.cards.push(card);
			this.addChild(card);
			determineFirstCard();
		}
		
		public function giveCard():Card
		{
			var cardForGive:Card = this.cards.pop();
			this.removeChild(cardForGive);
			this.cards = null;
			return cardForGive;
		}
		
		public function pushCards(choosenCards:Array):void
		{
			this.cards = [];
			for (var cardIndex:int = 0; cardIndex < choosenCards.length; cardIndex++)
			{
				var currentCard:Card = choosenCards[cardIndex];
				this.addChild(currentCard);
				currentCard.y = this.cards.length * interval;
				this.cards.push(currentCard);
			}
			determineFirstCard();
		}
		
		public function giveCards():Array
		{
			var cardsForGive:Array = [];
			for (var cardIndex:int = 0; cardIndex < cards.length; cardIndex++)
			{
				var currentCard:Card = this.cards[cardIndex];
				cardsForGive.push(currentCard);
				this.removeChild(currentCard);
			}
			this.cards = null;
			return cardsForGive;
		}
		
		private function determineFirstCard():void
		{
			this.firstCard = this.cards[0];
		}
		
		public function get FirstCard():Card
		{
			return this.firstCard;
		}
		
		public function get CardsCount():int
		{
			return this.cards.length;
		}
	
	}

}