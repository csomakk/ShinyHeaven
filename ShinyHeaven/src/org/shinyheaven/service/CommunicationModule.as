package org.shinyheaven.service {
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.system.Security;
    import flash.utils.Timer;
    import flash.utils.getQualifiedClassName;
    
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.controls.Alert;
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.rpc.AbstractOperation;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.RemoteObject;
    
    import org.shinyheaven.instrumenthandling.Instrument;
    import org.shinyheaven.instrumenthandling.InstrumentManager;
    import org.shinyheaven.news.NewsDataProvider;
    import org.shinyheaven.news.NewsItem;
    import org.shinyheaven.service.dto.OHLCUpdate;
	
    public class CommunicationModule implements ICommunicationModule {
		
		private static const LOGIN_SERVICE_NAME:String = "login";
		private static const LOOKUP_SERVICE_NAME:String = "lookup";
		private static const UPDATE_SERVICE_NAME:String = "quotes";
		private static const GET_AVAILABLE_INSTRUMENTS:String = "list_instruments";
		private static const GET_NEWS_SERVICE_NAME:String = "news";
		
		private static const AMF_CHANNEL_NAME:String = "pyamf-channel";
		private static const AMF_SERVICE_PREFIX:String = "fx_heaven_service";
		
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
		
		private var requestsToPush:Array = new Array();
		
		[Init]
		public function initializeService():void {
			ShinyHeaven.logger.info("CommunicationModule:initializeSercice");
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
			
		}
		
		public function getAvailableInstruments():void {
			getAvailableInstrumentsOperation.send('');
		}
		
		protected function getAvailableInstrumentResult(event:ResultEvent):void
		{
			ShinyHeaven.logger.info("CommunicationModule:getAvailableInstrumentResult");
			
			for(var i:int = 0; i < event.result.length; i++){
				availableInstruments.addItem((event.result as ArrayCollection).getItemAt(i));
			}
			while(requestsToPush.length > 0){
				lookupRequest(requestsToPush.pop());
			}
			
		}
		
		protected function getNewsResultHandler(event:ResultEvent):void
		{
			var result:String = event.result as String;
			
			if(result != ""){
				newsDataProvider.addNewsItem(new NewsItem(result));
			}
		}
		
		private function updateResultHandler(event:ResultEvent):void {
			var tick:OHLCUpdate = event.result as OHLCUpdate;
			
			if(!tick) {
				ShinyHeaven.logger.error("CommunicationModule.updateResultHandler: updateResultHandler received no 'Tick' in ResultEvent."); 
				throw new Error('updateResultHandler received no "Tick" in ResultEvent.');
			}
			//ShinyHeaven.logger.info("CommunicationModule.updateResultHandlerTick: received {0}", tick);
			var instrument:Instrument = instrumentManager.getInstrument(Constants.HARDCODED_INSTRUMENT);
			if(instrument){
				instrument.chartDataProvider.data.addItem(tick);
			}
		}
		
		public function getNews():void {
			getNewsOperation.send('');		
		}
		
		public function lookupRequest(instrumentId:String):void {
			
			var ro:RequestObject = new RequestObject(client_id, instrumentId, Constants.START_DATE, Constants.END_DATE);
			if(client_id){
				lookupOperation.send(ro);
			} else {
				requestsToPush.push(instrumentId);
			}
		}
				
		protected function loginResultHandler(event:ResultEvent):void {
			ShinyHeaven.logger.info("CommunicationModule:loginResultHandler");
			loginOperation.removeEventListener(ResultEvent.RESULT, loginResultHandler);
			client_id = event.result.client_id;
			
			getAvailableInstruments();
		}
		
		protected function lookupResultHandler(event:ResultEvent):void {
			if(event.result.length == 0) {
				ShinyHeaven.logger.warn("CommunicationModule.lookupResultHandler: Result length is 0");
			} else {
				ShinyHeaven.logger.info("CommunicationModule.lookupResultHandler: Got {0} of {1}s", event.result.length, getQualifiedClassName(event.result[0]));
			}
			instrumentManager.getInstrument(Constants.HARDCODED_INSTRUMENT).chartDataProvider.data.addAll(event.result as IList);
			
			startAutomaticUpdating();
		}
		
		private function startAutomaticUpdating():void {
			ShinyHeaven.logger.info("CommunicationModule.startAutomaticUpdating");
			updateTimer = new Timer(Constants.UPDATE_FREQUENCY,0);
			updateTimer.addEventListener(TimerEvent.TIMER, onAutomaticUpdate);
			updateTimer.start();
		}
		
		private function onAutomaticUpdate(event:TimerEvent):void {
			getUpdates();
			getNews();
		}
		
		private function getUpdates():void {
			updateOperation.send('');
		}
		
		private function onRemoteServiceFault(event:FaultEvent):void {
			var errorMsg:String = "Service error: " + event.fault.faultCode;
		}
		
		private function onRemoteServiceSecurityError(event:SecurityErrorEvent):void {
			var errorMsg:String = "Service security error";
			ShinyHeaven.logger.error("CommunicationModule:onRemoteServiceFault: {0}, {1}", event.text, errorMsg);
			Alert.show(event.text, errorMsg);
		}
	}
}
