package org.shinyheaven.service.dto {

    /**
     * Tick like object that is used to display
     * calculated and programmatic values on charts.
     *
     * @author Attila
     *
     */
    public class ChartPoint implements IHistoricalDataItem {

        private var _value:Number;
        private var _timestamp:Date;

        public function ChartPoint(value:Number, timestamp:Date) {
            this._value = value;
            this._timestamp = timestamp;
        }

        public function get value():Number {
            return _value;
        }

        public function get timestamp():Date {
            return _timestamp;
        }
    }

}
