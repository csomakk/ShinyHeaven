package org.shinyheaven.instrumenthandling
{
	import mx.collections.ArrayCollection;
	
	import org.shinyheaven.service.dto.IChartDataProvider;
	import org.shinyheaven.service.ChartDataProvider;
	import org.shinyheaven.service.MockHelper;

	public class Instrument
	{
		
		public var mockHelper:MockHelper = new MockHelper();
		public var chartDataProvider:IChartDataProvider;
		private var subscribers:ArrayCollection = new ArrayCollection();
		
		
		public function Instrument()
		{
			chartDataProvider = new ChartDataProvider();
		}
		
		public function addSubscriber(subscriber:Object):void {
			if(subscribers.contains(subscriber)) return;
			subscribers.addItem(subscriber);
		}
		
		public function removeSubscriber(subscriber:Object):void {
			var i:int = subscribers.getItemIndex(subscriber);
			if(i != -1){
				subscribers.removeItemAt(i);
			}
		}
		
		public function hasSubscribers():Boolean {
			return subscribers.length > 0;
		}
		
	}
}