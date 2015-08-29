package Games.TopsyTurvyQueens
{
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.media.*;
	import flash.events.*;
	import flash.display.Graphics;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Desislava
	 */
	public class Cards extends Sprite
	{
		private var _whichArr:int;
		private var _cardSuit:String;
		private var _cardWidth:int;
		private var _cardHeight:int;
		private var ldr:Loader;
		private var _cardUrl:URLRequest;
		private var _cardValue:int;
		private var cardsEffectSoundChannel:SoundChannel = new SoundChannel();
		private var cardsEffectSound:Sound = new Sound();
		
		public function Cards(cardValue:int, cardSuit:String, cardWidth:int = 72, cardHeight:int = 96)
		{
			_cardUrl = new URLRequest("Cards/" + String(cardValue) + cardSuit + ".png");
			_cardSuit = cardSuit;
			_cardValue = cardValue;
			_cardWidth = cardWidth;
			_cardHeight = cardHeight;
			loadCard();
		
		}
		
		private function loadCard():void
		{
			ldr = new Loader();
			ldr.load(_cardUrl);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleate);
		
		}
		
		private function loaderCompleate(evt:Event):void
		{
			
			var bmpData:BitmapData = new BitmapData(ldr.width, ldr.height, false);
			bmpData.draw(ldr);
			var bCard:Bitmap = new Bitmap(bmpData);
			addChild(bCard);
			
			addEventListener(MouseEvent.MOUSE_OVER, addGlow, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, removeGlow, false, 0, true);
			addEventListener(MouseEvent.CLICK, cardEffect, false, 0, true);
			cardsEffectSound.load(new URLRequest("Data/sound/cardClickEffect.mp3"));
		}
		
		public function get cardValue():int
		{
			return _cardValue;
		}
		
		public function get cardSuit():String
		{
			return _cardSuit;
		}
		
		public function get cardWidth():int
		{
			return _cardWidth;
		}
		
		public function get cardHeight():int
		{
			return _cardHeight;
		}
		public function get whichArr():int
		{
			return _whichArr;
		}
		public function set whichArr(value:int):void
		{
			_whichArr=value;
		}
		private function addGlow(e:MouseEvent):void
		{
			TweenMax.to(e.currentTarget, 1, {glowFilter: {color: 0xFFFFFF, alpha: 1, blurX: 30, blurY: 30}});
		}
		
		private function removeGlow(e:MouseEvent):void
		{
			TweenMax.to(e.currentTarget, 1, {glowFilter: {alpha: 0}});
		}
		
		private function cardEffect(e:MouseEvent):void
		{
		  cardsEffectSoundChannel = cardsEffectSound.play();
		}
	}
}