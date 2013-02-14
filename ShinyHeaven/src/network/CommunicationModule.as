package network
{
    import flash.events.MouseEvent;
    import flash.events.SecurityErrorEvent;
    
    import parameters.Constants;

    public class CommunicationModule
    {
        
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
        
        private var _service : RemoteObject;
        
        public function CommunicationModule()
        {
        }
        
        [Init]
        public function initService():void 
        {
            _service = initializeService();
        }
        
        public function send_data():void 
        {
            getEcho(null);
        }
        
        protected function onResult(event:ResultEvent):void 
        {
            trace("onResult");
        }
        
        private function initializeService():RemoteObject 
        {
            var channel:AMFChannel = new AMFChannel("pyamf-channel", Constants.PythonServerURI);
            var channels:ChannelSet = new ChannelSet();
            channels.addChannel(channel);
            
            var remoteObject:RemoteObject = new RemoteObject("myservice");  
            remoteObject.showBusyCursor = true;
            remoteObject.channelSet = channels;
            
            remoteObject.addEventListener(FaultEvent.FAULT, onRemoteServiceFault);
            remoteObject.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRemoteServiceFault);
            
            return remoteObject;
        }
        
        public function getEcho(event:MouseEvent):void
        {
            var operation:AbstractOperation = _service.getOperation('echo');
            operation.addEventListener(ResultEvent.RESULT, resultHandler);
            operation.send("asdf");
        }
        
        protected function resultHandler(event:ResultEvent):void
        {
            var ac:ArrayCollection = event.result as ArrayCollection;
            for each (var o:Tick in ac){
                trace(o);
            }
            
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