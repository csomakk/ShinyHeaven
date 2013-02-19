package network
{
    import flash.events.MouseEvent;
    import flash.events.SecurityErrorEvent;
import flash.utils.setTimeout;

import parameters.Constants;

    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.events.FlexEvent;
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.rpc.AbstractOperation;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.RemoteObject;

    import data.Tick;

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
            lookupRequest();
        }

        private function lookupRequest():void {
            var ro:RequestObject = new RequestObject(_clientId, 'XAUUSD', new Date(2011, 0, 1), new Date(2011, 11, 31));
            _lookupOperation.send(ro);
        }

        private var _clientId:Number;

        protected function loginResultHandler(event:ResultEvent):void
        {
            _loginOperation.removeEventListener(ResultEvent.RESULT, loginResultHandler);
            _clientId = event.result.client_id;
        }

        protected function lookupResultHandler(event:ResultEvent):void
        {
            trace(event.result);
        }

        private function onRemoteServiceFault(event:FaultEvent):void
        {
            var errorMsg:String = "Service error:\n" + event.fault.faultCode;
            Alert.show(event.fault.faultDetail, errorMsg);	
        }
        
        private function onRemoteServiceSecurityError(event:SecurityErrorEvent):void
        {
            var errorMsg:String = "Service security error";
            Alert.show(event.text, errorMsg);	
        }
    }
}