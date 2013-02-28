package org.shinyheaven.news
{
	public class NewsItem
	{
		
		
		private var _text:String;
		private var _isBreaking:Boolean;
		private var _date:Date;
		
		private static var BREAKING_FLAG:String = "BREAKING!  ";
		
		public function NewsItem(newsMessage:String)
		{
			text = newsMessage;
			_date = new Date();
		}
	
		public function get date():Date
		{
			return _date;
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
		
		[Bindable]
		public function get text():String
		{
			return _text;
		}
		
		public function set timeAndText(value:String):void {
			; //setter is needed for binding to work on getter
		}
		
		[Bindable]
		public function get timeAndText():String
		{
			return _date.hours + ":" + _date.minutes + " " + _text;
		}
		
		public function get isBreaking():Boolean
		{
			return _isBreaking;
		}
		
		[Bindable]
		public function set isBreaking(value:Boolean):void
		{
			_isBreaking = value;
		}
	}
}