package Games.Prison
{
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.net.URLRequest;
	import SharedClasses.*
	
	/**
	 * ...
	 * @author Jordan
	 */
	public class PrisonSolitaire extends Sprite
	{
		private const STAGE_WIDTH:int = 800;
		private const STAGE_HEIGHT:int = 600;
		
		private const FOUNDATION_CONTAINER_X:int = 250;
		private const FOUNDATION_CONTAINER_Y:int = 70;
		private const RESERVE_CONTAINER_X:int = 100;
		private const RESERVE_CONTAINER_Y:int = 195;
		private const TAUBLE_CONTAINER_X:int = 25;
		private const TAUBLE_CONTAINER_Y:int = 320;
		private const CONTAINER_WIDTH:int = 65;
		private const CONTAINER_HEIGHT:int = 100;
		private const CONTAINER_WIDTH_SPACING:int = 10;
		private const CARDS_Y_SPACING:int = 35;
		
		private var cardsSkin:String;
		
		private var score:int = 0;
		
		private var cards:Vector.<Card> = new Vector.<Card>();
		private var isWin:Boolean = false;
		private var isGameRunning:Boolean = true;
		private var counterPlacedCards:int = 0;
		
		private var movCardCurrentSprite:Sprite;
		private var movCardNewSprite:Sprite;
		private var movingCardObject:Sprite;
		private var movCardToFoundation:Boolean = false;
		private var movingCardX:int;
		private var movingCardY:int;
		
		private var menuContainer:Sprite;
		private var buttonsContainer:Sprite;
		private var foundationContainer:Sprite;
		private var reservesContainer:Sprite;
		private var taublePilesContainer:Sprite;
		
		public function PrisonSolitaire(cardsSkin:String = "skin1/")
		{
			this.cardsSkin = cardsSkin
			showMenu()
		}
		
		public function get IsGameRunning():Boolean
		{
			return this.isGameRunning;
		}
		
		public function get IsWin():Boolean
		{
			return this.isWin;
		}
		
		private function showMenu():void
		{
			menuContainer = new Sprite();
			
			var helpMenu:PrisonHelpMenu = new PrisonHelpMenu();
			menuContainer.addChild(helpMenu);
			
			var startButton:MenuButton = new MenuButton("start.png");
			startButton.addEventListener(MouseEvent.CLICK, startGame, false, 0, true);
			startButton.x = 150;
			startButton.y = helpMenu.height + 20;
			startButton.buttonMode = true;
			menuContainer.addChild(startButton);
			
			menuContainer.x = STAGE_WIDTH / 2 - menuContainer.width / 2;
			addChild(menuContainer);
		}
		
		private function startGame(e:MouseEvent):void
		{
			removeChild(menuContainer);
			menuContainer = null;
			
			showSurrenderAndTimer();
			
			DealSolitaire();
		}
		
		private function showSurrenderAndTimer():void
		{
			buttonsContainer = new Sprite();
			
			var buttonWidth:int = 100;
			
			var surrenderButton:Button = new Button(buttonWidth, "  Surrender", true);
			surrenderButton.addEventListener(MouseEvent.CLICK, surrender, false, 0, true);
			
			var time:TimerCounter = new TimerCounter(0xffffff);
			time.y = 60;
			
			buttonsContainer.x = STAGE_WIDTH - buttonWidth;
			buttonsContainer.addChild(time);
			buttonsContainer.addChild(surrenderButton);
			
			addChild(buttonsContainer);
		}
		
		private function DealSolitaire():void
		{
			addCardContainers();
			
			loadDeck();
			loadCardsFoundation();
			loadReservedCards();
			loadTaublePilesCards();
		}
		
		private function loadCardsFoundation():void
		{
			var rndCardNumber:int = randomRange(0, 52 - counterPlacedCards);
			
			var counter:int = 0;
			var counterAddedCards:int = 0;
			
			var cardNumbers:int = 13;
			var cardColors:int = 4
			
			for (var cardValue:int = 0; cardValue < cardNumbers; cardValue++)
			{
				for (var cardSign:int = 0; cardSign < cardColors; cardSign++)
				{
					if (counter == rndCardNumber)
					{
						for (var card:int = cardValue * cardColors; card < cardValue * cardColors + cardColors; card++)
						{
							var object:Sprite = foundationContainer.getChildAt(counterAddedCards) as Sprite;
							object.addChild(cards[card - counterAddedCards])
							
							//removing buttonMode for the foundation cards
							var currentCard:Card = object.getChildAt(1) as Card;
							currentCard.buttonMode = false;
							currentCard.removeEventListener(MouseEvent.MOUSE_DOWN, startDraging);
							currentCard.removeEventListener(MouseEvent.MOUSE_UP, stopDraging);
							
							cards.splice(card - counterAddedCards, 1);
							counterAddedCards++;
							counterPlacedCards++;
						}
					}
					counter++;
				}
			}
			
			//TODO: find the logic bug sometimes not filling foundation piles 
			//hard coded bug fix 
			var foundationPile:Sprite = foundationContainer.getChildAt(0) as Sprite
			if (foundationPile.numChildren < 2)
			{
				loadCardsFoundation();
			}
		}
		
		private function loadReservedCards():void
		{
			var reservedPiles:int = 8;
			
			for (var i:int = 0; i < reservedPiles; i++)
			{
				var reservedPile:Sprite = reservesContainer.getChildAt(i) as Sprite;
				dealRandomCard(reservedPile);
			}
		}
		
		private function loadTaublePilesCards():void
		{
			var taublePiles:int = 10;
			var taubleCards:int = 4;
			
			for (var pile:int = 0; pile < taublePiles; pile++)
			{
				for (var card:int = 0; card < taubleCards; card++)
				{
					var pileContainer:Sprite = taublePilesContainer.getChildAt(pile) as Sprite;
					var cardY:int = (pileContainer.numChildren - 1) * CARDS_Y_SPACING;
					dealRandomCard(pileContainer, cardY);
				}
			}
		}
		
		private function startDraging(e:MouseEvent):void
		{
			if (isLastCardOfPile(e.target as Card))
			{
				movingCardObject = e.target as Sprite;
				
				movCardCurrentSprite = movingCardObject.parent as Sprite;
				movingCardObject.parent.removeChild(movingCardObject);
				
				addChild(movingCardObject);
				movingCardObject.x = mouseX - movingCardObject.width / 2;
				movingCardObject.y = mouseY - movingCardObject.height / 2;
				
				movingCardX = mouseX;
				movingCardY = mouseY;
				
				e.target.startDrag();
			}
		}
		
		private function stopDraging(e:MouseEvent):void
		{
			if (movingCardObject != null)
			{
				movingCardObject.stopDrag();
				var movingCard:Card = movingCardObject as Card;
				
				if (canBeMoved(movingCard))
				{
					removeChild(movingCardObject);
					movingCardObject.x = 0;
					
					if (movCardToFoundation)
					{
						movingCardObject.y = 0;
						movingCardObject.buttonMode = false;
						movingCardObject.removeEventListener(MouseEvent.MOUSE_DOWN, startDraging);
						movingCardObject.removeEventListener(MouseEvent.MOUSE_UP, stopDraging);
						
						score += 100;
					}
					else
					{
						movingCardObject.y = (movCardNewSprite.numChildren - 1) * CARDS_Y_SPACING
					}
					
					movCardNewSprite.addChild(movingCardObject);
					checkWin();
					
					resetMovCardVariables();
				}
				else // can't be moved 
				{
					removeChild(movingCardObject);
					
					e.target.x = 0
					e.target.y = (movCardCurrentSprite.numChildren - 1) * CARDS_Y_SPACING
					movCardCurrentSprite.addChild(movingCardObject);
					
					resetMovCardVariables();
				}
			}
		
		}
		
		private function resetMovCardVariables():void
		{
			movCardNewSprite = null;
			movCardToFoundation = false;
			movingCardObject = null;
			movCardCurrentSprite = null;
		}
		
		private function canBeMoved(givenCard:Card):Boolean
		{
			// check if card can be moved to target possition and if its true sets the sprite field to it 
			
			//foundation container
			if (givenCard.hitTestObject(foundationContainer))
			{
				for (var pile:int = 0; pile < foundationContainer.numChildren; pile++)
				{
					var pileContainer:Sprite = foundationContainer.getChildAt(pile) as Sprite;
					var lastCardIndex:int = pileContainer.numChildren - 1;
					var lastCard:Card = pileContainer.getChildAt(lastCardIndex) as Card;
					
					if (givenCard.hitTestObject(pileContainer))
					{
						if (givenCard.CardSign == lastCard.CardSign)
						{
							if (lastCard.CardValue != 13)
							{
								if (lastCard.CardValue + 1 == givenCard.CardValue)
								{
									movCardToFoundation = true;
									movCardNewSprite = pileContainer as Sprite;
									return true;
								}
							}
							else if (lastCard.CardValue == 13 && givenCard.CardValue == 1)
							{
								movCardToFoundation = true;
								movCardNewSprite = pileContainer as Sprite;
								return true;
							}
						}
					}
				}
			}
			
			//reserve container
			if (givenCard.hitTestObject(reservesContainer))
			{
				for (var pile:int = 0; pile < reservesContainer.numChildren; pile++)
				{
					var pileContainer:Sprite = reservesContainer.getChildAt(pile) as Sprite;
					
					if (givenCard.hitTestObject(pileContainer))
					{
						if (pileContainer.numChildren == 1)
						{
							movCardNewSprite = pileContainer as Sprite;
							return true;
						}
					}
				}
			}
			
			//tauble container
			if (givenCard.hitTestObject(taublePilesContainer))
			{
				for (var pile:int = 0; pile < taublePilesContainer.numChildren; pile++)
				{
					var pileContainer:Sprite = taublePilesContainer.getChildAt(pile) as Sprite;
					var lastCardIndex:int = pileContainer.numChildren - 1;
					var lastCard:Card = pileContainer.getChildAt(lastCardIndex) as Card;
					
					if (givenCard.hitTestObject(pileContainer))
					{
						if (pileContainer.numChildren > 1)
						{
							if (givenCard.CardSign == lastCard.CardSign)
							{
								if (lastCard.CardValue - 1 == givenCard.CardValue)
								{
									movCardNewSprite = pileContainer as Sprite;
									return true;
								}
							}
						}
						else
						{
							movCardNewSprite = pileContainer as Sprite;
							return true;
						}
					}
				}
			}
			
			return false
		}
		
		private function isLastCardOfPile(givenCard:Card):Boolean
		{
			//checks in each container - reserved and container if the given object is equal to the last in the pile 
			
			//check if card is from reserves container
			if (givenCard.parent.parent == reservesContainer)
			{
				return true;
			}
			
			//check for tauble pile
			for (var pile:int = 0; pile < taublePilesContainer.numChildren; pile++)
			{
				var pileContainer:Sprite = taublePilesContainer.getChildAt(pile) as Sprite;
				
				var lastCardIndex:int = pileContainer.numChildren - 1;
				
				var card:Card = pileContainer.getChildAt(lastCardIndex) as Card;
				
				if (givenCard == card)
				{
					return true;
				}
				
			}
			
			return false;
		}
		
		private function addCardContainers():void
		{
			fillFoundationContainer();
			fillReserveContainer();
			fillTaubleContainer();
			
			function fillTaubleContainer():void
			{
				taublePilesContainer = new Sprite();
				taublePilesContainer.x = TAUBLE_CONTAINER_X
				taublePilesContainer.y = TAUBLE_CONTAINER_Y
				
				for (var cardCount:int = 0; cardCount < 10; cardCount++)
				{
					var containerX:int = CONTAINER_WIDTH * cardCount + cardCount * CONTAINER_WIDTH_SPACING;
					taublePilesContainer.addChild(addCardContainer(containerX, "tauble" + cardCount));
				}
				
				addChild(taublePilesContainer);
			}
			
			function fillReserveContainer():void
			{
				reservesContainer = new Sprite();
				reservesContainer.x = RESERVE_CONTAINER_X;
				reservesContainer.y = RESERVE_CONTAINER_Y;
				
				for (var cardCount:int = 0; cardCount < 8; cardCount++)
				{
					var containerX:int = CONTAINER_WIDTH * cardCount + cardCount * CONTAINER_WIDTH_SPACING;
					reservesContainer.addChild(addCardContainer(containerX, "reserve" + cardCount));
				}
				
				addChild(reservesContainer);
			}
			
			function fillFoundationContainer():void
			{
				foundationContainer = new Sprite();
				foundationContainer.x = FOUNDATION_CONTAINER_X;
				foundationContainer.y = FOUNDATION_CONTAINER_Y;
				
				for (var cardCount:int = 0; cardCount < 4; cardCount++)
				{
					var containerX:int = CONTAINER_WIDTH * cardCount + cardCount * CONTAINER_WIDTH_SPACING;
					foundationContainer.addChild(addCardContainer(containerX, "foundation" + cardCount));
				}
				
				addChild(foundationContainer);
			}
			
			function addCardContainer(x:int, name:String):Sprite
			{
				var container:Sprite = new Sprite();
				container.x = x;
				container.name = name;
				container.addChild(new PileBackground());
				
				return container;
			}
		}
		
		private function checkWin():void
		{
			isWin = true;
			
			for (var pile:int = 0; pile < foundationContainer.numChildren; pile++)
			{
				var pileContainer:Sprite = foundationContainer.getChildAt(pile) as Sprite;
				
				if (pileContainer.numChildren != 14)
				{
					isWin = false
				}
			}
			
			if (isWin)
			{
				gameOver();
			}
		}
		
		private function surrender(e:MouseEvent):void
		{
			gameOver();
		}
		
		private function gameOver():void
		{
			isGameRunning = false;
		}
		
		private function dealRandomCard(dealAt:Sprite, y:int = 0):void
		{
			var rndCardNumber:int = randomRange(0, 51 - counterPlacedCards);
			dealAt.addChild(cards[rndCardNumber]).y = y;
			counterPlacedCards++;
			cards.splice(rndCardNumber, 1);
		}
		
		private function loadDeck():void
		{
			var cardUrl:String;
			var cardNumbers:int = 14;
			var cardColors:int = 4
			
			for (var i:int = 0; i < cardNumbers; i++)
			{
				if (i == 0)
				{ //pass back card
					continue;
				}
				
				for (var j:int = 0; j < cardColors; j++)
				{
					var cardColor:String;
					
					if (i == 0)
					{
						cardColor = "Back";
						cardUrl = i + cardColor;
						
						var card:Card = new Card(cardUrl, i, cardsSkin);
						cards.push(card);
						
						break;
					}
					else
					{
						switch (j)
						{
						case 0: 
							cardColor = "C";
							break;
						case 1: 
							cardColor = "D";
							break;
						case 2: 
							cardColor = "H";
							break;
						case 3: 
							cardColor = "S";
							break;
						}
					}
					
					cardUrl = i + cardColor;
					
					var card:Card = new Card(cardUrl, i, cardsSkin);
					card.addEventListener(MouseEvent.MOUSE_DOWN, startDraging, false, 0, true);
					card.addEventListener(MouseEvent.MOUSE_UP, stopDraging, false, 0, true);
					card.buttonMode = true;
					cards.push(card);
				}
			}
		}
		
		private function randomRange(minNum:Number, maxNum:Number):int
		{
			return (int(Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum));
		}
	}
}