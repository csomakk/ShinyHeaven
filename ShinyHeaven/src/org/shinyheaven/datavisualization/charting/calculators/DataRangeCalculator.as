package org.shinyheaven.datavisualization.charting.calculators
{
	
	import org.shinyheaven.datavisualization.charting.vo.DataRange;
	import org.shinyheaven.service.dto.IHistoricalDataItem;
	
	public class DataRangeCalculator
	{
				
		private function calculate(instrData:Array):DataRange
		{
			//TODO Rename this class to DataRangeCalculator and put it into calculators package
			var range:DataRange = new DataRange();
			
			for each (var vo:IHistoricalDataItem in instrData) 
			{
				range.minVal = Math.min(range.minVal, vo.value);
				range.maxVal = Math.max(range.maxVal, vo.value);
			}
			
			var emptyArea:Number = (range.maxVal - range.minVal) * .2;
			
			range.minVal -= emptyArea;
			range.maxVal += emptyArea;
			
			range.firstDate.setTime(instrData[0].timestamp);
			range.lastDate.setTime(instrData[instrData.length-1].timestamp);
			
			return range;
		}
				
		public function getDataRange(data:Array):DataRange
		{
			var result:DataRange;
			if (data && data.length > 1)
			{
				result = calculate(data);
			}
			return result;
		}
		
	}
}