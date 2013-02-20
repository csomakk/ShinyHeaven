package network {
    import avmplus.getQualifiedClassName;

    import data.IChartDataProvider;
    import data.Tick;

    import flash.events.SecurityErrorEvent;
    import flash.net.registerClassAlias;
    import flash.system.Security;

    import mx.collections.IList;
    import mx.controls.Alert;
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.rpc.AbstractOperation;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.RemoteObject;

    import parameters.Constants;

    public class CommunicationModule {
        private static const LOGIN_SERVICE_NAME:String = "login";
        private static const LOOKUP_SERVICE_NAME:String = "lookup";
        private static const AMF_CHANNEL_NAME:String = "pyamf-channel";
        private static const AMF_SERVICE_PREFIX:String = "fx_heaven_service";

        [Inject]
        public var chartDataProvider:IChartDataProvider;
        private var service:RemoteObject;
        private var loginOperation:AbstractOperation;
        private var lookupOperation:AbstractOperation;
        private var client_id:Number;

        [Init]
        public function initializeService():void {
            registerClassAlias('org.postabank.data.Tick', Tick);
            Security.allowDomain(Constants.PythonServerURI);
            var channel:AMFChannel = new AMFChannel(AMF_CHANNEL_NAME, Constants.PythonServerURI);
            var channels:ChannelSet = new ChannelSet();
            channels.addChannel(channel);

            service = new RemoteObject(AMF_SERVICE_PREFIX);
            service.showBusyCursor = true;
            service.channelSet = channels;

            service.addEventListener(FaultEvent.FAULT, onRemoteServiceFault);
            service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRemoteServiceSecurityError);

            loginOperation = service.getOperation(LOGIN_SERVICE_NAME);
            loginOperation.addEventListener(ResultEvent.RESULT, loginResultHandler);
            loginOperation.send('');

            lookupOperation = service.getOperation(LOOKUP_SERVICE_NAME);
            lookupOperation.addEventListener(ResultEvent.RESULT, lookupResultHandler);
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
            trace('Got # of Ticks ', event.result.length);
            trace(getQualifiedClassName(event.result[0]));
            chartDataProvider.data.addAll(event.result as IList);
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