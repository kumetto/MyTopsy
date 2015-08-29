package SharedClasses
{
	import flash.events.*;
	import flash.display.*;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Jordan
	 */

	public class MenuButton extends Sprite
	{
		
		public function MenuButton(fileName:String)
		{
			loadButton(fileName);
		}
		
		private function loadButton(fileName:String):void
		{
			var buttonUrl:URLRequest = new URLRequest("Data/images/Buttons/" + fileName);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleate);
			loader.load(buttonUrl);
			var button:Bitmap;
			function loaderCompleate():void
			{
				var bmp:Bitmap = loader.content as Bitmap;
				button = new Bitmap(bmp.bitmapData);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleate);
				addChild(button);
			}
		}
	}
}