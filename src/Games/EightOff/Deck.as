package Games.EightOff

{
	
	/**
	 * ...
	 * @author Kolarov
	 */
	import SharedClasses.Card
	
	public class Deck
	{
		private var deck:Array = [];
		private var cardSkin:String;
		
		public function Deck(cardSkinPar:String)
		{
			this.cardSkin = cardSkinPar;
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
						
					//	this.deck.push(card);
						
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
	}
}