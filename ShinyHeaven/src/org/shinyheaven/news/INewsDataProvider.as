package org.shinyheaven.news
{
	import mx.collections.ArrayCollection;

	public interface INewsDataProvider
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