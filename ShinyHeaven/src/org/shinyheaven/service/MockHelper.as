package org.shinyheaven.service
{
	import org.shinyheaven.news.NewsItem;

	public class MockHelper
	{
		public function MockHelper()
		{
			
		}
		
		private static var prevStockPrice:Number;
		private static var prevStockDelta:Number;
		
		public static function getNextStockPrice():Number {
			if(isNaN(prevStockPrice)){
				prevStockPrice = Math.random()*5000;
				prevStockDelta = (Math.random() - 0.5) * prevStockPrice / 100
			}
			
			prevStockDelta = prevStockDelta * ((Math.random() * 4) - 2) + (Math.random() - 0.5) * prevStockPrice * 0.001;
			prevStockPrice = prevStockPrice + prevStockDelta;
			return prevStockPrice;
		}
		
		public static function getPreviousStockPrice():Number {
			return prevStockPrice;
		}
		
		public static function generateNews():String{
			var str:String = "";
			if(Math.random() > 0.9){
				if(Math.random() > 0.8){
					str = NewsItem.BREAKING_FLAG;
				}
				
				switch(int(Math.random()*7)){
					case 1: str += "Apple"; break;
					case 2: str += "Google"; break;
					case 3: str += "LogMeIn"; break;
					case 4: str += "Crytech"; break;
					case 5: str += "BlackBerry"; break;
					case 6: str += "Swatch"; break;
					case 0: str += "HP"; break;
				}
				
				str += " ";
					
				switch(int(Math.random()*7)){
					case 1: str += "increases"; break;
					case 2: str += "breaks"; break;
					case 3: str += "flies"; break;
					case 4: str += "plummets"; break;
					case 5: str += "rises"; break;
					case 6: str += "skyrockets"; break;
					case 0: str += "falls"; break;
				}
				
				
			}
			return str;
		}
	}
}