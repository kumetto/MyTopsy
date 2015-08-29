package Games.GrandFather
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;
	import SharedClasses.Card;
	
	/**
	 * ...
	 * @author Mitko
	 */
	public class SidePile extends Sprite
	{
		private var sidePileCards:Array = [];
		private var startValue:int;
		private var sign:String;
		private var topCard:Card = null;
		
		private const CARD_WIDTH:int = 65;
		private const CARD_HEIGHT:int = 100;
		
		public function SidePile(startValuePar:int, signPar:String)
		{
			this.startValue = startValuePar;
			this.sign = signPar;
			drawBorder();
			drawSign();
		}
		
		private function drawSign():void
		{
			var signContainer:Sprite = new Sprite();
			var path:String = "Data/images/Suit/" + this.sign + ".png";
			fillContainerWithImg(signContainer, path, 20, 20);
			this.addChild(signContainer);
			signContainer.x = 23;//in the middle
			signContainer.y = 35;
		}
		
		private function drawBorder():void
		{
			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0x0);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(CARD_WIDTH, 0);
			line.graphics.lineTo(CARD_WIDTH, CARD_HEIGHT);
			line.graphics.lineTo(0, CARD_HEIGHT);
			line.graphics.lineTo(0, 0);
			this.addChild(line);
		}
		
		public function pushCard(card:Card):void
		{
			if(card!=null){
				this.addChild(card);
				card.x = 0;
				card.y = 0;
				this.sidePileCards.push(card);
				this.topCard = card;
			}
		}
		
		private function fillContainerWithImg(container:Sprite, path:String, imgWidth:int, imgHeight:int):void
		{
			var img:Loader = new Loader();
			img.load(new URLRequest(path));
			img.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
			{
				onLoaderComplete(container, img, imgWidth, imgHeight)
			});
		}
		
		private function onLoaderComplete(container:Sprite, img:Loader, imgWidth:int, imgHeight:int):void
		{
			var bmp:Bitmap = new Bitmap();
			bmp = img.content as Bitmap;
			bmp.width = imgWidth;
			bmp.height = imgHeight;
			container.addChildAt(bmp, 0);
		}
		
		public function get TopCard():Card
		{
			return this.topCard;
		}
		
		public function get Cards():Array
		{
			
			return this.sidePileCards;
		}
		
		public function get StartValue():int
		{
			
			return this.startValue;
		}
		
		public function get Sign():String
		{
			
			return this.sign;
		}
		
		public function get CardsCount():int
		{
			
			return this.sidePileCards.length;
		}
	
	}

}