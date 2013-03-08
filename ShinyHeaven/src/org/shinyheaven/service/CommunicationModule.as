package org.shinyheaven.service {
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.system.Security;
    import flash.utils.Timer;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    
    import mx.collections.ArrayList;
    import mx.collections.IList;
    import mx.controls.Alert;
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.rpc.AbstractOperation;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.RemoteObject;
    import mx.utils.StringUtil;
    
    import org.shinyheaven.instrumenthandling.Instrument;
    import org.shinyheaven.instrumenthandling.InstrumentManager;
    import org.shinyheaven.news.NewsDataProvider;
    import org.shinyheaven.news.NewsItem;
    import org.shinyheaven.service.dto.HistoricalDataItem;
    import org.shinyheaven.service.dto.OHLCUpdate;

    public class CommunicationModule {
		
		private static const LOGIN_SERVICE_NAME:String = "login";
		private static const LOOKUP_SERVICE_NAME:String = "lookup";
		private static const UPDATE_SERVICE_NAME:String = "quotes";
		private static const GET_AVAILABLE_INSTRUMENTS:String = "getinstruments";
		private static const GET_NEWS_SERVICE_NAME:String = "news";
		
		private static const AMF_CHANNEL_NAME:String = "pyamf-channel";
		private static const AMF_SERVICE_PREFIX:String = "fx_heaven_service";
		
		private static const MOCKED_MODE:Boolean = true;
		
	
		[Inject]
		public var newsDataProvider:NewsDataProvider;
		[Inject]
		public var availableInstruments:AvailableInstrumentsDataProvider;
		[Inject]
		public var instrumentManager:InstrumentManager;
		
		private var service:RemoteObject;
		
		private var loginOperation:AbstractOperation;
		private var lookupOperation:AbstractOperation;
		private var updateOperation:AbstractOperation;
		private var getNewsOperation:AbstractOperation;
		private var getAvailableInstrumentsOperation:AbstractOperation;
		
		private var client_id:Number;
		
		private var updateTimer:Timer;
		
		[Init]
		public function initializeService():void {
			Security.allowDomain(Constants.PYTHONSERVER_URI);
			var channel:AMFChannel = new AMFChannel(AMF_CHANNEL_NAME, Constants.PYTHONSERVER_URI);
			var channels:ChannelSet = new ChannelSet();
			channels.addChannel(channel);
			
			service = new RemoteObject(AMF_SERVICE_PREFIX);
			service.showBusyCursor = false;
			service.channelSet = channels;
			
			service.addEventListener(FaultEvent.FAULT, onRemoteServiceFault);
			service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRemoteServiceSecurityError);
			
			loginOperation = service.getOperation(LOGIN_SERVICE_NAME);
			loginOperation.addEventListener(ResultEvent.RESULT, loginResultHandler);
			loginOperation.send('');
						
			lookupOperation = service.getOperation(LOOKUP_SERVICE_NAME);
			lookupOperation.addEventListener(ResultEvent.RESULT, lookupResultHandler);
			
			updateOperation = service.getOperation(UPDATE_SERVICE_NAME);
			updateOperation.addEventListener(ResultEvent.RESULT, updateResultHandler);
			
			getNewsOperation = service.getOperation(GET_NEWS_SERVICE_NAME);
			getNewsOperation.addEventListener(ResultEvent.RESULT, getNewsResultHandler);
			
			getAvailableInstrumentsOperation = service.getOperation(GET_AVAILABLE_INSTRUMENTS);
			getAvailableInstrumentsOperation.addEventListener(ResultEvent.RESULT, getAvailableInstrumentResult);
			
			if(MOCKED_MODE) {
				loginResultHandler(null);
			}
		}
		
		public function getAvailableInstruments():void {
			getAvailableInstrumentsOperation.send('');
			if(MOCKED_MODE){
				getAvailableInstrumentResult(null);
			}
		}
		
		protected function getAvailableInstrumentResult(event:ResultEvent):void
		{
			if(MOCKED_MODE) {
				availableInstruments.removeAll();
				availableInstruments.addItem(Constants.HARDCODED_INSTRUMENT);
				availableInstruments.addItem("EURUSD");
				availableInstruments.addItem("GBPUSD");
				availableInstruments.addItem("JPYUSD");
				availableInstruments.addItem("CHFUSD");
			} else {
				//TODO
			}
		}
		
		protected function getNewsResultHandler(event:ResultEvent):void
		{
			var result:String;
			if(MOCKED_MODE) {
				result = MockHelper.generateNews();
			} else {
				result = event.result as String;
			}
			if(result != ""){
				newsDataProvider.addNewsItem(new NewsItem(result));
			}
		}
		
		
		
		private function updateResultHandlerMock(idOfInstrument:String):void {
			var tick:OHLCUpdate
			var instrument:Instrument = instrumentManager.getInstrument(idOfInstrument);
			if(MOCKED_MODE) {
				tick = new OHLCUpdate();
				tick.open = instrument.mockHelper.getPreviousStockPrice();
				tick.close = instrument.mockHelper.getNextStockPrice();
				tick.high = instrument.mockHelper.getNextStockPrice()+(Math.random()*0.1-0.05);
				tick.low =  instrument.mockHelper.getNextStockPrice()+(Math.random()*0.1-0.05);
				var date:Date = new Date();
				date.time = new Date(2010,05,05,10,10).time + getTimer() + 1000;  				
				tick.timestamp = date;
			} else {
				throw new Error("mocked function call when mock is off")
			}
			if(!tick)
				throw new Error('updateResultHandler received no "Tick" in ResultEvent.');
			ShinyHeaven.logger.debug("Tick mock received: {0}", tick);
			instrument.chartDataProvider.data.addItem(tick);
		}
		
		private function updateResultHandler(event:ResultEvent):void {
			var tick:OHLCUpdate = event.result as OHLCUpdate;
			
			if(!tick)
				throw new Error('updateResultHandler received no "Tick" in ResultEvent.');
			ShinyHeaven.logger.info("Tick received:", tick);
			instrumentManager.getInstrument(Constants.HARDCODED_INSTRUMENT).chartDataProvider.data.addItem(tick);
		}
		
		public function getNews():void {
			if(MOCKED_MODE){
				getNewsResultHandler(null);
			}
			getNewsOperation.send('');		
		}
		
		public function lookupRequest(instrumentId:String):void {
			
			var ro:RequestObject = new RequestObject(client_id, instrumentId, Constants.START_DATE, Constants.END_DATE);
			lookupOperation.send(ro);
			if(MOCKED_MODE){
				lookupResultHandlerMock(ro.instrument);
			}
		}
		
		protected function loginResultHandler(event:ResultEvent):void {
			loginOperation.removeEventListener(ResultEvent.RESULT, loginResultHandler);
			if(MOCKED_MODE){
				client_id = 12234;
			} else {
				client_id = event.result.client_id;
			}
			
			getAvailableInstruments();
		}
		
		protected function lookupResultHandlerMock(idOfInstrument:String):void {
			
			if(MOCKED_MODE){
				
				var instrument:Instrument = instrumentManager.getInstrument(idOfInstrument);
				
				var a:ArrayList = new ArrayList();
				for(var i:int = 0; i<1000; i++){
					var time: Number = new Date(2010,05,05,10,1).time + getTimer() + i
					var date: Date = new Date()
					date.time = time;
					a.addItem(new HistoricalDataItem(instrument.mockHelper.getNextStockPrice() , date ));
				}
				
				instrument.chartDataProvider.data.addAll(a);
			} else {
				throw new Error("mock function in not mocked mode")
			}
			
			startAutomaticUpdating();
		}
		
		protected function lookupResultHandler(event:ResultEvent):void {
			
			trace(StringUtil.substitute("Got {0} of {1}s", event.result.length, getQualifiedClassName(event.result[0])));
			instrumentManager.getInstrument(Constants.HARDCODED_INSTRUMENT).chartDataProvider.data.addAll(event.result as IList);
			
			startAutomaticUpdating();
		}
		
		private function startAutomaticUpdating():void {
			updateTimer = new Timer(Constants.UPDATE_FREQUENCY,0);
			updateTimer.addEventListener(TimerEvent.TIMER, onAutomaticUpdate);
			updateTimer.start();
		}
		
		private function onAutomaticUpdate(event:TimerEvent):void {
			getUpdates();
			getNews();
		}
		
		private function getUpdates():void {
			if(MOCKED_MODE){
				var names:Vector.<String> = instrumentManager.getInstrumentNames();
				for each(var b:String in names){
					updateResultHandlerMock(b);
				}
			}
			updateOperation.send('');
		}
		
		private function onRemoteServiceFault(event:FaultEvent):void {
			var errorMsg:String = "Service error: " + event.fault.faultCode;
			if(MOCKED_MODE == false){
				Alert.show(event.fault.faultDetail, errorMsg);
			}
		}
		
		private function onRemoteServiceSecurityError(event:SecurityErrorEvent):void {
			var errorMsg:String = "Service security error";
			Alert.show(event.text, errorMsg);
		}
	}
}
