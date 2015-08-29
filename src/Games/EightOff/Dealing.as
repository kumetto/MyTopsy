package Games.EightOff
{
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class Dealing
	{
		private var deck:Deck;
		private var fieldPiles:Array;
		private var extraPiles:Array;
		private var sidePiles:Array;
		
		public function Dealing(deckPar:Deck, fieldPilesPar:Array, extraPilesPar:Array, sidePilesPar:Array)
		{
			this.deck = deckPar;
			this.fieldPiles = fieldPilesPar;
			this.extraPiles = extraPilesPar;
			this.sidePiles = sidePilesPar;
		}
		
		public function initialDealing():void
		{
			dealToFieldPiles();
			dealToExtraPiles();
		}
		
		private function dealToFieldPiles():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < 8; fieldPileIndex++)
			{
				var fieldPile:FieldPile = this.fieldPiles[fieldPileIndex];
				for (var cardIndex:int = 0; cardIndex < 6; cardIndex++)
				{
					var card:Card = this.deck.giveTopCard();
					fieldPile.pushCard(card);
				}
			}
		}
		
		private function dealToExtraPiles():void
		{
			for (var extraPileIndex:int = 0; extraPileIndex < 4; extraPileIndex++)
			{
				var extraPile:ExtraPile = this.extraPiles[extraPileIndex];
				var card:Card = this.deck.giveTopCard();
				extraPile.pushCard(card);
			}
		}
	}

}