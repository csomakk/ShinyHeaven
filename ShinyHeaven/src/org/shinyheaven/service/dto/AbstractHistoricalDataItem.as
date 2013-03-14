package org.shinyheaven.service.dto {
    public class AbstractHistoricalDataItem implements IHistoricalDataItem {

        public function get value():Number {
            throw new Error('Abstract method.');
        }
		
		public function clone():IHistoricalDataItem{
			throw new Error('Abstract method.');
		}
		

        [Bindable]
        public var timestamp:Date;

    }
}
