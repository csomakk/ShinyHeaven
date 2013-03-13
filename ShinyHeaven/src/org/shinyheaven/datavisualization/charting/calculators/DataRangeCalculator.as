package org.shinyheaven.datavisualization.charting.calculators
{
	
	import org.shinyheaven.datavisualization.charting.vo.DataRange;
	import org.shinyheaven.service.dto.IHistoricalDataItem;
	
	public class DataRangeCalculator
	{
				
		private function calculate(instrData:Array):DataRange
		{
			var range:DataRange = new DataRange();
			
			for each (var vo:IHistoricalDataItem in instrData) 
			{
				range.minVal = Math.min(range.minVal, vo.value);
				range.maxVal = Math.max(range.maxVal, vo.value);
			}
			
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