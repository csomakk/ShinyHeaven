package org.shinyheaven.datavisualization.charting.calculators
{
	import flash.geom.Point;
	
	import org.flexunit.asserts.assertTrue;
	import org.shinyheaven.service.dto.IHistoricalDataItem;
	import org.shinyheaven.service.dto.OHLCUpdate;
	
	public class DataToCoordinatesTest
	{	
		
		private var data:Array;
		private var width:Number;
		private var height:Number;
		private var minVal:Number;
		private var maxVal:Number;
		
		private var correctHeightsWidths:Array = [
			1, 
			20.432,
			100,
			1000.3242,
			12674.323413212
		];
		
		private var incorrectHeightsWidths:Array = [
			0,
			0.25,
			0.8,
			-10
		];
		
		[Before]
		public function setUp():void
		{
			data = genData();
			minVal = getLowestValue(data);
			maxVal = getHighestValue(data);
			width = 1000;
			height = 500;
			
		}
		
		private function getLowestValue(data:Array):Number
		{
			var min:Number = Number.MAX_VALUE;
			
			for each (var item:IHistoricalDataItem in data) 
			{
				min = Math.min(min, item.value);
			}

			return min;
		}
		
		private function getHighestValue(data:Array):Number
		{
			var max:Number = Number.MIN_VALUE;
			
			for each (var item:IHistoricalDataItem in data) 
			{
				max = Math.max(max, item.value);
			}
			
			return max;
		}
		
		private function genData():Array
		{
			var data:Array = [];
			for (var i:int = 0; i < 1001; i++) 
			{
				var dataItem:OHLCUpdate = new OHLCUpdate();
				dataItem.open = 13 + i;
				dataItem.high = 13 + i;
				dataItem.low = 9 + i;
				dataItem.close = 12 + i;
				dataItem.timestamp = new Date(2000, 01, 01, 10, i);
				data.push(dataItem);
			}
			return data;
		}
		
		[Test]
		public function checkIncorrectWidthInput():void
		{
			var returnVal:Array;
			for each (var width:Number in incorrectHeightsWidths) 
			{
				returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, data, minVal, maxVal);
				assertTrue(returnVal.length == 0);
			}
		}
		
		[Test]
		public function checkCorrectWidthInput():void
		{
			var returnVal:Array;
			for each (var width:Number in correctHeightsWidths) 
			{
				returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, data, minVal, maxVal);
				assertTrue(returnVal.length > 0);
			}
			
		}
		
		[Test]
		public function checkIncorrectHeightInput():void
		{
			var returnVal:Array;
			for each (var height:Number in incorrectHeightsWidths) 
			{
				returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, data, minVal, maxVal);
				assertTrue(returnVal.length == 0);
			}
		}
		
		[Test]
		public function checkCorrectHeightInput():void
		{
			var returnVal:Array;
			for each (var height:Number in correctHeightsWidths) 
			{
				returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, data, minVal, maxVal);
				assertTrue(returnVal.length > 0);
			}
		}
		
		[Test]
		public function checkEmptyDataInput():void
		{
			var returnVal:Array;
			returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, [], minVal, maxVal);
			assertTrue(returnVal.length == 0);
		}
		
		[Test]
		public function typesInReturningArray():void
		{
			var returnVal:Array;
			returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, [], minVal, maxVal);
			
			for (var i:int = 0; i < returnVal.length; i++) 
			{
				assertTrue(returnVal[i] is Point);
			}
			
		}
		
		[Test]
		public function isXCalculationProper():void
		{
			var testData:Array = data.slice(0, 100);
			var returnVal:Array;
			width = 1000;
			returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, testData, minVal, maxVal);
			
			for (var i:int = 0; i < returnVal.length; i++) 
			{
				var coordinate:Point = returnVal[i] as Point;
				assertTrue(coordinate.x == i*width/testData.length);
			}
		}
		
		[Test]
		public function isYCalculationProper():void
		{
			var returnVal:Array;
			height = 1000;
			returnVal = DataToCoordinates.sampleDataAndGetPoints(width, height, data, minVal, maxVal);
			
			for (var i:int = 0; i < returnVal.length; i++) 
			{
				var coordinate:Point = returnVal[i] as Point;
				assertTrue(coordinate.y >= 0 && coordinate.y <= height);
			}
		}
		
	}
}