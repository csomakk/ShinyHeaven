package org.shinyheaven.service.dto {
    import flash.utils.getQualifiedClassName;

    import mx.utils.StringUtil;

    /**
     * Tick like object that is used to display
     * calculated and programmatic values on charts.
     *
     * @author Attila
     *
     */
    public class HistoricalDataItem extends AbstractHistoricalDataItem implements IHistoricalDataItem {

        private var _value:Number;

        public function HistoricalDataItem(value:Number, timestamp:Date) {
            this._value = value;
            this.timestamp = timestamp;
        }

        override public function get value():Number {
            return _value;
        }
		
		override public function clone():IHistoricalDataItem{
			return new HistoricalDataItem(_value, timestamp);
		}

        public function toString():String {
            return StringUtil.substitute("{0}: {1} @ {2}", getQualifiedClassName(this), value, timestamp);
        }
    }

}
