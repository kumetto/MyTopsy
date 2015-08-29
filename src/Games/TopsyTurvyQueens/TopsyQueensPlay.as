package Games.TopsyTurvyQueens
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import com.greensock.*;
	
	/**
	 * ...
	 * @author Desislava
	 */
	public class TopsyQueensPlay extends Sprite
	{
		private var isMoving:Boolean = true;
		private var container:Sprite = new Sprite();
		private var stockContainer:Sprite = new Sprite();
		private var talonContainer:Sprite = new Sprite();
		private var foundationContainer:Sprite = new Sprite();
		private var tableauContainer:Sprite = new Sprite();
		private var rectStock:Sprite = new Sprite();
		private var tempContainer:Sprite;
		private var tableauContainer1:Sprite = new Sprite();
		private var tableauContainer2:Sprite = new Sprite();
		private var tableauContainer3:Sprite = new Sprite();
		private var tableauContainer4:Sprite = new Sprite();
		private var tableauContainer5:Sprite = new Sprite();
		private var tableauContainer6:Sprite = new Sprite();
		private var tableauContainer7:Sprite = new Sprite();
		private var tableauContainer8:Sprite = new Sprite();
		private var leerRectTableau1:Rectangle = new Rectangle();
		private var leerRectTableau2:Rectangle = new Rectangle();
		private var leerRectTableau3:Rectangle = new Rectangle();
		private var leerRectTableau4:Rectangle = new Rectangle();
		private var leerRectTableau5:Rectangle = new Rectangle();
		private var leerRectTableau6:Rectangle = new Rectangle();
		private var leerRectTableau7:Rectangle = new Rectangle();
		private var leerRectTableau8:Rectangle = new Rectangle();
		private var leerPositionsArr:Array = new Array();
		private var eventCardTableau:Cards;
		private var currIndexTableau:int;
		private var tempArr:Array = new Array();
		private var eventArr:Array;
		private var checkCollisionArr:Array = new Array();
		private var numOfArr:int;
		private var eventsContainer:Sprite;
		private var countTalon:int = 0;
		private var numberCardsStock:int = 65;
		private var countTalonReset:int = 0;
		private var currFaceDownCardStock:Cards = new Cards(13, "Back");
		private var arrTalon:Array = new Array();
		private var currIndexRandom:int;
		private var arrFaceDownFoundation:Array = new Array();
		private var arrFaceUpFoundation:Array = new Array();
		private var currCardTalonDrag:Cards;
		private var rectKing8:Sprite = new Sprite();
		private var arrCardsDeck:Array = new Array();
		private const paddingCardsX:int = 20;
		private var paddingCardsY:int = 10;
		private var arrTableau1:Array = new Array();
		private var arrTableau2:Array = new Array();
		private var arrTableau3:Array = new Array();
		private var arrTableau4:Array = new Array();
		private var arrTableau5:Array = new Array();
		private var arrTableau6:Array = new Array();
		private var arrTableau7:Array = new Array();
		private var arrTableau8:Array = new Array();
		
		public function TopsyQueensPlay()
		{
			addChild(container);
			
			rectStock.graphics.beginFill(0x000000);
			rectStock.graphics.drawRect(42, 64, 72, 96);
			rectStock.graphics.endFill();
			container.addChild(rectStock);
			container.addChild(stockContainer);
			container.addChild(tableauContainer);
			container.addChild(foundationContainer);
			container.addChild(talonContainer);
			
			initCardsDeck();
			dealStock();
			dealFoundation();
			dealTableaus();
			tableauContainer.addChild(tableauContainer1);
			tableauContainer.addChild(tableauContainer2);
			tableauContainer.addChild(tableauContainer3);
			tableauContainer.addChild(tableauContainer4);
			tableauContainer.addChild(tableauContainer5);
			tableauContainer.addChild(tableauContainer6);
			tableauContainer.addChild(tableauContainer7);
			tableauContainer.addChild(tableauContainer8);
		
		}
		
		private function initCardsDeck():void
		{
			const arrSuits:Array = ["C", "H", "S", "D"];
			
			for (var i:int = 0; i < 13; i++)
			{
				for (var k:int = 0; k < 2; k++)
				{
					for (var j:int = 0; j < 4; j++)
					{
						var currCardFaceUp:Cards = new Cards(i, arrSuits[j]);
						arrCardsDeck.push(currCardFaceUp);
					}
				}
			}
		
		}
		
		private function dealStock():void
		{
			stockContainer.addChild(currFaceDownCardStock);
			currFaceDownCardStock.x = 42;
			currFaceDownCardStock.y = 64;
			currFaceDownCardStock.addEventListener(MouseEvent.CLICK, moveToTalonDeal, false, 0, true);
		}
		
		private function moveToTalonDeal(evt:MouseEvent):void
		{
			if (countTalon >= 65)
			{
				while (stockContainer.numChildren > 0)
				{
					stockContainer.removeChildAt(0);
					
				}
				rectStock.addEventListener(MouseEvent.CLICK, clickStock);
				countTalon = 0;
				
			}
			else
			{
				currIndexRandom = getRandomNumber();
				var currCardTalon:Cards = arrCardsDeck[currIndexRandom];
				var currFreeIndex:int = arrFaceUpFoundation.length;
				
				if ((currFreeIndex < 8) && (currCardTalon.cardValue == 0))
				{
					if (currFreeIndex == 7)
					{
						foundationContainer.addChild(currCardTalon);
						currCardTalon.x = 44 + currCardTalon.cardWidth * 7 + 120;
						currCardTalon.y = 54 + currCardTalon.cardHeight + paddingCardsY;
						arrFaceUpFoundation.push(currCardTalon);
						arrCardsDeck.splice(currIndexRandom, 1);
						
					}
					else
					{
						countTalon++;
						
						foundationContainer.addChild(currCardTalon);
						currCardTalon.x = arrFaceDownFoundation[currFreeIndex].x
						currCardTalon.y = arrFaceDownFoundation[currFreeIndex].y;
						arrFaceUpFoundation.push(currCardTalon);
						arrCardsDeck.splice(currIndexRandom, 1);
						
					}
				}
				else
				{
					countTalon++;
					
					talonContainer.addChild(currCardTalon);
					arrTalon.push(currCardTalon);
					currCardTalon.x = 42 + paddingCardsX + currCardTalon.width;
					currCardTalon.y = 64;
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTalon.addEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
					currCardTalon.addEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				}
			}
		
		}
		
		private function getRandomNumber():int
		{
			var randomNum:int = Math.floor(Math.random() * ((arrCardsDeck.length - 1) - 0 + 1) + 0);
			return randomNum;
		}
		
		private function clickDownTalonCard(evt:MouseEvent):void
		{
			evt.currentTarget.startDrag();
			currCardTalonDrag = evt.currentTarget as Cards;
		}
		
		private function clickUpTalonCard(evt:MouseEvent):void
		{
			evt.currentTarget.stopDrag();
			checkCollisionTalon();
		}
		
		private function checkCollisionTalon():void
		{
			var currIndex:int = arrTalon.indexOf(currCardTalonDrag);
			if ((arrTableau1[arrTableau1.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau1[arrTableau1.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau1[arrTableau1.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau1[arrTableau1.length - 1].x;
				currCardTalonDrag.y = arrTableau1[arrTableau1.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer1.addChild(currCardTalonDrag);
				arrTableau1.push(currCardTalonDrag);
				
			}
			
			else if ((arrTableau2[arrTableau2.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau2[arrTableau2.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau2[arrTableau2.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau2[arrTableau2.length - 1].x;
				currCardTalonDrag.y = arrTableau2[arrTableau2.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer2.addChild(currCardTalonDrag);
				arrTableau2.push(currCardTalonDrag);
				
			}
			else if ((arrTableau3[arrTableau3.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau3[arrTableau3.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau3[arrTableau3.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
				
				arrTalon.splice(currIndex, 1);
				
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau3[arrTableau3.length - 1].x;
				currCardTalonDrag.y = arrTableau3[arrTableau3.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer3.addChild(currCardTalonDrag);
				arrTableau3.push(currCardTalonDrag);
				
			}
			else if ((arrTableau4[arrTableau4.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau4[arrTableau4.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau4[arrTableau4.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
				
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau4[arrTableau4.length - 1].x;
				currCardTalonDrag.y = arrTableau4[arrTableau4.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer4.addChild(currCardTalonDrag);
				arrTableau4.push(currCardTalonDrag);
				
			}
			else if ((arrTableau5[arrTableau5.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau5[arrTableau5.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau5[arrTableau5.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
			
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau5[arrTableau5.length - 1].x;
				currCardTalonDrag.y = arrTableau5[arrTableau5.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer5.addChild(currCardTalonDrag);
				arrTableau5.push(currCardTalonDrag);
				
			}
			else if ((arrTableau6[arrTableau6.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau6[arrTableau6.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau6[arrTableau6.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
				
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau6[arrTableau6.length - 1].x;
				currCardTalonDrag.y = arrTableau6[arrTableau6.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer6.addChild(currCardTalonDrag);
				arrTableau6.push(currCardTalonDrag);
				
			}
			else if ((arrTableau7[arrTableau7.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau7[arrTableau7.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau7[arrTableau7.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
				
				arrTalon.splice(currIndex, 1);
				
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau7[arrTableau7.length - 1].x;
				currCardTalonDrag.y = arrTableau7[arrTableau7.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer7.addChild(currCardTalonDrag);
				arrTableau7.push(currCardTalonDrag);
				
			}
			else if ((arrTableau8[arrTableau8.length - 1].hitTestPoint(mouseX, mouseY)) && (arrTableau8[arrTableau8.length - 1].cardValue == currCardTalonDrag.cardValue + 1) && (arrTableau8[arrTableau8.length - 1].cardSuit == currCardTalonDrag.cardSuit))
			{
				
				arrTalon.splice(currIndex, 1);
				
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
				currCardTalonDrag.x = arrTableau8[arrTableau8.length - 1].x;
				currCardTalonDrag.y = arrTableau8[arrTableau8.length - 1].y + 20;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				tableauContainer8.addChild(currCardTalonDrag);
				arrTableau8.push(currCardTalonDrag);
				
			}
			
			else if ((arrFaceUpFoundation.length > 0) && (arrFaceUpFoundation[0].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[0].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[0].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[0].x;
				currCardTalonDrag.y = arrFaceUpFoundation[0].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[0] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			
			else if ((arrFaceUpFoundation.length > 1) && (arrFaceUpFoundation[1].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[1].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[1].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[1].x;
				currCardTalonDrag.y = arrFaceUpFoundation[1].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[1] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			
			else if ((arrFaceUpFoundation.length > 2) && (arrFaceUpFoundation[2].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[2].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[2].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[2].x;
				currCardTalonDrag.y = arrFaceUpFoundation[2].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[2] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			else if ((arrFaceUpFoundation.length > 3) && (arrFaceUpFoundation[3].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[3].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[3].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[3].x;
				currCardTalonDrag.y = arrFaceUpFoundation[3].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[3] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			else if ((arrFaceUpFoundation.length > 4) && (arrFaceUpFoundation[4].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[4].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[4].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[4].x;
				currCardTalonDrag.y = arrFaceUpFoundation[4].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[4] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			else if ((arrFaceUpFoundation.length > 5) && (arrFaceUpFoundation[5].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[5].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[5].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[5].x;
				currCardTalonDrag.y = arrFaceUpFoundation[5].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[5] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			else if ((arrFaceUpFoundation.length > 6) && (arrFaceUpFoundation[6].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[6].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[6].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[6].x;
				currCardTalonDrag.y = arrFaceUpFoundation[6].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[6] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			else if ((arrFaceUpFoundation.length > 7) && (arrFaceUpFoundation[7].hitTestPoint(mouseX, mouseY)) && (arrFaceUpFoundation[7].cardValue == currCardTalonDrag.cardValue - 1) && (arrFaceUpFoundation[7].cardSuit == currCardTalonDrag.cardSuit))
			{
				currCardTalonDrag.x = arrFaceUpFoundation[7].x;
				currCardTalonDrag.y = arrFaceUpFoundation[7].y;
				currCardTalonDrag.parent.removeChild(currCardTalonDrag);
				foundationContainer.addChild(currCardTalonDrag);
				arrFaceUpFoundation[7] = currCardTalonDrag;
				arrTalon.splice(currIndex, 1);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_DOWN, clickDownTalonCard);
				currCardTalonDrag.removeEventListener(MouseEvent.MOUSE_UP, clickUpTalonCard);
			}
			else
			{
				
				TweenMax.to(currCardTalonDrag, 0.15, {x: 42 + paddingCardsX + currCardTalonDrag.cardWidth, y: 64});
				
			}
		}
		
		private function clickStock(evt:MouseEvent):void
		{
			while (talonContainer.numChildren > 0)
			{
				talonContainer.removeChildAt(0);
			}
			
			stockContainer.addChild(currFaceDownCardStock);
			currFaceDownCardStock.removeEventListener(MouseEvent.CLICK, moveToTalonDeal);
			currFaceDownCardStock.addEventListener(MouseEvent.CLICK, moveToTalon, false, 0, true);
		
		}
		
		private function moveToTalon(evt:MouseEvent):void
		{
			if (countTalonReset >= arrTalon.length)
			{
				countTalonReset = 0;
				while (stockContainer.numChildren > 0)
				{
					stockContainer.removeChildAt(0);
					
				}
				rectStock.addEventListener(MouseEvent.CLICK, clickStock);
			}
			talonContainer.addChild(arrTalon[countTalonReset]);
			countTalonReset++;
		
		}
		
		private function dealFoundation():void
		{
			
			var padding:int = 0;
			paddingCardsY += 10;
			for (var i:int = 0; i < 7; i++)
			{
				var currFaceDownCardFoundation:Cards = new Cards(13, "Back");
				currFaceDownCardFoundation.x = 42 + currFaceDownCardFoundation.cardWidth * i + padding;
				padding += paddingCardsX;
				currFaceDownCardFoundation.y = 54 + currFaceDownCardFoundation.cardHeight + paddingCardsY;
				foundationContainer.addChild(currFaceDownCardFoundation);
				arrFaceDownFoundation.push(currFaceDownCardFoundation);
			}
		}
		
		private function dealTableaus():void
		{
			
			var count:int = 0;
			var paddingX:int = 0;
			paddingCardsY += 10;
			
			tableauContainer1.addChild(leerRectTableau1);
			leerRectTableau1.x = 42;
			leerRectTableau1.y = 54 + 2 * leerRectTableau1.height + paddingCardsY;
			
			for (var i:int = 0; i < 4; i++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau1:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer1.addChild(currCardTableau1);
					currCardTableau1.whichArr = 0;
					currCardTableau1.x = 42 + paddingX + (currCardTableau1.width * count);
					currCardTableau1.y = 52 + 2 * currCardTableau1.cardHeight + paddingCardsY + i * paddingCardsX;
					arrTableau1.push(currCardTableau1);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau1.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
				}
				
			}
			
			checkCollisionArr.push(arrTableau1[arrTableau1.length - 1]);
			count++;
			paddingX += paddingCardsX;
			tableauContainer2.addChild(leerRectTableau2);
			leerRectTableau2.x = 41 + leerRectTableau2.width + paddingX;
			leerRectTableau2.y = 52 + 2 * leerRectTableau2.height + paddingCardsY;
			
			for (var j:int = 0; j < 4; j++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau2:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer2.addChild(currCardTableau2);
					currCardTableau2.whichArr = 1;
					currCardTableau2.x = 42 + paddingX + (currCardTableau2.cardWidth * count);
					currCardTableau2.y = 54 + 2 * currCardTableau2.cardHeight + paddingCardsY + j * paddingCardsX;
					arrTableau2.push(currCardTableau2);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau2.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
				}
				
			}
			
			checkCollisionArr.push(arrTableau2[arrTableau2.length - 1]);
			count++;
			paddingX += paddingCardsX;
			tableauContainer3.addChild(leerRectTableau3);
			leerRectTableau3.x = 40 + leerRectTableau3.width * 2 + paddingX;
			leerRectTableau3.y = 52 + 2 * leerRectTableau3.height + paddingCardsY;
			for (var k:int = 0; k < 4; k++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau3:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer3.addChild(currCardTableau3);
					currCardTableau3.whichArr = 2;
					currCardTableau3.x = 42 + paddingX + (currCardTableau3.cardWidth * count);
					currCardTableau3.y = 54 + 2 * currCardTableau2.cardHeight + paddingCardsY + k * paddingCardsX;
					arrTableau3.push(currCardTableau3);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau3.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau3.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
				}
				
			}
			
			checkCollisionArr.push(arrTableau3[arrTableau3.length - 1]);
			count++;
			paddingX += paddingCardsX;
			tableauContainer4.addChild(leerRectTableau4);
			leerRectTableau4.x = 39 + leerRectTableau4.width * 3 + paddingX;
			leerRectTableau4.y = 52 + 2 * leerRectTableau4.height + paddingCardsY;
			for (var l:int = 0; l < 4; l++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau4:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer4.addChild(currCardTableau4);
					currCardTableau4.whichArr = 3;
					currCardTableau4.x = 42 + paddingX + (currCardTableau4.cardWidth * count);
					currCardTableau4.y = 54 + 2 * currCardTableau4.cardHeight + paddingCardsY + l * paddingCardsX;
					arrTableau4.push(currCardTableau4);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau4.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau4.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
				}
				
			}
			
			checkCollisionArr.push(arrTableau4[arrTableau4.length - 1]);
			count++;
			paddingX += paddingCardsX;
			tableauContainer5.addChild(leerRectTableau5);
			leerRectTableau5.x = 38 + leerRectTableau5.width * 4 + paddingX;
			leerRectTableau5.y = 52 + 2 * leerRectTableau5.height + paddingCardsY;
			for (var m:int = 0; m < 4; m++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau5:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer5.addChild(currCardTableau5);
					currCardTableau5.whichArr = 4;
					currCardTableau5.x = 42 + paddingX + (currCardTableau5.cardWidth * count);
					currCardTableau5.y = 54 + 2 * currCardTableau4.cardHeight + paddingCardsY + m * paddingCardsX;
					arrTableau5.push(currCardTableau5);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau5.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau5.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
				}
				
			}
			
			checkCollisionArr.push(arrTableau5[arrTableau5.length - 1]);
			count++;
			paddingX += paddingCardsX;
			tableauContainer6.addChild(leerRectTableau6);
			leerRectTableau6.x = 37 + leerRectTableau6.width * 5 + paddingX;
			leerRectTableau6.y = 52 + 2 * leerRectTableau6.height + paddingCardsY;
			for (var n:int = 0; n < 4; n++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau6:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer6.addChild(currCardTableau6);
					currCardTableau6.whichArr = 5;
					currCardTableau6.x = 42 + paddingX + (currCardTableau5.cardWidth * count);
					currCardTableau6.y = 54 + 2 * currCardTableau4.cardHeight + paddingCardsY + n * paddingCardsX;
					arrTableau6.push(currCardTableau6);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau6.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau6.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
				}
				
			}
			
			checkCollisionArr.push(arrTableau6[arrTableau6.length - 1]);
			count++;
			paddingX += paddingCardsX;
			tableauContainer7.addChild(leerRectTableau7);
			leerRectTableau7.x = 36 + leerRectTableau7.width * 6 + paddingX;
			leerRectTableau7.y = 52 + 2 * leerRectTableau7.height + paddingCardsY;
			for (var o:int = 0; o < 4; o++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau7:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer7.addChild(currCardTableau7);
					currCardTableau7.whichArr = 6;
					currCardTableau7.x = 42 + paddingX + (currCardTableau5.cardWidth * count);
					currCardTableau7.y = 54 + 2 * currCardTableau4.cardHeight + paddingCardsY + o * paddingCardsX;
					arrTableau7.push(currCardTableau7);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau7.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau7.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
				}
				
			}
			
			;
			checkCollisionArr.push(arrTableau7[arrTableau7.length - 1]);
			count++;
			paddingX += paddingCardsX;
			tableauContainer8.addChild(leerRectTableau8);
			leerRectTableau8.x = 35 + leerRectTableau7.width * 7 + paddingX;
			leerRectTableau8.y = 52 + 2 * leerRectTableau8.height + paddingCardsY;
			for (var p:int = 0; p < 4; p++)
			{
				currIndexRandom = getRandomNumber();
				if ((currIndexRandom < arrCardsDeck.length) && (currIndexRandom > -1))
				{
					var currCardTableau8:Cards = arrCardsDeck[currIndexRandom];
					tableauContainer8.addChild(currCardTableau8);
					currCardTableau8.whichArr = 7;
					currCardTableau8.x = 42 + paddingX + (currCardTableau5.cardWidth * count);
					currCardTableau8.y = 54 + 2 * currCardTableau4.cardHeight + paddingCardsY + p * paddingCardsX;
					arrTableau8.push(currCardTableau8);
					arrCardsDeck.splice(currIndexRandom, 1);
					currCardTableau8.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTableau, false, 0, true);
					currCardTableau8.addEventListener(MouseEvent.MOUSE_UP, mouseUpTableau, false, 0, true);
					
				}
				
			}
			
			checkCollisionArr.push(arrTableau8[arrTableau8.length - 1]);
		
		}
		
		private function mouseDownTableau(evt:MouseEvent):void
		{
			isMoving = true;
			tempContainer = new Sprite();
			container.addChild(tempContainer);
			tempContainer.mouseEnabled = false;
			eventCardTableau = evt.currentTarget as Cards;
			numOfArr = eventCardTableau.whichArr;
			eventArr = getArr(numOfArr);
			eventsContainer = getContainer(numOfArr);
		
			if (eventArr != null)
			{
				currIndexTableau = eventArr.indexOf(eventCardTableau);
				for (var i:int = currIndexTableau; i < eventArr.length; i++)
				{
					tempArr.push(eventArr[i]);
					tempContainer.addChild(eventArr[i]);
					
				}
			tempContainer.startDrag();
				
			}
		
		}
		
		private function mouseUpTableau(evt:MouseEvent):void
		{
			tempContainer.stopDrag();
			checkCollisionTableau();
		
		}
		
		private function checkCollisionTableau():void
		{
			if (leerPositionsArr.length>0)
			{
				
				for (var b:int = 0; b < leerPositionsArr.length; b++)
				{
					var currCardsTableauRect:Rectangle = getLeerRect(leerPositionsArr[b]);
					var currArray:Array = getArr(leerPositionsArr[b]);
					var currContainer:Sprite = getContainer(leerPositionsArr[b]);
					if (currCardsTableauRect.hitTestPoint(mouseX, mouseY))
					{
						for (var j:int = 0; j < tempArr.length; j++)
						{
							currContainer.addChild(tempContainer.getChildAt(0));
						}
						for (j = 0; j < tempArr.length; j++)
						{
							tempArr[i].x = currCardsTableauRect.x;
							tempArr[i].y = currCardsTableauRect.y + i * 20;
							tempArr[i].whichArr = leerPositionsArr[b];
							currArray.push(tempArr[i]);
						}
						checkCollisionArr[leerPositionsArr[b]] = tempArr[tempArr.length - 1];
						tempArr.splice(0, tempArr.length - 1);
						tempContainer.parent.removeChild(tempContainer);
						tempContainer = null;
						
					}
				}
			}
			else
			{
				for (var i:int = 0; i < checkCollisionArr.length; i++)
				{
					if (numOfArr == i)
					{
						continue;
					}
					
					else
					{
						var currCollisionArrTableau:Array = getArr(i);
						var currCollisionContainerTableau:Sprite = getContainer(i);
						if ((currCollisionArrTableau != null) && (currCollisionContainerTableau != null))
						{
							if ((checkCollisionArr[i] != undefined) &&
							(checkCollisionArr[i].hitTestPoint(mouseX, mouseY)) 
							&& (checkCollisionArr[i].cardValue == tempArr[0].cardValue + 1)
							&& (checkCollisionArr[i].cardSuit == tempArr[0].cardSuit))
							{
								isMoving = false;
								for (var n:int = 0; n < tempArr.length; n++)
								{
									currCollisionContainerTableau.addChild(tempContainer.getChildAt(0));
								}
								tempContainer.parent.removeChild(tempContainer);
								tempContainer = null;
								for (var k:int = 0; k < tempArr.length; k++)
								{
									tempArr[k].x = currCollisionArrTableau[0].x;
									tempArr[k].y = currCollisionArrTableau[currCollisionArrTableau.length - 1].y + 20;
									tempArr[k].whichArr = i;
									
									currCollisionArrTableau.push(tempArr[k]);
								}
								tempArr.splice(0, tempArr.length);
								var spliceElemEvArr:int = eventArr.length - currIndexTableau;
								eventArr.splice(currIndexTableau, spliceElemEvArr);
								checkCollisionArr[i] = currCollisionArrTableau[currCollisionArrTableau.length - 1];
								if (eventArr.length > 0)
								{
									checkCollisionArr[numOfArr] = eventArr[eventArr.length - 1];
								}
								else
								{
									var leerPos:int = numOfArr;
									leerPositionsArr.push(leerPositionsArr);
									delete(checkCollisionArr[numOfArr]);
								}
								
								return;
							}
							else
							{
								TweenMax.to(tempContainer, 0.3, {x: 0, y: 0, onComplete: removeTempContainer});
								
							}
						}
						
					}
					
				}
			}
		}
		
		private function removeTempContainer():void
		{
			if (isMoving)
			{
				while (tempContainer.numChildren > 0)
				{
					eventsContainer.addChild(tempContainer.getChildAt(0));
				}
				tempContainer.parent.removeChild(tempContainer);
				tempContainer = null;
			}
		}
		
		private function getArr(index:int):Array
		{
			
			switch (index)
			{
			case 0: 
				return arrTableau1; break;
				break;
			case 1: 
				return arrTableau2;break;
				break;
			case 2: 
				return arrTableau3;break;
				break;
			case 3: 
				return arrTableau4;break;
				break;
			case 4: 
				return arrTableau5;break;
				break;
			case 5: 
				return arrTableau6;break;
				break;
			case 6: 
				return arrTableau7;break;
				break;
			case 7: 
				return arrTableau8;break;
				break;
			}
			return null;
		
		}
		
		private function getLeerRect(index:int):Rectangle
		{
			
			switch (index)
			{
			case 0: 
				return leerRectTableau1;break;
				break;
			case 1: 
				return leerRectTableau2;break;
				break;
			case 2: 
				return leerRectTableau3;break;
				break;
			case 3: 
				return leerRectTableau4;break;
				break;
			case 4: 
				return leerRectTableau5;break;
				break;
			case 5: 
				return leerRectTableau6;break;
				break;
			case 6: 
				return leerRectTableau7;break;
				break;
			case 7: 
				return leerRectTableau8;break;
				break;
			}
			return null;
		
		}
		
		private function getContainer(index:int):Sprite
		{
			
			switch (index)
			{
			case 0: 
				return tableauContainer1;break;
				break;
			case 1: 
				return tableauContainer2;break;
				break;
			case 2: 
				return tableauContainer3;break;
				break;
			case 3: 
				return tableauContainer4;break;
				break;
			case 4: 
				return tableauContainer5;break;
				break;
			case 5: 
				return tableauContainer6;break;
				break;
			case 6: 
				return tableauContainer7;break;
				break;
			case 7: 
				return tableauContainer8;break;
				break;
			}
			return null;
		
		}
	
	}

}