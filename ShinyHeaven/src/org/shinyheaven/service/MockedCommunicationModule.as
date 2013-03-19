package org.shinyheaven.service
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.rpc.events.ResultEvent;
	
	import org.shinyheaven.instrumenthandling.Instrument;
	import org.shinyheaven.instrumenthandling.InstrumentManager;
	import org.shinyheaven.news.NewsDataProvider;
	import org.shinyheaven.news.NewsItem;
	import org.shinyheaven.service.dto.OHLCUpdate;
	
	public class MockedCommunicationModule implements ICommunicationModule
	{
		[Inject]
		public var newsDataProvider:NewsDataProvider;
		[Inject]
		public var availableInstruments:AvailableInstrumentsDataProvider;
		[Inject]
		public var instrumentManager:InstrumentManager;
		
		private var client_id:Number;
		private var updateTimer:Timer;
		private var requestsToPush:Array = new Array();
		
		[Init]
		public function initializeService():void {
			ShinyHeaven.logger.info("MockedCommunicationModule:initializeSercice");
			loginResultHandler(null);
		}
		
		public function getAvailableInstruments():void {
			getAvailableInstrumentResult(null);
		}
		
		protected function getAvailableInstrumentResult(event:ResultEvent):void
		{
			ShinyHeaven.logger.info("MockedCommunicationModule:getAvailableInstrumentResult");
			
			availableInstruments.removeAll();
			availableInstruments.addItem(Constants.HARDCODED_INSTRUMENT);
			availableInstruments.addItem("EURUSD");
			availableInstruments.addItem("GBPUSD");
			availableInstruments.addItem("JPYUSD");
			availableInstruments.addItem("CHFUSD");
			
		}
		
		protected function getNewsResultHandler(event:ResultEvent):void
		{
			var result:String = MockHelper.generateNews();
			
			if(result != ""){
				newsDataProvider.addNewsItem(new NewsItem(result));
			}
		}
		
		private function updateResultHandlerMock(idOfInstrument:String):void {
			var tick:OHLCUpdate
			var instrument:Instrument = instrumentManager.getInstrument(idOfInstrument);
			tick = new OHLCUpdate();
			tick.open = instrument.mockHelper.getPreviousStockPrice();
			tick.close = instrument.mockHelper.getNextStockPrice();
			tick.high = instrument.mockHelper.getNextStockPrice()+(Math.random()*0.1-0.05);
			tick.low =  instrument.mockHelper.getNextStockPrice()+(Math.random()*0.1-0.05);
			var date:Date = new Date();
			date.time = new Date(2010,05,05,10,10).time + getTimer() + 1000;  				
			tick.timestamp = date;
			
			if(!tick){
				ShinyHeaven.logger.error("MockedCommunicationModule.updateResultHandlerMock: updateResultHandler received no 'Tick' in ResultEvent.");
				throw new Error('updateResultHandler received no "Tick" in ResultEvent.');
			}
			ShinyHeaven.logger.debug("Tick mock received: {0}", tick);
			instrument.chartDataProvider.data.addItem(tick);
		}
		
		private function updateResultHandler(event:ResultEvent):void {
			var tick:OHLCUpdate = event.result as OHLCUpdate;
			
			if(!tick) {
				ShinyHeaven.logger.error("MockedCommunicationModule.updateResultHandler: updateResultHandler received no 'Tick' in ResultEvent."); 
				throw new Error('updateResultHandler received no "Tick" in ResultEvent.');
			}
			//ShinyHeaven.logger.info("CommunicationModule.updateResultHandlerTick: received {0}", tick);
			var instrument:Instrument = instrumentManager.getInstrument(Constants.HARDCODED_INSTRUMENT);
			if(instrument){
				instrument.chartDataProvider.data.addItem(tick);
			}
		}
		
		public function getNews():void {
			getNewsResultHandler(null);	
		}
		
		public function lookupRequest(instrumentId:String):void {
			
			var ro:RequestObject = new RequestObject(client_id, instrumentId, Constants.START_DATE, Constants.END_DATE);
			
			if(client_id){
				lookupResultHandlerMock(ro.instrument);
			} else {
				requestsToPush.push(instrumentId);
			}
		}
		
		protected function loginResultHandler(event:ResultEvent):void {
			ShinyHeaven.logger.info("MockedCommunicationModule:loginResultHandler");
			client_id = 12234;
			
			getAvailableInstruments();
		}
		
		protected function lookupResultHandlerMock(idOfInstrument:String):void {
			
			var instrument:Instrument = instrumentManager.getInstrument(idOfInstrument);
			
			var a:ArrayList = new ArrayList();
			for(var i:int = 0; i < 1000; i++){
				var time: Number = new Date(2010,05,05,10,1).time + getTimer() + i
				var date: Date = new Date()
				date.time = time;
				/**
				 * Here we were mocking a {@link HistoricalDataItem}, but the {@link FlexCandlestickChart} needs
				 * full OHLC data.
				 */
				a.addItem(instrument.mockHelper.getNextOHLC());
			}
			
			instrument.chartDataProvider.data.addAll(a);
			
			startAutomaticUpdating();
		}
		
		protected function lookupResultHandler(event:ResultEvent):void {
			if(event.result.length == 0) {
				ShinyHeaven.logger.warn("MockedCommunicationModule.lookupResultHandler: Result length is 0");
			} else {
				ShinyHeaven.logger.info("MockedCommunicationModule.lookupResultHandler: Got {0} of {1}s", event.result.length, getQualifiedClassName(event.result[0]));
			}
			instrumentManager.getInstrument(Constants.HARDCODED_INSTRUMENT).chartDataProvider.data.addAll(event.result as IList);
			
			startAutomaticUpdating();
		}
		
		private function startAutomaticUpdating():void {
			ShinyHeaven.logger.info("MockedCommunicationModule.startAutomaticUpdating");
			updateTimer = new Timer(Constants.UPDATE_FREQUENCY,0);
			updateTimer.addEventListener(TimerEvent.TIMER, onAutomaticUpdate);
			updateTimer.start();
		}
		
		private function onAutomaticUpdate(event:TimerEvent):void {
			getUpdates();
			getNews();
		}
		
		private function getUpdates():void {
			var names:Vector.<String> = instrumentManager.getInstrumentNames();
			for each(var b:String in names){
				updateResultHandlerMock(b);
			}
		}
	}
}