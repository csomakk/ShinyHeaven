/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 2/19/13
 * Time: 5:41 PM
 * To change this template use File | Settings | File Templates.
 */
package network {
    internal class RequestObject {
        public var clientId:uint;
        public var instrument:String;
        public var from:Date;
        public var to:Date;

        public function RequestObject(clientId:uint, instrument:String, from:Date, to:Date) {
            this.clientId = clientId;
            this.instrument = instrument;
            this.from = from;
            this.to = to;
        }
    }
}
