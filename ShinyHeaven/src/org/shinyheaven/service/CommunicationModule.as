package org.shinyheaven.service {
    import avmplus.getQualifiedClassName;

import flash.events.TimerEvent;

import flash.utils.Timer;
    import flash.utils.getQualifiedClassName;

    import mx.utils.StringUtil;

    import org.shinyheaven.service.dto.IChartDataProvider;

    import flash.events.SecurityErrorEvent;
    import flash.system.Security;

    import mx.collections.IList;
    import mx.controls.Alert;
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.rpc.AbstractOperation;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.RemoteObject;

import org.shinyheaven.service.dto.Tick;

public class CommunicationModule {

        private static const LOGIN_SERVICE_NAME:String = "login";
        private static const LOOKUP_SERVICE_NAME:String = "lookup";
        private static const UPDATE_SERVICE_NAME:String = "quotes";

        private static const AMF_CHANNEL_NAME:String = "pyamf-channel";
        private static const AMF_SERVICE_PREFIX:String = "fx_heaven_service";

        [Inject]
        public var chartDataProvider:IChartDataProvider;
        private var service:RemoteObject;

        private var loginOperation:AbstractOperation;
        private var lookupOperation:AbstractOperation;
        private var updateOperation:AbstractOperation;

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
        }

        private function updateResultHandler(event:ResultEvent):void {
            var tick:Tick = event.result as Tick;
            if(!tick)
                throw new Error('updateResultHandler received no "Tick" in ResultEvent.');
            trace("Tick received:", tick);
            chartDataProvider.data.addItem(tick);
        }

        private function lookupRequest():void {
            var ro:RequestObject = new RequestObject(client_id, Constants.HARDCODED_INSTRUMENT, Constants.START_DATE, Constants.END_DATE);
            lookupOperation.send(ro);
        }

        protected function loginResultHandler(event:ResultEvent):void {
            loginOperation.removeEventListener(ResultEvent.RESULT, loginResultHandler);
            client_id = event.result.client_id;
            lookupRequest();
        }

        protected function lookupResultHandler(event:ResultEvent):void {
            trace(StringUtil.substitute("Got {0} of {1}s", event.result.length, flash.utils.getQualifiedClassName(event.result[0])));
            chartDataProvider.data.addAll(event.result as IList);
            startAutomaticUpdating();
        }

        private function startAutomaticUpdating():void {
            updateTimer = new Timer(Constants.UPDATE_FREQUENCY,0);
            updateTimer.addEventListener(TimerEvent.TIMER, onAutomaticUpdate);
            updateTimer.start();
        }

        private function onAutomaticUpdate(event:TimerEvent):void {
            updateOperation.send('');
        }

        private function onRemoteServiceFault(event:FaultEvent):void {
            var errorMsg:String = "Service error: " + event.fault.faultCode;
            Alert.show(event.fault.faultDetail, errorMsg);
        }

        private function onRemoteServiceSecurityError(event:SecurityErrorEvent):void {
            var errorMsg:String = "Service security error";
            Alert.show(event.text, errorMsg);
        }
    }
}