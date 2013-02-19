package data
{
import mx.formatters.DateFormatter;
import mx.utils.OrderedObject;

[RemoteClass(alias='org.postabank.data.Tick')]
    public class Tick
    {
        [Bindable]
        public var timestamp : String;
        [Bindable]
        public var open	: Number;
        [Bindable]
        public var low	: Number;
        [Bindable]
        public var high	: Number;
        [Bindable]
        public var close : Number;
        [Bindable]
        public var volume : Number;
        
        public function toString():String {
            new OrderedObject()
            return "Tick Object: " + timestamp + open + " " + low + " " + high + " " + close + " " + volume;
        }

        public function get time():Number {
            return DateFormatter.parseDateString(timestamp).time;
        }
    }
}
