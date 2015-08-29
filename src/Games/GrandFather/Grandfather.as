package Games.GrandFather
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import SharedClasses.*
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class Grandfather extends Sprite
	{
		private var rulesText:String = "	This solitaire uses 104 cards (2 decks). You have 20 tableau piles with one card per pile and 8 foundations. \n Aces (one of each suit) are moved to the left four foundations as they become available. \n Kings (one of each suit) are moved to the right four foundations as they become available. \n The object of the game: To build the foundation Aces up in suit to Kings, to build the foundation Kings down in suit to Aces. \n The rules: The top cards of tableau piles are available for play on foundations. You can move the cards from the waste pile to any tableau pile regardless of suit or rank. Each pile may contain up to 2 cards. Spaces are filled automatically from the waste or the stock piles. Cards cannot be moved from one tableau pile to another. \n When you have made all the moves initially available, begin turning over cards from the stock to the waste pile. The top card of the waste pile is available for play on the foundations or the tableau. \n There is one redeal.";
		private var deck:Deck;
		private var deckPile:DeckPile;
		private var fieldPiles:Array = [];
		private var sidePiles:Array = [];
		
		private const FieldPilesInRow:int = 10;
		
		private const StartPointField:Point = new Point(140, 20);
		private const StartPointSide:Point = new Point(600, 20);
		private const CardWidth:int = 65;
		private const CardHeight:int = 100;
		
		private var gameEngine:Engine;
		
		private var cardSkinPath:String;
		
		private var buttonRules:Button;
		private var rules:Rules;
		private var isRulesHidden:Boolean = true;
		private var buttonSurrender:GameButton;
		
		private var isWin:Boolean = false;
		private var isGameRunning:Boolean = true;
		
		private var timer:TimerCounter;
		private var cardSkin:String;
		
		public function Grandfather(cardSkinPar:String)
		{
			loadInitialComponents(cardSkinPar);
			gameEngine = new Engine(this.deck, this.deckPile, this.fieldPiles, this.sidePiles, this);
		}
		
		private function loadInitialComponents(cardSkinPar:String):void
		{
			loadButtons();
			loadTimer();
			loadDeck(cardSkinPar);
			loadDeckPile();
			loadFieldPiles();
			loadSidePiles();
		}
		
		private function loadTimer():void
		{
			this.timer = new TimerCounter(0xFFFFFF, 12);
			this.timer.alpha = 1;
			this.addChild(timer);
		}
		
		private function loadButtons():void
		{
			loadButtonRules();
			loadButtonSurrender();
		}
		
		private function loadButtonSurrender():void
		{
			this.buttonSurrender = new GameButton("Surrender");
			this.addChild(this.buttonSurrender);
			this.buttonSurrender.x = 720;
			this.buttonSurrender.y = 0;
			Assistant.addEventListenerTo(this.buttonSurrender, MouseEvent.CLICK, surrender)
		}
		
		private function surrender(e:MouseEvent):void
		{
			this.isWin = false;
			this.isGameRunning = false;
		}
		
		private function loadButtonRules():void
		{
			this.buttonRules = new Button(120, "How To Play...");
			this.addChild(buttonRules);
			this.buttonRules.x = 0;
			this.buttonRules.y = 559;
			Assistant.addEventListenerTo(this.buttonRules, MouseEvent.CLICK, showHideRules);
			this.rules = new Rules(rulesText);
		}
		
		private function showHideRules(e:MouseEvent):void
		{
			if (this.isRulesHidden)
			{
				this.addChild(rules);
				this.isRulesHidden = false;
			}
			
			else
			{
				this.removeChild(rules);
				this.isRulesHidden = true;
			}
		}
		
		private function loadDeck(cardSkinPar:String):void
		{
			this.cardSkin = cardSkinPar;
			this.deck = new Deck(this.cardSkin);
			this.deck = new Deck(cardSkinPar);
			this.addChild(this.deck);
			this.deck.x = 20;
			this.deck.y = 140;
		}
		
		private function loadDeckPile():void
		{
			this.deckPile = new DeckPile();
			this.addChild(this.deckPile);
			this.deckPile.x = 20;
			this.deckPile.y = 260;
		}
		
		private function loadFieldPiles():void
		{
			var pileIndex:int = 0;
			var interval:int = 20;
			
			for (var row:int = 0; row < 4; row++)
			{
				for (var col:int = 0; col < 5; col++)
				{
					pileIndex++;
					var fieldPile:FieldPile = new FieldPile(pileIndex);
					this.addChild(fieldPile);
					fieldPiles.push(fieldPile);
					fieldPile.x = this.StartPointField.x + col * (interval + CardWidth);
					fieldPile.y = this.StartPointField.y + row * (interval + CardHeight);
				}
			}
		}
		
		private function loadSidePiles():void
		{
			var startValues:Array = [1, 13];
			var suits:Array = ["D", "H", "C", "S"];
			
			var interval:int = 20;
			
			for (var row:int = 0; row < 4; row++)
			{
				var currentSuit:String = suits[row];
				
				for (var col:int = 0; col < 2; col++)
				{
					var currentValue:int = startValues[col];
					var sidePile:SidePile = new SidePile(currentValue, currentSuit);
					this.addChild(sidePile);
					sidePile.y = StartPointSide.y + (interval + 100) * row;
					sidePile.x = StartPointSide.x + (interval + 65) * col;
					this.sidePiles.push(sidePile);
				}
			}
		}
		
		public function get IsWin():Boolean
		{
			return this.isWin;
		}
		
		public function get IsGameRunning():Boolean
		{
			return this.isGameRunning;
		}
		
		public function set IsWin(newValue:Boolean):void
		{
			this.isWin = newValue;
		}
		
		public function set IsGameRunning(newValue:Boolean):void
		{
			this.isGameRunning = newValue;
		}
	}

}