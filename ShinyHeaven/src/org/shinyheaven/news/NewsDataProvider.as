package org.shinyheaven.news
{
	import mx.collections.ArrayCollection;

	public class NewsDataProvider implements INewsDataProvider
	{
		private static const _data:ArrayCollection = new ArrayCollection();
		
		public function get data():ArrayCollection {
			return _data;
		}
		
		public function addNewsItem(newsItem:NewsItem):void {
			data.addItemAt(newsItem, 0);
		}
	}
}