package data
{
    import mx.utils.OrderedObject;

    [RemoteClass(alias='org.postabank.data.Tick')] // doesn't actually register the class
    public class Tick implements IHistoricalDataItem
    {
        [Bindable]
        public var timestamp : Date;
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

        /**
         * For simple charting purposes, treat the close as the principal value.
         */
        public function get value():Number {
            return close;
        }
    }
}
