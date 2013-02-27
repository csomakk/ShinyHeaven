package org.shinyheaven.news
{
	public class NewsItem
	{
		
		private var _text:String;
		private var _isBreaking:Boolean;
		
		private static var BREAKING_FLAG:String = "BREAKING!  ";
		
		public function NewsItem(newsMessage:String)
		{
			text = newsMessage;
		}
		
		public function set text(value:String):void {
			if(value.search(BREAKING_FLAG) == 0) {
				_text = value.replace(BREAKING_FLAG, "");		
				_isBreaking = true;
			} else {
				_text = value;
				_isBreaking = false;
			}
		}
		
		public function get isBreaking():Boolean
		{
			return _isBreaking;
		}

		public function get text():String
		{
			return _text;
		}

	}
}