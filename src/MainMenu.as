package
{
	import air.desktop.URLFilePromise;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*
	import flash.text.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import SharedClasses.*;
	import Games.GrandFather.Grandfather;
	import Games.EightOff.Eightoff;
	import Games.Prison.PrisonSolitaire;
	import Games.Alternations.AlternationSolitaire
	import Games.TopsyTurvyQueens.TopsyTurvyQueensMenu
	
	/**
	 * ...
	 * @author SolitaireTeam
	 */
	
	public class MainMenu extends Sprite
	{
		private const MAIN_MENU_BUTTONS:Vector.<String> = new <String>["prison.png", "eightOff.png", "grandFather.png", "alternations.png", "topsyTurvyQueens.png"]
		
		private const STAGE_WIDTH:int = 800;
		private const STAGE_HEIGHT:int = 600;
		private const BUTTON_WIDTH:int = 200;
		private const BUTTON_HEIGHT:int = 60;
		private const BUTTON_SPACING:int = 5;
		
		private var backgroundPath:String = "background1.jpg";
		private var cardPath:String = "Skin1/";
		private var cash:int = 1000;
		private var bet:int = 0;
		
		private var backgroundContainer:Sprite = new Sprite();
		private var musicButtonContainer:Sprite = new Sprite();
		private var settingsButtonContainer:Sprite = new Sprite();
		private var winMessageContainer:Sprite = new Sprite();
		private var loseMessageContainer:Sprite = new Sprite();
		
		private var buttonsContainer:Sprite = new Sprite();
		private var menuContainer:Sprite = new Sprite();
		private var settingsContainer:Sprite = new Sprite();
		
		private var moneyStatus:Button;
		private var betStatus:Button;
		private var ingame:Boolean = false;
		private var standClicked:Boolean = false;
		private var inSettings:Boolean = false;
		
		public function MainMenu()
		{
			loadBackground();
			loadMenuButtons();
			loadBetButtons();
			loadWinLoseSprites();
			loadSettingsButton();
			loadMusic();
		}
		
		private function loadMenuButtons():void
		{
			addChild(menuContainer);
			
			var buttonCounter:int = 0;
			
			for (var i:int = 0; i < MAIN_MENU_BUTTONS.length; i++)
			{
				var button:MenuButton = new MenuButton(MAIN_MENU_BUTTONS[i]);
				button.x = STAGE_WIDTH / 2 - BUTTON_WIDTH / 2;
				button.y = STAGE_HEIGHT / 5 + BUTTON_HEIGHT * buttonCounter + BUTTON_SPACING * buttonCounter;
				button.buttonMode = true;
				menuContainer.addChild(button);
				
				//add event listener
				var functionName:String = MAIN_MENU_BUTTONS[i].substring(0, MAIN_MENU_BUTTONS[i].length - 4);
				var buttonFunction:Function = this[functionName];
				button.addEventListener(MouseEvent.CLICK, buttonFunction);
				
				buttonCounter++;
			}
		}
		
		private function prison(e:Event):void
		{
			startGame(PrisonSolitaire);
		}
		
		private function eightOff(e:Event):void
		{
			startGame(Eightoff);
		}
		
		private function grandFather(e:Event):void
		{
			
			startGame(Grandfather)
		}
		
		private function alternations(e:Event):void
		{
			startGame(AlternationSolitaire)
		}
		
		private function topsyTurvyQueens(e:Event):void
		{
			startGame(TopsyTurvyQueensMenu);
		}
		
		private function clearSettingsButton():void
		{
			removeChild(settingsButtonContainer);
		}
		
		private function showSettingsButton():void
		{
			addChild(settingsButtonContainer);
		}
		
		private function startGame(game:Object):void
		{
			if (this.bet > 0)
			{
				clearMainMenu();
				clearBetButtons();
				clearSettingsButton();
				var selectedGame:Sprite = new game(cardPath);
				selectedGame.addEventListener(Event.ENTER_FRAME, checkGameOver, false, 0, true);
				
				addChild(selectedGame);
			}
			else
			{
				TweenMax.to(betStatus, 1.25, {glowFilter: {color: 0xff0000, alpha: 1, blurX: 30, blurY: 30, strength: 5}});
				TweenMax.to(betStatus, 1.25, {glowFilter: {color: 0xff0000, alpha: 1, blurX: 30, blurY: 30, strength: 5, remove: true}});
			}
		}
		
		private function checkGameOver(e:Event):void
		{
			if (e.target.IsGameRunning == false)
			{
				e.target.removeEventListener(Event.ENTER_FRAME, checkGameOver);
				removeChild(e.target as Sprite);
				
				if (e.target.IsWin == true)
				{
					cash += bet * 2;
					bet = 0;
					updateStatusBar();
					displayWin();
				}
				else
				{
					bet = 0;
					updateStatusBar();
					displayLose();
				}
			}
		}
		
		private function loadWinLoseSprites():void {
			var winMessagePath:String = "Data/images/Buttons/winImage.png";
			var loseMessagePath:String = "Data/images/Buttons/loseImage.png";
			
			Assistant.fillContainerWithImg(winMessageContainer, winMessagePath,450,200);
			Assistant.fillContainerWithImg(loseMessageContainer, loseMessagePath,450,200);
		}
		
		private function displayWin():void
		{
			addChild(winMessageContainer);
			TweenMax.to(winMessageContainer, 1, {x: 180, y: 200, ease: Bounce.easeOut});
			TweenMax.to(winMessageContainer, 1, {x: 900, y: 200, delay: 2.5});
			setTimeout(clearMessage, 4000);
		}
		
		private function displayLose():void
		{
			addChildAt(loseMessageContainer,this.numChildren);
			TweenMax.to(loseMessageContainer, 1, {x: 180, y: 200, ease: Bounce.easeOut});
			TweenMax.to(loseMessageContainer, 1, { x: 900, y: 200, delay: 2.5 } );
			
			setTimeout(clearMessage, 4000);
		}
		
		private function resetWinLoseContainers():void { 
			loseMessageContainer.x = 0;
			loseMessageContainer.y = 0;
			winMessageContainer.x = 0;
			winMessageContainer.y = 0;
			
			try 
			{
				removeChild(loseMessageContainer);				
			}
			catch (err:Error)
			{
				
			}
			try 
			{
				removeChild(winMessageContainer);
			}
			catch (err:Error)
			{
				
			}
		}
		
		private function clearMessage():void
		{
			resetWinLoseContainers();
			showMainMenu();
		}
		
		private function loadMusic():void
		{
			var musicButtonWidth:int = 40;
			var musicButtonHeight:int = 40;
			var spacePadding:int = 10;
			
			addChild(musicButtonContainer);
			musicButtonContainer.y = STAGE_HEIGHT - musicButtonHeight - spacePadding;
			musicButtonContainer.x = STAGE_WIDTH - musicButtonWidth - spacePadding;
			
			var music:Music = new Music();
			music.showButton();
			
			musicButtonContainer.addChild(music);
		}
		
		private function loadSettingsButton():void
		{
			Assistant.fillContainerWithImg(this.settingsButtonContainer, "Data/images/Buttons/settingIcon.png", 40, 40);
			addChild(settingsButtonContainer);
			settingsButtonContainer.x = STAGE_WIDTH - 110;
			settingsButtonContainer.y = STAGE_HEIGHT - 50;
			settingsButtonContainer.addEventListener(MouseEvent.CLICK, settings);
			
			loadSettingsMenu();
		}
		
		private function settings(E:Event):void
		{
			
			if (!inSettings)
			{
				inSettings = !inSettings;
				clearMainMenu();
				clearBetButtons();
				addChild(settingsContainer);
			}
			else
			{
				inSettings = !inSettings;
				removeChild(settingsContainer);
				showMainMenu();
			}
		}
		
		private function loadSettingsMenu():void
		{
			Assistant.fillContainerWithImg(this.settingsContainer, "Data/images/Background/background1.png", 700, 500);
			this.settingsContainer.x = 50;
			this.settingsContainer.y = 40;
			
			var buttonTableBackground1:Sprite = new Sprite();
			var buttonTableBackground2:Sprite = new Sprite();
			var buttonCardBackSkin1:Sprite = new Sprite();
			var buttonCardBackSkin2:Sprite = new Sprite();
			
			var buttonTxtFiled:TextField = new TextField();
			buttonTxtFiled.defaultTextFormat = new TextFormat('Comic Sans MS', 20, 0xffffff, 'bold');
			buttonTxtFiled.text = "Choose table background:";
			buttonTxtFiled.x = 40;
			buttonTxtFiled.y = 30;
			buttonTxtFiled.mouseEnabled = true;
			buttonTxtFiled.height = 50;
			buttonTxtFiled.width = 400;
			buttonTxtFiled.selectable = false;
			settingsContainer.addChild(buttonTxtFiled);
			
			var buttonTxtFiled2:TextField = new TextField();
			buttonTxtFiled2.defaultTextFormat = new TextFormat('Comic Sans MS', 20, 0xffffff, 'bold');
			buttonTxtFiled2.text = "Choose card skin:";
			buttonTxtFiled2.x = 40;
			buttonTxtFiled2.y = 220;
			buttonTxtFiled2.mouseEnabled = true;
			buttonTxtFiled2.height = 50;
			buttonTxtFiled2.width = 400;
			buttonTxtFiled2.selectable = false;
			settingsContainer.addChild(buttonTxtFiled2);
			
			Assistant.fillContainerWithImg(buttonTableBackground1, "Data/images/Background/background1.jpg", 160, 100);
			buttonTableBackground1.name = "Data/images/Background/background1.jpg";
			buttonTableBackground1.x = 40;
			buttonTableBackground1.y = 90;
			buttonTableBackground1.buttonMode = true;
			buttonTableBackground1.addEventListener(MouseEvent.CLICK, function():void
			{
				if (backgroundPath != "background1.jpg")
				{
					backgroundPath = "background1.jpg";
					updateBackground();
				}
			});
			settingsContainer.addChild(buttonTableBackground1);
			
			Assistant.fillContainerWithImg(buttonTableBackground2, "Data/images/Background/background2.jpg", 160, 100);
			buttonTableBackground2.name = "Data/images/Background/background2.jpg";
			buttonTableBackground2.x = 280;
			buttonTableBackground2.y = 90;
			buttonTableBackground2.buttonMode = true;
			buttonTableBackground2.addEventListener(MouseEvent.CLICK, function():void
			{
				if (backgroundPath != "background2.jpg")
				{
					backgroundPath = "background2.jpg";
					updateBackground();
				}
			});
			settingsContainer.addChild(buttonTableBackground2);
			
			Assistant.fillContainerWithImg(buttonCardBackSkin1, "Data/images/Cards/Skin1/0Back.png", 80, 120);
			buttonCardBackSkin1.x = 40;
			buttonCardBackSkin1.y = 300;
			buttonCardBackSkin1.buttonMode = true;
			buttonCardBackSkin1.addEventListener(MouseEvent.CLICK, function():void
			{
				cardPath = "skin1/"
			});
			settingsContainer.addChild(buttonCardBackSkin1);
			
			Assistant.fillContainerWithImg(buttonCardBackSkin2, "Data/images/Cards/Skin2/0Back.png", 80, 120);
			buttonCardBackSkin2.x = 200;
			buttonCardBackSkin2.y = 300;
			buttonCardBackSkin2.buttonMode = true;
			buttonCardBackSkin2.addEventListener(MouseEvent.CLICK, function():void
			{
				cardPath = "Skin2/";
			});
			settingsContainer.addChild(buttonCardBackSkin2);
		
		}
		
		private function updateBackground():void
		{
			backgroundContainer.removeChildren();
			removeChild(backgroundContainer);
			
			loadBackground();
		}
		
		private function showMainMenu():void
		{
			addChild(menuContainer);
			showBetButtons();
			showSettingsButton();
			updateStatusBar();
		}
		
		private function loadBackground():void
		{
			addChildAt(backgroundContainer, 0);
			
			var backgroundUrl:URLRequest = new URLRequest("Data/images/Background/" + backgroundPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleate);
			loader.load(backgroundUrl);
			var background:Bitmap;
			function loaderCompleate():void
			{
				var bmp:Bitmap = loader.content as Bitmap;
				background = new Bitmap(bmp.bitmapData);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleate);
				backgroundContainer.addChild(background);
			}
		}
		
		private function loadBetButtons():void
		{
			addChild(buttonsContainer);
			var buttonWidth:int = 65;
			
			moneyStatus = new Button(120, "Credits: " + cash.toString(), false);
			addChild(moneyStatus);
			moneyStatus.height = 25;
			moneyStatus.x = 150;
			moneyStatus.y = 575;
			
			betStatus = new Button(120, "Bet: " + bet.toString(), false);
			addChild(betStatus);
			betStatus.height = 25;
			betStatus.x = 300;
			betStatus.y = 575;
			
			var bet1:Button = new Button(buttonWidth, "Bet 1");
			bet1.name = String(1);
			bet1.addEventListener(MouseEvent.CLICK, addBet);
			bet1.addEventListener(MouseEvent.RIGHT_CLICK, removeBet);
			buttonsContainer.addChild(bet1);
			bet1.x = 40;
			bet1.y = 300;
			
			var bet5:Button = new Button(buttonWidth, "Bet 5");
			bet5.name = String(5);
			bet5.addEventListener(MouseEvent.CLICK, addBet);
			bet5.addEventListener(MouseEvent.RIGHT_CLICK, removeBet);
			buttonsContainer.addChild(bet5);
			bet5.x = 115;
			bet5.y = 300;
			
			var bet10:Button = new Button(buttonWidth, "Bet 10");
			bet10.name = String(10);
			bet10.addEventListener(MouseEvent.CLICK, addBet);
			bet10.addEventListener(MouseEvent.RIGHT_CLICK, removeBet);
			buttonsContainer.addChild(bet10);
			bet10.x = 190;
			bet10.y = 300;
			
			var bet25:Button = new Button(buttonWidth, "Bet 25");
			bet25.name = String(25);
			bet25.addEventListener(MouseEvent.CLICK, addBet);
			bet25.addEventListener(MouseEvent.RIGHT_CLICK, removeBet);
			buttonsContainer.addChild(bet25);
			bet25.x = 80;
			bet25.y = 350;
			
			var bet100:Button = new Button(buttonWidth, "Bet 100");
			bet100.name = String(100);
			bet100.addEventListener(MouseEvent.CLICK, addBet);
			bet100.addEventListener(MouseEvent.RIGHT_CLICK, removeBet);
			buttonsContainer.addChild(bet100);
			bet100.x = 150;
			bet100.y = 350;
			
			var bet250:Button = new Button(buttonWidth, "Bet 250");
			bet250.name = String(250);
			bet250.addEventListener(MouseEvent.CLICK, addBet);
			bet250.addEventListener(MouseEvent.RIGHT_CLICK, removeBet);
			buttonsContainer.addChild(bet250);
			bet250.x = 115;
			bet250.y = 400;
		
		}
		
		private function showBetButtons():void
		{
			addChild(buttonsContainer);
		}
		
		private function clearBetButtons():void
		{
			removeChild(buttonsContainer)
		}
		
		private function clearMainMenu():void
		{
			removeChild(menuContainer);
		}
		
		private function addBet(e:Event):void
		{
			var betString:String = e.currentTarget.name;
			var currentBet:int = int(betString);
			
			if (currentBet <= cash && !ingame)
			{
				bet += int(currentBet);
				cash -= int(currentBet);
				updateStatusBar();
			}
		}
		
		private function removeBet(e:Event):void
		{
			var betString:String = e.currentTarget.name;
			var currentBet:int = int(betString);
			
			if (currentBet <= bet)
			{
				bet -= int(currentBet);
				cash += int(currentBet);
				updateStatusBar();
			}
		}
			
		private function updateStatusBar():void
		{
			removeChild(moneyStatus);
			moneyStatus = new Button(120, "Credits: " + cash.toString(), false);
			addChild(moneyStatus);
			moneyStatus.height = 25;
			moneyStatus.x = 150;
			moneyStatus.y = 575;
			
			removeChild(betStatus);
			betStatus = new Button(120, "Bet: " + bet.toString(), false);
			addChild(betStatus);
			betStatus.height = 25;
			betStatus.x = 300;
			betStatus.y = 575;
		}
	}
}