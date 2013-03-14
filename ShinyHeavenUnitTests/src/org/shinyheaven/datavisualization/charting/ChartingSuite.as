package org.shinyheaven.datavisualization.charting
{
	import org.shinyheaven.datavisualization.charting.LineChartUIControlsTest;
	import org.shinyheaven.datavisualization.charting.calculators.DataRangeCalculatorTest;
	import org.shinyheaven.datavisualization.charting.calculators.DataToCoordinatesTest;
	import org.shinyheaven.datavisualization.charting.calculators.indicators.MovingAverageCalculatorTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ChartingSuite
	{
		public var test1:org.shinyheaven.datavisualization.charting.calculators.DataRangeCalculatorTest;
		public var test2:org.shinyheaven.datavisualization.charting.calculators.DataToCoordinatesTest;
		public var test3:org.shinyheaven.datavisualization.charting.calculators.indicators.MovingAverageCalculatorTest;
		public var test4:org.shinyheaven.datavisualization.charting.LineChartUIControlsTest;
		
	}
}