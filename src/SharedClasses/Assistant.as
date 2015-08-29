package SharedClasses
{
	import flash.events.*
	import flash.display.*;
	import flash.net.URLRequest;
	import Games.GrandFather.*
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class Assistant
	{
		
		public function Assistant()
		{
		
		}
		
		public static function dealing(deck:Deck, fieldPiles:Array):void
		{
			for (var pileIndex:int = 0; pileIndex < fieldPiles.length; pileIndex++)
			{
				var currentPile:FieldPile = fieldPiles[pileIndex];
				var dealtCard:Card = deck.giveTopCard();
				currentPile.pushCard(dealtCard);
			}
		}
		
		public static function addEventListenerTo(obj:Object, eventConst:String, functionToTrigger:Function):void
		{
			obj.addEventListener(eventConst, functionToTrigger);
		}
		
		public static function removeEventListenerTo(obj:Object, eventConst:String, functionToTrigger:Function):void
		{
			obj.removeEventListener(eventConst, functionToTrigger);
		}
		
		public static function isThereWin(sidePiles:Array):Boolean
		{
			var filledSidePiles:int = 0;
			for (var sidePileIndex:int = 0; sidePileIndex < sidePiles.length; sidePileIndex++)
			{
				var currentSidePile:SidePile = sidePiles[sidePileIndex];
				if (currentSidePile.CardsCount == 13)
				{
					filledSidePiles++;
				}
			}
			if (filledSidePiles != 8)
			{
				return false
			}
			else
			{
				return true;
			}
		}
		
		public static function fillContainerWithImg(container:Sprite, path:String, imgWidth:int, imgHeight:int):void
		{
			var img:Loader = new Loader();
			img.load(new URLRequest(path));
			img.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
			{
				onLoaderComplete(container, img, imgWidth, imgHeight)
			});
		}
		
		private static function onLoaderComplete(container:Sprite, img:Loader, imgWidth:int, imgHeight:int):void
		{
			var bmp:Bitmap = new Bitmap();
			bmp = img.content as Bitmap;
			bmp.width = imgWidth;
			bmp.height = imgHeight;
			container.addChildAt(bmp, 0);
			bmp.x = 0;
			bmp.y = 0;
		}
	}

}