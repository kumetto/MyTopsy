package Games.EightOff
{
	import SharedClasses.Assistant;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Kolarov
	 */
	public class Interaction
	{
		private var extraPiles:Array;
		private var fieldPiles:Array;
		private var sidePiles:Array;
		
		private var dragCardFromExtraPile:Function;
		private var dragCardsFromFieldPile:Function;
		
		//private var 
		//private var 
		
		public function Interaction(extraPilesPar:Array, fieldPilesPar:Array, sidePilesPar:Array, dragCardFromExtraPilePar:Function, dragCardsFromFieldPilePar:Function)
		{
			this.extraPiles = extraPilesPar;
			this.fieldPiles = fieldPilesPar;
			this.sidePiles = sidePilesPar;
			this.dragCardFromExtraPile = dragCardFromExtraPilePar;
			this.dragCardsFromFieldPile = dragCardsFromFieldPilePar;
		}
		
		public function makeExtraPilesInteractive():void
		{
			for (var extraPileIndex:int = 0; extraPileIndex < this.extraPiles.length; extraPileIndex++)
			{
				var extraPile:ExtraPile = this.extraPiles[extraPileIndex];
				Assistant.addEventListenerTo(extraPile, MouseEvent.MOUSE_DOWN, this.dragCardFromExtraPile);
			}
		}
		
		public function makeFieldPilesInteractive():void
		{
			for (var fieldPileIndex:int = 0; fieldPileIndex < this.fieldPiles.length; fieldPileIndex++)
			{
				var fieldPile:FieldPile = this.fieldPiles[fieldPileIndex];
				Assistant.addEventListenerTo(fieldPile, MouseEvent.MOUSE_DOWN, this.dragCardsFromFieldPile);
			}
		}
	}

}