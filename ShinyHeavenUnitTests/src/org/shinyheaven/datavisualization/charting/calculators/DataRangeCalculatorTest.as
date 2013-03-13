package org.shinyheaven.datavisualization.charting.calculators
{
	import org.flexunit.asserts.assertTrue;
	import org.shinyheaven.datavisualization.charting.vo.DataRange;
	import org.shinyheaven.service.dto.OHLCUpdate;

	public class DataRangeCalculatorTest
	{		
		
		private var badData:Array /* Object */ = [];
		private var data:Array /* IHistoricalDataItem */ = [];
		private var amountOfData:int = 1000;
		
		[Before]
		public function setUp():void
		{
			badData = genBadData();
			data = genData(); 
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		private function genData():Array
		{
			var data:Array = [];
			for (var i:int = 0; i < amountOfData; i++) 
			{
				var dataItem:OHLCUpdate = new OHLCUpdate();
				dataItem.open = 3 + i;
				dataItem.high = 3 + i;
				dataItem.low = 3 + i;
				dataItem.close = 3 + i;
				dataItem.timestamp = new Date(2000, 01, 01, 10, i);
				data.push(dataItem);
			}
			return data;
		}
		
		private function genBadData():Array
		{
			var data:Array = [];
			for (var i:int = 0; i < 1001; i++) 
			{
				var dataItem:Object = {};
				dataItem.open = 3 + i;
				dataItem.high = 3 + i;
				dataItem.low = 3 + i;
				dataItem.close = 3 + i;
				dataItem.timestamp = new Date(2000, 01, 01, 10, i);
				data.push(dataItem);
			}
			return data;
		}
		
		[Test(expects="TypeError")]
		public function testTypedArray():void
		{
			var calculator:DataRangeCalculator = new DataRangeCalculator();
			calculator.getDataRange(badData);
		}
		
		[Test]
		public function testCalculation():void
		{
			var calculator:DataRangeCalculator = new DataRangeCalculator();
			var result:DataRange = calculator.getDataRange(data);
			
			assertTrue(result.minVal == 3);
			assertTrue(result.maxVal == 1002);
			assertTrue(result.firstDate.time == new Date(2000, 01, 01, 10, 0).time);
			assertTrue(result.lastDate.time == new Date(2000, 01, 01, 10, amountOfData-1).time);
		}
		
	}
}