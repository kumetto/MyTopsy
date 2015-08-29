package Games.GrandFather
{
	import flash.display.Sprite;
	import SharedClasses.Assistant;
	import SharedClasses.Card;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * ...
	 * @author
	 */
	public class Deck extends Sprite
	{
		private var deck:Array = [];
		private var cardsCount:int;
		private var reloadTimesLeft:int = 1;
		
		private var cardSkin:String;
		
		public function Deck(cardSkinPar:String)
		{
			this.cardSkin = cardSkinPar;
			Assistant.fillContainerWithImg(this, "Data/images/Cards/" + this.cardSkin + "0Back.png", 65, 100);
			loadDeck();
			loadDeck();
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
						
						//this.deck.push(card);
						
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
					
					var card:Card = new Card(cardUrl, i, this.cardSkin);
					this.deck.push(card);
				}
			}
		}
		
		public function RandomNumber():int
		{
			return (Math.floor(Math.random() * ((this.deck.length - 1) - 0 + 1)) + 0);
		}
		
		public function giveTopCard():Card
		{
			var topCard:Card;
			var randomNumber:int = RandomNumber();
			topCard = this.deck[randomNumber];
			this.deck.splice(randomNumber, 1);
			return topCard;
		}
		
		public function ReloadDeck(deckPileCards:Array):void
		{
			var deckPileTopCard:Card;
			while (deckPileCards.length > 0)
			{
				deckPileTopCard = deckPileCards.pop();
				this.deck.push(deckPileTopCard);
			}
			this.reloadTimesLeft--;
		}
		
		public function get CardsCount():int
		{
			return this.deck.length;
		}
		
		public function get ReloadedTimesLeft():int
		{
			return this.reloadTimesLeft;
		}
	}

}