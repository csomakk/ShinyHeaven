package org.shinyheaven.service.dto
{
    import avmplus.getQualifiedClassName;

    import mx.utils.StringUtil;

    [RemoteClass(alias='org.postabank.data.Tick')]
    public class OHLCUpdate extends AbstractHistoricalDataItem implements IHistoricalDataItem
    {
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
            return StringUtil.substitute("{0}: O={1} H={2} L={3} C={4} Vol={5} @ {6}", getQualifiedClassName(this), open, high, low, close, volume, timestamp);
        }

        /**
         * Currently, it returns the Typical Price.
         */
        override public function get value():Number {
            return typicalPrice;
        }

        public final function get typicalPrice():Number {
            return (high + low + close) / 3;
        }
		
		override public function clone():IHistoricalDataItem{
			var ret:OHLCUpdate = new OHLCUpdate();
			ret.low = low;
			ret.high = high;
			ret.close = close;
			ret.volume = volume;
			ret.open = open;
			return ret;
		}
    }
}
