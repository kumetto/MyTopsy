package Games.TopsyTurvyQueens
{
	
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.net.*;
	import flash.geom.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import SharedClasses.*;;
	
	/**
	 * ...
	 * @author SS
	 */
	public class TopsyTurvyQueensMenu extends Sprite
	{
		
		private var backgroundContainer:Sprite = new Sprite();
		private var buttonsContainer:Sprite = new Sprite();
		private var rulesButton:TopsyMenuButton;
		private var newGameButton:TopsyMenuButton;
		private var rules:Sprite;
		private var isWin:Boolean = false;
		private var isGameRunning:Boolean = true;
		private var buttonsSoundChannel:SoundChannel = new SoundChannel();
		private var buttonSound:Sound = new Sound();
		
		public function TopsyTurvyQueensMenu(skinPath:String = "")
		{
			
			loadMenuButtons();
			var topsy:TopsyQueensPlay = new TopsyQueensPlay();
			addChild(topsy);
			var time:TimerCounter = new TimerCounter(0xFFFFFF);
			addChild(time);
			time.x = 405;
			time.y = 2;
		
		}
		
		public function get IsGameRunning():Boolean
		{
			return this.isGameRunning;
		}
		
		public function get IsWin():Boolean
		{
			return this.isWin;
		}
		
		private function loadMenuButtons():void
		{
			addChild(buttonsContainer);
			newGameButton = new TopsyMenuButton(100, 20, 30, 30, "Surrender", true, 0, 0.5, -3);
			newGameButton.x = 100;
			newGameButton.y = 5;
			buttonsContainer.addChild(newGameButton);
			newGameButton.addEventListener(MouseEvent.CLICK, surrender, false, 0, true);
			newGameButton.addEventListener(MouseEvent.CLICK, buttonsSound);
			var statisticsButton:TopsyMenuButton = new TopsyMenuButton(100, 20, 30, 30, "Statistics", true, 0, 0.5, -3);
			statisticsButton.x = 202;
			statisticsButton.y = 5;
			buttonsContainer.addChild(statisticsButton);
			statisticsButton.addEventListener(MouseEvent.CLICK, buttonsSound);
			rulesButton = new TopsyMenuButton(100, 20, 30, 30, "Rules", true, 0, 0.5, -3);
			rulesButton.x = 304;
			rulesButton.y = 5;
			buttonsContainer.addChild(rulesButton);
			rulesButton.addEventListener(MouseEvent.CLICK, showRules, false, 0, true);
			rulesButton.addEventListener(MouseEvent.CLICK, buttonsSound);
			var timerButton:TopsyMenuButton = new TopsyMenuButton(100, 20, 30, 30, "", false, 0, 0.5, -3);
			timerButton.x = 406;
			timerButton.y = 5;
			buttonsContainer.addChild(timerButton);
		    
			buttonSound.load(new URLRequest("Data/sound/Blop.mp3"));
			
		}
		
		private function buttonsSound(e:MouseEvent):void 
		{
			buttonsSoundChannel = buttonSound.play();
		}
		
		private function surrender(e:MouseEvent):void
		{
			gameOver();
		
		}
		
		private function gameOver():void
		{
			isGameRunning = false;
		}
		
	private function howToPlay():void
		{
			var rulesTxtField:TextField = new TextField();
			rulesTxtField.defaultTextFormat = new TextFormat('Comic Sans MS', 15, 0x000000, 'bold');
			rulesTxtField.text = "Topsy-turvy Queens\n2 decks. Average. 2 redeals.\nThis solitaire uses 104 cards (2 decks). The seven cards with their faces down (closed) are the King's row. Eight foundation piles are placed on top of the closed card. The last eighth foundation pile doesn't have an imprisoned card under it.You also have 8 tableau piles with 4 cards in each pile.\nKings are moved to the foundations as they become available.\nThe object of the game\To build the foundations up in suit to Queens.\nThe rules\nIf a King is the top card of any of the tableau piles it is moved to the foundation and placed on top of the closed card in the King's Row. So this closed card becomes imprisoned. It will be free only after you built up the whole suit over it in order of rank (K,A,2,3..,Q). Foundation piles are filled up from left to right as soon as new King's appear. The last eighth king doesn't have an imprisoned card under it.You may build tableau piles down in suit.. \n You can move either a single card or a set of cards. The top card of each tableau pile can be moved to the King's row if it is possible.When you have made all the moves initially available, click the stock pile to begin turning cards over. The card that is face up on top of the deck is always available for play. You can move the top card from the stock pile to the foundations (up in suit) or to one of tableau piles (down in suit). Empty tableau's may be filled with any single card or group of cards in proper sequence. As soon as you build up the suit so that the Queen is on top, the imprisoned card becomes free. You can move this card only onto the King's row (you cannot move it onto any tableau pile). When you have made all the available moves on the board and you still have cards in the stock you can turn it over two more times. You win when all cards are on the foundations.";
			addChild(rulesTxtField);
			rulesTxtField.height = 400;
			rulesTxtField.width = 580;
			rulesTxtField.x = 810;
			rulesTxtField.y = 65;
			rulesTxtField.selectable = false;
			rulesTxtField.wordWrap = true;
			
			rules = new Sprite();
			rules.graphics.beginFill(0xE8E397);
			rules.graphics.drawRoundRect(10, 40, 780, 440, 500, 400);
			rules.graphics.endFill();
			
			rules.alpha = 1;
			addChild(rules);
			rules.addChild(rulesTxtField);
			rules.addEventListener(MouseEvent.CLICK, closeRules, false, 0, true);
			
			TweenMax.to(rulesTxtField, 0.4, {x: 120, y: 65});
		}
		
		private function showRules(e:MouseEvent):void
		{
			howToPlay();
			rulesButton.removeEventListener(MouseEvent.CLICK, showRules);
			TweenMax.to(rulesButton, 0.5, {y: -25});
		}
		
		private function closeRules(e:MouseEvent):void
		{
			rulesButton.addEventListener(MouseEvent.CLICK, showRules, false, 0, true);
			TweenMax.to(rules, 0.5, {x: 750, y: 0});
			TweenMax.to(rulesButton, 0.5, {x: 304, y: 5});
			setTimeout(dropChild, 500);
		
		}
		
		private function dropChild():void
		{
			removeChild(rules);
		
		}
	
	}

}