package org.shinyheaven.datavisualization.charting
{
	import flash.geom.Point;
	
	import org.shinyheaven.service.dto.IHistoricalDataItem;

	public class DataToCoordinates
	{
		public static function sampleDataAndGetPoints(width:Number, height:Number, data:Array, minVal:Number, maxVal:Number):Array
		{
			var result:Array = [];
			
			var xOffset:Number = width / (data.length-1);
			var increment:int = 1;
			
			/*
			If xOffset is smaller than 1px than we don't visualize all
			the data becouse we cannot draw more than one point to a single pixel.
			*/
			if (xOffset < 1)
			{
				// if xOffset is 0.5 we draw evry secont point etc.
				increment = Math.floor(increment / xOffset);
			}
			
			for (var i:int = 0; i < data.length; i+=increment) 
			{
				if (i+increment > data.length) break;
				
				var dataItem:IHistoricalDataItem = data[i] as IHistoricalDataItem;
				var unchangingRange:Number =  minVal;
				var x:Number = i * xOffset;
				
				var averageValue:Number = 0; 
				for (var j:int=i; j<i+increment; j++)
				{
					// and get the average of the undrawed data
					averageValue += height * ((data[j].value - unchangingRange) / (maxVal - unchangingRange));
				}
				averageValue = averageValue / increment;
				
				var y:Number = averageValue;
				y = height - y; // mirror the drawing direction
				var point:Point = new Point(x, y);
				result.push(point);
			}
			return result;
		}
	}
}