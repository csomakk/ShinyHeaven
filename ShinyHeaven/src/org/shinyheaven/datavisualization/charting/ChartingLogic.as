package org.shinyheaven.datavisualization.charting
{
	
	import mx.collections.ArrayCollection;
	
	import org.shinyheaven.datavisualization.charting.indicators.MovingAverageCalculator;
	import org.shinyheaven.datavisualization.charting.vo.DataRange;
	import org.shinyheaven.service.dto.IHistoricalDataItem;
	
	public class ChartingLogic
	{
		
		[Bindable]
		public var minDate:Date = new Date();
		[Bindable]
		public var maxDate:Date = new Date();
		[Bindable]
		public var minVal:Number;
		[Bindable]
		public var maxVal:Number;
		
		private function getDataRange(instrData:ArrayCollection):DataRange
		{
			var range:DataRange = new DataRange();
			
			for each (var vo:IHistoricalDataItem in instrData.source) 
			{
				range.min = Math.min(range.min, vo.typicalPrice);
				range.max = Math.max(range.max, vo.typicalPrice);
			}
			
			range.first = Number(instrData.getItemAt(0).timestamp);
			range.last = Number(instrData.getItemAt(instrData.length-1).timestamp);
			
			return range;
		}
		
		private function setDataRange(range:DataRange):void
		{
			minDate.setTime(range.first - 600);
			maxDate.setTime(range.last + 600);
			
			var emptyArea:Number = (range.max - range.min) * .2;
			
			minVal = range.min - emptyArea;
			maxVal = range.max + emptyArea;
		}
				
		public function set data(data:ArrayCollection):void
		{
			if (data && data.length > 1)
			{
				setDataRange(getDataRange(data));
			}
		}
		
		public function getMovingAverage(data:ArrayCollection, window:int):Array
		{
			return MovingAverageCalculator.calculate(data, window).source;
		}
	}
}