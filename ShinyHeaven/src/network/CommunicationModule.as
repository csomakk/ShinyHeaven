package network
{
import data.IChartDataProvider;

import flash.events.SecurityErrorEvent;

import mx.collections.IList;
import mx.controls.Alert;
import mx.messaging.ChannelSet;
import mx.messaging.channels.AMFChannel;
import mx.rpc.AbstractOperation;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;

import parameters.Constants;

public class CommunicationModule
    {
        private var _service : RemoteObject;
        private var _loginOperation : AbstractOperation;
        private var _lookupOperation : AbstractOperation;

        [Init]
        public function initializeService():void
        {
            var channel:AMFChannel = new AMFChannel("pyamf-channel", Constants.PythonServerURI);
            var channels:ChannelSet = new ChannelSet();
            channels.addChannel(channel);

            var _service:RemoteObject = new RemoteObject("fx_heaven_service");
            _service.showBusyCursor = true;
            _service.channelSet = channels;

            _service.addEventListener(FaultEvent.FAULT, onRemoteServiceFault);
            _service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRemoteServiceSecurityError);

            _loginOperation = _service.getOperation('login');
            _loginOperation.addEventListener(ResultEvent.RESULT, loginResultHandler);
            _loginOperation.send('');

            _lookupOperation = _service.getOperation('lookup');
            _lookupOperation.addEventListener(ResultEvent.RESULT, lookupResultHandler);
        }

        private function lookupRequest():void {
            var ro:RequestObject = new RequestObject(_clientId, 'XAUUSD', new Date(2011, 0, 1), new Date(2011, 0, 4));
            _lookupOperation.send(ro);
        }

        private var _clientId:Number;

        protected function loginResultHandler(event:ResultEvent):void
        {
            _loginOperation.removeEventListener(ResultEvent.RESULT, loginResultHandler);
            _clientId = event.result.client_id;
            lookupRequest();
        }

        [Inject]
        public var chartDataProvider:IChartDataProvider;

        protected function lookupResultHandler(event:ResultEvent):void
        {
            chartDataProvider.data.addAll(event.result as IList);
        }

        private function onRemoteServiceFault(event:FaultEvent):void
        {
            var errorMsg:String = "Service error: " + event.fault.faultCode;
            Alert.show(event.fault.faultDetail, errorMsg);	
        }
        
        private function onRemoteServiceSecurityError(event:SecurityErrorEvent):void
        {
            var errorMsg:String = "Service security error";
            Alert.show(event.text, errorMsg);	
        }
    }
}