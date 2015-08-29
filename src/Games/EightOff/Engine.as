package Games.EightOff
{
	import flash.display.Sprite;
	import SharedClasses.Assistant;
	import flash.events.MouseEvent;
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class Engine
	{
		private var general:Eightoff;
		private var extraPiles:Array = [];//8
		private var fieldPiles:Array = [];//8
		private var sidePiles:Array = [];//4
		private var tempPile:TempCardsPile = new TempCardsPile();
		
		private var deck:Deck;
		
		private var pressedExtraPile:ExtraPile;
		private var pressedFieldPile:FieldPile;
		private var cardForMoving:Card;
		private var cardsForMoving:Array;
		
		private var cardDropping:CardDropping;
		private var interaction:Interaction;
		
		public function Engine(generalPar:Eightoff, extraPilesPar:Array, fieldPilesPar:Array, sidePilesPar:Array, deckPar:Deck)
		{
			this.initFields(generalPar, extraPilesPar, fieldPilesPar, sidePilesPar, deckPar);
			this.dealCards();
			this.sendAcesToSidePiles();
			this.makeInteraction();
		}
		
		// AUTO FILL
		//// AUTO SEND ACES TO PILES
		private function sendAcesToSidePiles():void
		{
			sendAcesFromExtraToSide();
			sendAcesFromFieldToSide();
		}
		
		////// AUTO SEND ACES FROM FIELD PILE TO SIDE PILES
		private function sendAcesFromFieldToSide():void
		{
			var isThereMorePossible:Boolean = true;
			while (isThereMorePossible)
			{
				isThereMorePossible = false;
				for (var fieldPileIndex:int = 0; fieldPileIndex < this.fieldPiles.length; fieldPileIndex++)
				{
					var fieldPile:FieldPile = this.fieldPiles[fieldPileIndex];
					if (fieldPile.TopCard != null)
					{
						if (fieldPile.TopCard.CardValue == 1)
						{
							
							this.cardForMoving = fieldPile.giveCard();
							
							for (var sidePileIndex:int = 0; sidePileIndex < this.sidePiles.length; sidePileIndex++)
							{
								var sidePile:SidePile = this.sidePiles[sidePileIndex];
								if (sidePile.Suit == this.cardForMoving.CardSign)
								{
									sidePile.pushCard(this.cardForMoving);
									isThereMorePossible = true;
									break;
								}
							}
						}
					}
				}
			}
		}
		
		////// AUTO SEND ACES FROM EXTRA PILE TO SIDE PILE
		private function sendAcesFromExtraToSide():void
		{
			for (var extraPileIndex:int = 0; extraPileIndex < this.extraPiles.length; extraPileIndex++)
			{
				var extraPile:ExtraPile = this.extraPiles[extraPileIndex];
				if (!extraPile.isEmpty)
				{
					if (extraPile.itsCard.CardValue == 1)
					{
						this.cardForMoving = extraPile.giveCard();
						invokeTempPileToMouse();
						this.tempPile.pushCard(this.cardForMoving);
						for (var sidePileIndex:int = 0; sidePileIndex < this.sidePiles.length; sidePileIndex++)
						{
							var sidePile:SidePile = this.sidePiles[sidePileIndex];
							if (sidePile.Suit == this.tempPile.FirstCard.CardSign)
							{
								//tween tempPile to sidePile
								this.cardForMoving = this.tempPile.giveCard();
								sidePile.pushCard(this.cardForMoving);
							}
						}
					}
				}
			}
		}
		
		// EXTRA PILE DRAG&DROP
		//// DRAG CARD FROM EXTRA PILES
		private function dragCardFromExtraPile(e:MouseEvent):void
		{
			this.pressedExtraPile = e.currentTarget as ExtraPile;
			this.cardForMoving = this.pressedExtraPile.giveCard();
			this.invokeTempPileToMouse();
			this.tempPile.pushCard(this.cardForMoving);
			this.tempPile.startDrag();
			Assistant.addEventListenerTo(this.tempPile, MouseEvent.MOUSE_UP, dropTakenCardFromExtraPile);
		}
		
		
		//// DROP CARD FROM EXTRA PILE
		private function dropTakenCardFromExtraPile(e:MouseEvent):void
		{
			this.cardDropping.tryCardOnExtraPile();
			
			if (!(this.cardDropping.IsDropped))
			{
				this.cardDropping.tryCardOnFieldPile();
			}
			
			if (!(this.cardDropping.IsDropped))
			{
				this.cardDropping.tryCardOnSidePile();
				if (this.win())
				{
					this.makeWin();
				}
			}
			
			if (!(this.cardDropping.IsDropped))
			{
				this.returnCardToExtraPile();
			}
			Assistant.removeEventListenerTo(this.tempPile, MouseEvent.MOUSE_UP, dropTakenCardFromExtraPile);
			this.removeTempPile();
		}
		
		// FIELD PILES Drag&Drop	
		//// DRAG CARD FROM FIELD PILE
		private function dragCardsFromFieldPile(e:MouseEvent):void
		{
			this.pressedFieldPile = e.currentTarget as FieldPile;
			var choosenStartCard:Card;
			for (var cardIndex:int = 0; cardIndex < this.pressedFieldPile.CardsCount; cardIndex++)
			{
				var card:Card = pressedFieldPile.Cards[cardIndex];
				if (card.hitTestPoint(this.general.mouseX, this.general.mouseY))
				{
					choosenStartCard = card;
				}
			}
			
			var countOfChoosenCards:int = pressedFieldPile.countOfChoosenCards(choosenStartCard);
			if (pressedFieldPile.isSequenceFrom(choosenStartCard)&&(countOfChoosenCards<=emptyExtraPiles()||countOfChoosenCards==1))
			{
				this.cardsForMoving = this.pressedFieldPile.giveCards(choosenStartCard);
				this.invokeTempPileToMouse();
				this.tempPile.pushCards(this.cardsForMoving);
				this.tempPile.startDrag();
				Assistant.addEventListenerTo(this.tempPile, MouseEvent.MOUSE_UP, dropTakenCardsFromFieldPile);
			}
		}
		
		//// DROP CARD FROM FIELD PILE
		private function dropTakenCardsFromFieldPile(e:MouseEvent):void
		{
			if (this.tempPile.CardsCount == 1)
			{
				this.cardDropping.tryCardOnExtraPile();
				
				if (!(this.cardDropping.IsDropped))
				{
					this.cardDropping.tryCardOnFieldPile();
				}
				
				if (!(this.cardDropping.IsDropped))
				{
					this.cardDropping.tryCardOnSidePile();
					if (win())
					{
						makeWin();
					}
				}
			}
			else if (this.tempPile.CardsCount > 1)
			{
				this.cardDropping.tryCardsOnFieldPile();
			}
			
			if (!(this.cardDropping.IsDropped))
			{
				this.returnCardsToFieldPile();
			}
			
			Assistant.removeEventListenerTo(this.tempPile, MouseEvent.MOUSE_UP, dropTakenCardsFromFieldPile);
			this.removeTempPile();
			
			sendAcesFromFieldToSide();
		}
		
		// INIT FIELDS
		private function initFields(generalPar:Eightoff, extraPilesPar:Array, fieldPilesPar:Array, sidePilesPar:Array, deckPar:Deck):void
		{
			this.general = generalPar;
			this.extraPiles = extraPilesPar;
			this.fieldPiles = fieldPilesPar;
			this.sidePiles = sidePilesPar;
			this.deck = deckPar;
			this.cardDropping = new CardDropping(this.extraPiles, this.fieldPiles, this.sidePiles, this.cardForMoving, this.cardsForMoving, this.tempPile, this.general as Sprite);
			this.interaction = new Interaction(this.extraPiles, this.fieldPiles, this.sidePiles, this.dragCardFromExtraPile, this.dragCardsFromFieldPile);
		}
		
		// MAKE DEALING
		private function dealCards():void
		{
			var dealing:Dealing = new Dealing(this.deck, this.fieldPiles, this.extraPiles, this.sidePiles);
			dealing.initialDealing();
		}
		
		// MAKE GAME OVER
		private function makeGameOver():void
		{
			this.general.IsGameRunning = false;
		}
		
		// MAKE WIN
		private function makeWin():void
		{
			this.general.IsWin = true;
			this.makeGameOver();
		}
		
		// INVOKE TEMP PILE TO MOUSE
		private function invokeTempPileToMouse():void
		{
			this.general.addChild(tempPile);
			this.tempPile.x = general.mouseX - 20;
			this.tempPile.y = general.mouseY - 20;
		}
		
		// REMOVE TEMP PILE FROM GENERAL CONTAINER
		private function removeTempPile():void
		{
			this.general.removeChild(tempPile);
		}
		
		// RETURN CARD TO PILE WHILE CANT BE DROPPED
		//// RETURN CARD TO EXTRA PILE 
		private function returnCardToExtraPile():void
		{
			this.pressedExtraPile.pushCard(this.cardForMoving);
		}
		
		//// RETURN CARD TO FIELD PILE
		private function returnCardsToFieldPile():void
		{
			this.pressedFieldPile.pushCards(this.cardsForMoving);
		}
		
		// RETURN COUNT OF CHOOSEN CARDS -> FOR SUPER MOVE
		private function emptyExtraPiles():int {
			var count:int = 0;
			for (var extraPileIndex:int = 0; extraPileIndex < this.extraPiles.length; extraPileIndex++) {
				var extraPile:ExtraPile = this.extraPiles[extraPileIndex];
				if (extraPile.isEmpty) {
					count++;	
				}
			}
			return count++;
		}
		
		// CHECK FOR WIN
		private function win():Boolean
		{
			var filledSidePilesCount:int = 0;
			for (var sidePileIndex:int = 0; sidePileIndex < this.sidePiles.length; sidePileIndex++)
			{
				var currentSidePile:SidePile = this.sidePiles[sidePileIndex];
				if (currentSidePile.CardsCount >= 13)
				{
					filledSidePilesCount++;
				}
			}
			if (filledSidePilesCount == 8) 
			{
				return true;	
			}
			else 
			{
				return false;
			}
		}
		
		// ADD EVENT LISTENERS TO PILES
		private function makeInteraction():void
		{
			this.interaction.makeExtraPilesInteractive();
			this.interaction.makeFieldPilesInteractive();
		}
		
	}

	
}