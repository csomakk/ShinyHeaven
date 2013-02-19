package data
{
	import mx.collections.ArrayCollection;

	public interface IChartDataProvider
	{
		/**
		 * Returns with an arraycollection of Ticks.
		 * 
		 * @return ArrayCollection; 
		 * 
		 */
		function get data():ArrayCollection;
	}
}