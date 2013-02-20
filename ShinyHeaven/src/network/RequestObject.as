package network {
    internal class RequestObject {
        public var client_id:Number; //uint;
        public var instrument:String;
        public var from:Number;
        public var to:Number;

        public function RequestObject(clientId:uint, instrument:String, from:Date, to:Date) {
            this.client_id = clientId;
            this.instrument = instrument;
            this.from = from.time;
            this.to = to.time;
        }
    }
}
