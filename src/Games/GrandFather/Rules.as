package Games.GrandFather
{
	import flash.display.*;
	import flash.text.*;
	import SharedClasses.Assistant;
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class Rules extends Sprite
	{
		private var rules:String;
		
		private var backgroundPath:String = "Data/images/RulesBackgrounds/rulesbg0.png";
		
		public function Rules(rulesPar:String)
		{
			this.rules = rulesPar;
			Assistant.fillContainerWithImg(this as Sprite, backgroundPath, 800, 515);
			writeRules();
		
		}
		
		private function writeRules():void
		{
			
			var rulesTxtField:TextField = new TextField();
			rulesTxtField.defaultTextFormat = new TextFormat('Comic Sans MS', 15, 0x000000, 'bold');
			rulesTxtField.text = rules;
			addChild(rulesTxtField);
			rulesTxtField.height = 400;
			rulesTxtField.width = 580;
			rulesTxtField.x = 105;
			rulesTxtField.y = 80;
			rulesTxtField.selectable = false;
			rulesTxtField.wordWrap = true;
		}
	}

}