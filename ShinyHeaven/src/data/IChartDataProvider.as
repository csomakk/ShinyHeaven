package data
{
	import mx.collections.ArrayCollection;

	public interface IChartDataProvider
	{
		/**
		 * Returns with an {@link ArrayCollection} of {@link Tick}s.
		 * 
		 * @return ArrayCollection; 
		 * 
		 */
		function get data():ArrayCollection;
	}
}