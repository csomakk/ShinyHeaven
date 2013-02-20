package network {
    internal class RequestObject {
        public function RequestObject(clientId:Number, instrument:String, from:Date, to:Date) {
            this.client_id = clientId;
            this.instrument = instrument;
            this.from = from.time;
            this.to = to.time;
        }

        public var client_id:Number;
        public var instrument:String;
        public var from:Number;
        public var to:Number;
    }
}
