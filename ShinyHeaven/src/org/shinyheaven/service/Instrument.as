package org.shinyheaven.service
{
	import org.shinyheaven.service.dto.IChartDataProvider;

	public class Instrument
	{
		public function Instrument()
		{
			chartDataProvider = new ChartDataProvider();
		}
		
		public var mockHelper:MockHelper = new MockHelper()
		public var chartDataProvider:IChartDataProvider
		

	}
}