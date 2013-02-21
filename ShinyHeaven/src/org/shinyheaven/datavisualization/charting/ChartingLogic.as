package org.shinyheaven.datavisualization.charting
{
	
	import mx.collections.ArrayCollection;
	
	import org.shinyheaven.service.dto.IHistoricalDataItem;
	
	import org.shinyheaven.datavisualization.charting.vo.DataRange;
	
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
				range.min = Math.min(range.min, vo.value);
				range.max = Math.max(range.max, vo.value);
			}
			
			range.first = Number(instrData.getItemAt(0).timestamp);
			range.last = Number(instrData.getItemAt(instrData.length-1).timestamp);
			
			return range;
		}
		
		private function setDataRange(range:DataRange):void
		{
			minDate.setTime(range.first - 600);
			maxDate.setTime(range.last + 600);
			
			minVal = range.min - .0016;
			maxVal = range.max + .0016;
		}
				
		public function set data(data:ArrayCollection):void
		{
			if (data && data.length > 1)
			{
				setDataRange(getDataRange(data));
			}
		}
	}
}