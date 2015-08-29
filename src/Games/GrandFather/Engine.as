package Games.GrandFather
{
	/**
	 * ...
	 * @author Kolarov
	 */
	import flash.display.Sprite;
	import flash.events.*;
	import SharedClasses.Assistant;
	import SharedClasses.Card;
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	public class Engine
	{
		private var deck:Deck;
		private var deckPile:DeckPile;
		private var fieldPiles:Array;
		private var sidePiles:Array;
		
		private var generalContainer:Grandfather;
		
		private var takenCard:Card;
		private var pressedFieldPile:FieldPile;
		private var pressedDeckPile:DeckPile;
		
		private var isThereEmpties:Boolean = true;//is field var for use object as reference
		
		private var isAllowed:Boolean;
		
		public function Engine(deckPar:Deck, deckPilePar:DeckPile, fieldPilesPar:Array, sidePilesPar:Array, generalContainerPar:Grandfather)
		{
			initFields(deckPar, deckPilePar, fieldPilesPar, sidePilesPar, generalContainerPar);
			dealing();
			autoFillEmptiesOnDealing();
			makeInteraction();
		}
		
		// DRAG CARD FROM DECK PILE
		private function dragTopCardFromDeckPile(e:MouseEvent):void
		{
			this.pressedDeckPile = e.currentTarget as DeckPile;
			if(this.pressedDeckPile.TopCard!=null){
				this.takenCard = this.pressedDeckPile.giveTopCard();
				this.generalContainer.addChild(this.takenCard as Card);
				this.takenCard.x = this.pressedDeckPile.x;
				this.takenCard.y = this.pressedDeckPile.y;
				this.takenCard.startDrag();
				Assistant.addEventListenerTo(takenCard, MouseEvent.MOUSE_UP, dropTakenCardFromDeckPile);
			}
		}
		
		// DROP TAKEN CARD FROM DECK PILE
		private function dropTakenCardFromDeckPile(e:MouseEvent):void
		{
			takenCard.stopDrag();
			this.isAllowed = false;
			
			tryToDropOnFieldPile();
			tryToDropOnSidePile();
			
			if (!isAllowed)
			{
				returnTakenCardToDeckPile();
			}
			Assistant.removeEventListenerTo(takenCard, MouseEvent.MOUSE_UP, dropTakenCardFromDeckPile);
			this.takenCard = null;
		}
		
		// PUT CARD ON DECK PILE WHILE DECK IS PRESSED
		private function putCardOnDeckPile(e:MouseEvent):void
		{
			if(deck.CardsCount!=0){
				var deckTopCard:Card = deck.giveTopCard();
				if (deckTopCard != null)
				{
					this.deckPile.pushCard(deckTopCard);
					//autoFillEmptyFieldPiles();
				}
			}
			if (deck.CardsCount == 0)
			{
				if (deck.ReloadedTimesLeft == 0)
				{
					Assistant.removeEventListenerTo(this.deck, MouseEvent.CLICK, putCardOnDeckPile);
					this.generalContainer.removeChild(this.deck);
				}
				if (deck.ReloadedTimesLeft == 1)
				{
					this.deck.ReloadDeck(this.deckPile.Cards);
				}
			}
		}
		
		// DRAG CARD FROM FIELD PILES	
		private function dragTopCardFromFieldPile(e:MouseEvent):void
		{
			this.pressedFieldPile = e.currentTarget as FieldPile;
			if(this.pressedFieldPile.TopCard!=null){
				this.takenCard = pressedFieldPile.giveTopCard();
				this.generalContainer.addChild(this.takenCard as Card);
				this.takenCard.x = this.pressedFieldPile.x;
				this.takenCard.y = this.pressedFieldPile.y;
				this.takenCard.startDrag();
				Assistant.addEventListenerTo(takenCard, MouseEvent.MOUSE_UP, dropTakenCardFromFieldPile);
			}
		}
		
		//DROP CARD TAKEN CARD FROM FIELD PILES
		private function dropTakenCardFromFieldPile(e:MouseEvent):void
		{
			takenCard.stopDrag();
			isAllowed = false;
			
			tryToDropOnSidePile();
			
			Assistant.removeEventListenerTo(this.takenCard, MouseEvent.MOUSE_UP, dropTakenCardFromFieldPile);
			if (!isAllowed)
			{
				returnTakenCardToFieldPile();
			}
			else
			{
				//autoFillEmptyFieldPiles();
			}
			if (Assistant.isThereWin(this.sidePiles))
			{
				this.generalContainer.IsGameRunning = false;
				this.generalContainer.IsWin = true;
			}
			this.takenCard = null;
		}
		
		// CARD DROPPING
		//// CHECK IF CAN BE DROPPED ON FIELD PILE
		private function tryToDropOnFieldPile():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < this.fieldPiles.length; fieldPileIndex++)
			{
				var currentFieldPile:FieldPile = fieldPiles[fieldPileIndex];
				//if (this.takenCard.hitTestObject(currentFieldPile)) {// this.takenCard goes to first field pile thath hit
				if (currentFieldPile.hitTestPoint(this.generalContainer.mouseX, this.generalContainer.mouseY))
				{
					if (currentFieldPile.CardsCount >=0 && currentFieldPile.CardsCount<2 )
					{
						this.isAllowed = true;
						this.generalContainer.removeChild(this.takenCard);
						currentFieldPile.pushCard(this.takenCard);
						break;
					}
				}
			}
		}
		
		//// CHECK IF CAN BE DROPPED ON FIELD PILE
		private function tryToDropOnSidePile():void
		{
			for (var sidePileIndex:int = 0; sidePileIndex < this.sidePiles.length; sidePileIndex++)
			{
				var currentSidePile:SidePile = sidePiles[sidePileIndex];
				if (this.takenCard.hitTestObject(currentSidePile))
				{
					// if no cards in side pile
					if (this.takenCard.CardValue == 1 && this.takenCard.CardSign == currentSidePile.Sign && currentSidePile.TopCard == null && currentSidePile.StartValue == 1)
					{
						this.isAllowed = true;
						this.generalContainer.removeChild(this.takenCard);
						currentSidePile.pushCard(this.takenCard);
						break;
					}
					if (this.takenCard.CardValue == 13 && this.takenCard.CardSign == currentSidePile.Sign && currentSidePile.TopCard == null && currentSidePile.StartValue == 13)
					{
						isAllowed = true;
						this.generalContainer.removeChild(this.takenCard);
						currentSidePile.pushCard(this.takenCard);
						break;
					}
					// if there are cards in side pile
					if (currentSidePile.TopCard != null)
					{
						if (currentSidePile.StartValue == 1 && this.takenCard.CardSign == currentSidePile.Sign && this.takenCard.CardValue == (currentSidePile.TopCard.CardValue + 1))
						{
							isAllowed = true;
							this.generalContainer.removeChild(this.takenCard);
							currentSidePile.pushCard(this.takenCard);
							break;
						}
						if (currentSidePile.StartValue == 13 && this.takenCard.CardSign == currentSidePile.Sign && this.takenCard.CardValue == (currentSidePile.TopCard.CardValue - 1))
						{
							isAllowed = true;
							this.generalContainer.removeChild(this.takenCard);
							currentSidePile.pushCard(this.takenCard);
							break;
						}
					}
				}
			}
		}
		
		// MAKE INTERACTION:
		private function makeInteraction():void
		{
			makeDeckInteractive();
			makeDeckPileInteractive();
			makeInteractiveFieldPiles();
		}
		
		//// ON DECK PILE
		private function makeDeckPileInteractive():void
		{
			Assistant.addEventListenerTo(this.deckPile, MouseEvent.MOUSE_DOWN, dragTopCardFromDeckPile);
		}
		
		//// ON DECK
		private function makeDeckInteractive():void
		{
			Assistant.addEventListenerTo(this.deck, MouseEvent.CLICK, putCardOnDeckPile);
		}
		
		//// ON FIELD PILES
		private function makeInteractiveFieldPiles():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < fieldPiles.length; fieldPileIndex++)
			{
				var currentFieldPile:FieldPile = fieldPiles[fieldPileIndex];
				if (currentFieldPile.TopCard != null)
				{
					Assistant.addEventListenerTo(currentFieldPile, MouseEvent.MOUSE_DOWN, dragTopCardFromFieldPile);
				}
			}
		}
		
		// MAKE DEALING
		private function dealing():void
		{
			Assistant.dealing(this.deck, this.fieldPiles);
		}
		
		// AUTO FILL EMPTIES
		//// FILL EMPTIES AFTER DEALING
		private function autoFillEmptiesOnDealing():void
		{
			while (isThereEmpties)
			{
				this.isThereEmpties = false;
				autoFillSidePilesCorrectOnDealing();
				autoFillEmptyFieldPilesOnDealing();
			}
		}
		
		////// FILL EMPTIES ON FIELD PILES AFTER DEALING
		private function autoFillEmptyFieldPilesOnDealing():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < fieldPiles.length; fieldPileIndex++)
			{
				var currentFieldPile:FieldPile = fieldPiles[fieldPileIndex];
				if (currentFieldPile.TopCard == null)
				{
					this.takenCard = deck.giveTopCard();
					currentFieldPile.pushCard(this.takenCard);
					this.isThereEmpties = true;
				}
			}
		}
		
		////// FILL EMPTIES ON SIDE PILES AFTER DEALING
		private function autoFillSidePilesCorrectOnDealing():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < fieldPiles.length; fieldPileIndex++)
			{
				var currentFieldPile:FieldPile = fieldPiles[fieldPileIndex];
				if (currentFieldPile.TopCard.CardValue == 1 || currentFieldPile.TopCard.CardValue == 13)
				{
					this.takenCard = currentFieldPile.giveTopCard();
					for (var sidePileIndex:int = 0; sidePileIndex < sidePiles.length; sidePileIndex++)
					{
						var currentSidePile:SidePile = sidePiles[sidePileIndex];
						if (currentSidePile.Sign == this.takenCard.CardSign && currentSidePile.StartValue == this.takenCard.CardValue)
						{
							//todo: motion from field pile to currentSidePile
							currentSidePile.pushCard(this.takenCard);
							this.isThereEmpties = true;
						}
					}
				}
			}
		}
		
		//// FILL EMPTIES ON FIELD PILES DURING THE GAME
		private function autoFillEmptyFieldPiles():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < fieldPiles.length; fieldPileIndex++)
			{
				var currentFieldPile:FieldPile = fieldPiles[fieldPileIndex];
				if (currentFieldPile.TopCard == null)
				{
					if (this.deckPile.TopCard == null)
					{
						if (this.deck.CardsCount != 0)
						{
							this.takenCard = deck.giveTopCard();
						}
					}
					else
					{
						this.takenCard = deckPile.giveTopCard();
					}
					currentFieldPile.pushCard(this.takenCard);
					//todo: motion from deck pile to currentFieldPile
					break;
				}
			}
		}
		
		// CARD RETURNING IF CANT BE DROPPED
		//// RETURN TO FIELD PILES
		private function returnTakenCardToFieldPile():void
		{
			if (this.takenCard != null)
			{
				this.takenCard.parent.removeChild(this.takenCard);
				this.pressedFieldPile.pushCard(this.takenCard);
			}
		}
		
		//// RETURN TO DECK PILE
		private function returnTakenCardToDeckPile():void
		{
			if (this.takenCard != null)
			{
				this.takenCard.parent.removeChild(this.takenCard);
				this.deckPile.pushCard(this.takenCard);
			}
		}
		
		// INIT FIELDS
		private function initFields(deckPar:Deck, deckPilePar:DeckPile, fieldPilesPar:Array, sidePilesPar:Array, generalContainerPar:Grandfather):void
		{
			this.deck = deckPar;
			this.deckPile = deckPilePar;
			this.fieldPiles = fieldPilesPar;
			this.sidePiles = sidePilesPar;
			this.generalContainer = generalContainerPar;
		}
	
	}

}