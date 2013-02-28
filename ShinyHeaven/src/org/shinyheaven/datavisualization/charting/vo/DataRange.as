package org.shinyheaven.datavisualization.charting.vo
{
	public class DataRange
	{
		/**
		 * Highest value in a historical data stream 
		 */
		[Bindable]
		public var maxVal:Number = Number.MIN_VALUE;
		/**
		 * Lowest value in a historical data stream 
		 */
		[Bindable]
		public var minVal:Number = Number.MAX_VALUE;
		/**
		 * Timestamp's of first item in a historical data stream
		 */
		[Bindable]
		public var firstDate:Date = new Date();
		/**
		 * Timestamp's of last item in a historical data stream
		 */
		[Bindable]
		public var lastDate:Date = new Date();
		
	}
}