package SharedClasses
{
	import flash.display.*;
	import flash.media.*
	import flash.events.*
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Jordan
	 */
	
	public class Music extends Sprite
	{
		private var sound:Sound = new Sound();
		private var channel:SoundChannel = new SoundChannel();
		private var myTransform:SoundTransform = new SoundTransform();
		private var lastPosition:Number = 0;
		
		private var iconUrl:URLRequest;
		private var buttonContainer:Sprite = new Sprite();
		private var musicRunning:Boolean = true;
		
		public function Music()
		{
			addChild(buttonContainer);
			sound.load(new URLRequest("Data/sound/soundtrack.mp3"));
			playSound();
		}
		
		private function playSound():void
		{
			channel = sound.play();
			channel.soundTransform = myTransform;
			channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
		}
		
		private function onComplete(e:Event):void
		{
			SoundChannel(e.target).removeEventListener(e.type, onComplete);
			playSound();
		}
		
		public function showButton():void
		{
			while (buttonContainer.numChildren > 0)
			{
				var object:Sprite = buttonContainer.getChildAt(0) as Sprite;
				object = null;
				
				buttonContainer.removeChildAt(0);
				buttonContainer.removeEventListener(MouseEvent.CLICK, onClickPause);
				buttonContainer.removeEventListener(MouseEvent.CLICK, onClickPlay);
			}
			
			if (musicRunning)
			{
				this.iconUrl = new URLRequest("Data/images/" + "music" + ".png")
			}
			else
			{
				this.iconUrl = new URLRequest("Data/images/" + "noMusic" + ".png")
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleate);
			loader.load(iconUrl);
			
			var icon:Bitmap;
			function loaderCompleate():void
			{
				var bmp:Bitmap = loader.content as Bitmap;
				icon = new Bitmap(bmp.bitmapData);
				icon.height = 40;
				icon.width = 40;
				
				if (musicRunning)
				{
					buttonContainer.addEventListener(MouseEvent.CLICK, onClickPause, false, 0, true);
				}
				else
				{
					buttonContainer.addEventListener(MouseEvent.CLICK, onClickPlay, false, 0, true);
				}
				
				buttonContainer.addChild(icon);
			}
		}
		
		public function onClickPause(e:MouseEvent):void
		{
			musicRunning = !musicRunning;
			showButton();
			
			lastPosition = channel.position;
			channel.stop();
		}
		
		public function onClickPlay(e:MouseEvent):void	
		{
			musicRunning = !musicRunning;
			showButton();
			
			channel = sound.play(lastPosition);
			channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
		}
	}
}