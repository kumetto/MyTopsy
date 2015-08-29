package Games.EightOff
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class CardDropping
	{
		private var general:Sprite;
		private var extraPiles:Array;
		private var fieldPiles:Array;
		private var sidePiles:Array;
		
		private var cardForMoving:Card;
		private var cardsForMoving:Array;
		
		private var tempPile:TempCardsPile;
		
		private var isDropped:Boolean = false;
		
		public function CardDropping(extraPilesPar:Array, fieldPilesPar:Array, sidePilesPar:Array, cardForMovingPar:Card, cardsForMovingPar:Array, tempPilePar:TempCardsPile, generalPar:Sprite)
		{
			this.extraPiles = extraPilesPar;
			this.fieldPiles = fieldPilesPar;
			this.sidePiles = sidePilesPar;
			this.cardForMoving = cardForMovingPar;
			this.cardsForMoving = cardsForMovingPar;
			this.tempPile = tempPilePar;
			this.general = generalPar;
		}
		
		public function tryCardOnExtraPile():void
		{
			this.isDropped = false;// we check first every time extra piles and isDropped is false 
			
			for (var extraPileIndex:int = 0; extraPileIndex < extraPiles.length; extraPileIndex++)
			{
				var extraPile:ExtraPile = this.extraPiles[extraPileIndex];
				if (extraPile.hitTestPoint(this.general.mouseX, this.general.mouseY))
				{
					if (extraPile.isEmpty)
					{
						this.cardForMoving = this.tempPile.giveCard();
						extraPile.pushCard(this.cardForMoving);
						this.isDropped = true;
						this.tempPile.stopDrag();
					}
				}
			}
		
		}
		
		public function tryCardOnFieldPile():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < fieldPiles.length; fieldPileIndex++)
			{
				var fieldPile:FieldPile = this.fieldPiles[fieldPileIndex];
				if (fieldPile.hitTestPoint(this.general.mouseX, this.general.mouseY))
				{
					if (fieldPile.CardsCount != 0 && fieldPile.TopCard.CardValue - 1 == this.tempPile.FirstCard.CardValue && fieldPile.TopCard.CardSign == this.tempPile.FirstCard.CardSign || fieldPile.CardsCount == 0 && tempPile.FirstCard.CardValue == 13)
					{
						this.cardForMoving = this.tempPile.giveCard();
						fieldPile.pushCard(this.cardForMoving);
						this.isDropped = true;
						this.tempPile.stopDrag();
					}
				}
			}
		}
		
		public function tryCardOnSidePile():void
		{
			for (var sidePileIndex:int = 0; sidePileIndex < sidePiles.length; sidePileIndex++)
			{
				var sidePile:SidePile = this.sidePiles[sidePileIndex];
				if (sidePile.hitTestPoint(this.general.mouseX, this.general.mouseY))
				{
					if ((sidePile.CardsCount == 0 && this.tempPile.FirstCard.CardValue == 1 && sidePile.Suit == this.tempPile.FirstCard.CardSign) || (sidePile.CardsCount != 0 && sidePile.TopCard.CardValue == this.tempPile.FirstCard.CardValue - 1 && sidePile.Suit == tempPile.FirstCard.CardSign))
					{
						this.cardForMoving = this.tempPile.giveCard();
						sidePile.pushCard(this.cardForMoving);
						this.isDropped = true;
						this.tempPile.stopDrag();
					}
				}
			}
		}
		
		public function tryCardsOnFieldPile():void
		{
			this.isDropped = false;//we call only this function and isDroped is false at the begining of the check
			for (var fieldPileIndex:int = 0; fieldPileIndex < this.fieldPiles.length; fieldPileIndex++)
			{
				var fieldPile:FieldPile = this.fieldPiles[fieldPileIndex];
				if (fieldPile.hitTestPoint(this.general.mouseX, this.general.mouseY))
				{
					if (((fieldPile.CardsCount > 0) && (fieldPile.TopCard.CardValue == this.tempPile.FirstCard.CardValue + 1) && (fieldPile.TopCard.CardSign == this.tempPile.FirstCard.CardSign)) || (fieldPile.CardsCount == 0 && this.tempPile.FirstCard.CardValue == 13))
					{
						this.cardsForMoving = this.tempPile.giveCards();
						fieldPile.pushCards(this.cardsForMoving);
						this.isDropped = true;
						this.tempPile.stopDrag();
					}
				}
			}
		}
		
		public function get IsDropped():Boolean
		{
			return this.isDropped;
		}
	
	}

}