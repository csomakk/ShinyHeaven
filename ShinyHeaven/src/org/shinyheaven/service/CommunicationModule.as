package org.shinyheaven.service {
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.ui.Keyboard;
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
	
	import org.shinyheaven.news.NewsDataProvider;
	import org.shinyheaven.news.NewsItem;
	import org.shinyheaven.service.dto.HistoricalDataItem;
	import org.shinyheaven.service.dto.IChartDataProvider;
	import org.shinyheaven.service.dto.OHLCUpdate;
	
	public class CommunicationModule {
		
		private static const LOGIN_SERVICE_NAME:String = "login";
		private static const LOOKUP_SERVICE_NAME:String = "lookup";
		private static const UPDATE_SERVICE_NAME:String = "quotes";
		private static const GET_NEWS_SERVICE_NAME:String = "news";
		
		private static const AMF_CHANNEL_NAME:String = "pyamf-channel";
		private static const AMF_SERVICE_PREFIX:String = "fx_heaven_service";
		
		private static const MOCKED_MODE:Boolean = true;
		
		[Inject]
		public var chartDataProvider:IChartDataProvider;
		[Inject]
		public var newsDataProvider:NewsDataProvider;
		private var service:RemoteObject;
		
		private var loginOperation:AbstractOperation;
		private var lookupOperation:AbstractOperation;
		private var updateOperation:AbstractOperation;
		private var getNewsOperation:AbstractOperation;
		
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
			
			if(MOCKED_MODE) {
				loginResultHandler(null);
			}
		}
		
		protected function getNewsResultHandler(event:ResultEvent):void
		{
			if(MOCKED_MODE) {
				newsDataProvider.addNewsItem(new NewsItem((Math.random()*26+10).toString(36)));
			} else {
				if(event.result != ""){
					newsDataProvider.addNewsItem(new NewsItem(event.result as String));
				}
			}
		}
		
		private function updateResultHandler(event:ResultEvent):void {
			var tick:OHLCUpdate
			if(MOCKED_MODE) {
				tick = new OHLCUpdate();
				tick.close = 2135 + (Math.random() - 0.5) * 200;
				tick.high = 2135 + (Math.random() - 0.5) * 200;
				tick.low = 2135 + (Math.random() - 0.5) * 200;
				tick.open = 2135 + (Math.random() - 0.5) * 200;
				var date:Date = new Date();
				date.time = new Date(2010,05,05,10,10).time + getTimer() + 1000;  				
				tick.timestamp = date;
			} else {
				tick = event.result as OHLCUpdate;
			}
			if(!tick)
				throw new Error('updateResultHandler received no "Tick" in ResultEvent.');
			ShinyHeaven.logger.info("Tick received:", tick);
			chartDataProvider.data.addItem(tick);
		}
		
		public function getNews():void {
			if(MOCKED_MODE){
				getNewsResultHandler(null);
			}
			getNewsOperation.send('');		
		}
		
		private function lookupRequest():void {
			var ro:RequestObject = new RequestObject(client_id, Constants.HARDCODED_INSTRUMENT, Constants.START_DATE, Constants.END_DATE);
			lookupOperation.send(ro);
			if(MOCKED_MODE){
				lookupResultHandler(null);
			}
		}
		
		protected function loginResultHandler(event:ResultEvent):void {
			loginOperation.removeEventListener(ResultEvent.RESULT, loginResultHandler);
			if(MOCKED_MODE){
				client_id = 12234;
			} else {
				client_id = event.result.client_id;
			}
			lookupRequest();
		}
		
		protected function lookupResultHandler(event:ResultEvent):void {
			
			if(MOCKED_MODE){
				var a:ArrayList = new ArrayList();
				for(var i:int = 0; i<1000; i++){
					var time: Number = new Date(2010,05,05,10,1).time + getTimer() + i
					var date: Date = new Date()
					date.time = time;
					a.addItem(new HistoricalDataItem(2116 + (Math.random() - 0.5) * 200 , date ));
				}
				
				event = new ResultEvent("");
				chartDataProvider.data.addAll(a);
			} else {
				trace(StringUtil.substitute("Got {0} of {1}s", event.result.length, flash.utils.getQualifiedClassName(event.result[0])));
				chartDataProvider.data.addAll(event.result as IList);
			}
			
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
				updateResultHandler(null);
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