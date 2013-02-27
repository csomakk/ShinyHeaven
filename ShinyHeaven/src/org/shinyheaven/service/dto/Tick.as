package org.shinyheaven.service.dto
{
    import mx.utils.OrderedObject;

    [RemoteClass(alias='org.postabank.data.Tick')]
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
            return "Tick Object: " + timestamp + open + " " + low + " " + high + " " + close + " " + volume;
        }

        /**
         * Currently, it returns the Typical Price.
         */
        public function get value():Number {
            return typicalPrice;
        }

        public final function get typicalPrice():Number {
            return (high + low + close) / 3;
        }
    }
}
