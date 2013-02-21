package org.shinyheaven.datavisualization.charting.vo
{
	public class DataRange
	{
		/**
		 * Highest value in a historical data stream 
		 */
		public var max:Number = Number.MIN_VALUE;
		/**
		 * Lowest value in a historical data stream 
		 */
		public var min:Number = Number.MAX_VALUE;
		/**
		 * Timestamp's of first item in a historical data stream
		 */
		public var first:Number;
		/**
		 * Timestamp's of last item in a historical data stream
		 */
		public var last:Number;
		
		public function toString():String
		{
			return "DataRange first:" + first + ", last:" + last + ", min:" + min + ", max:" + max; 
		}
	}
}