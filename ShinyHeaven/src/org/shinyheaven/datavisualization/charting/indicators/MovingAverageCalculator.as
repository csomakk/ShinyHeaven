package org.shinyheaven.datavisualization.charting.indicators {
import mx.collections.ArrayCollection;
import mx.utils.ObjectUtil;

import org.shinyheaven.service.dto.IHistoricalDataItem;
import org.shinyheaven.service.dto.Tick;

public class MovingAverageCalculator {

        /**
         * Calculate Standard Moving Average statistics on given
         * data.
         *
         * @param data initial price data
         * @param window size of moving window
         * @return indicator array with average values
         */
        public static function calculate(data:ArrayCollection, window:int = 20):ArrayCollection {

            var result:ArrayCollection = new ArrayCollection();

            for (var i:int = 0, l:int = data.length; i < l; i++) {
                // average indicators starts at the window,
                // data is unavailable before that point
                if (i <= window - 1) {
                    var clonedTick:Tick = ObjectUtil.clone(data.getItemAt(i)) as Tick;
                    clonedTick.open = NaN;
                    clonedTick.high = NaN;
                    clonedTick.low = NaN;
                    clonedTick.close = NaN;
                    result.addItem(clonedTick);
                } else {
                    var sum:Number = 0.0;
                    for (var j:int = i; j > i - window; j--) {
                        var tick:IHistoricalDataItem = ObjectUtil.clone(data.getItemAt(j)) as Tick;
                        sum += tick.value;
                    }
                    var averageValue:Number = sum / (window*1.0);
                    var averageTick:Tick = new Tick();
                    averageTick.open = averageValue;
                    averageTick.high = averageValue;
                    averageTick.low = averageValue;
                    averageTick.close = averageValue;
                    averageTick.timestamp = (data.getItemAt(i) as Tick).timestamp;
                    result.addItem(averageTick);
                }
            }

            return result;

        }
}
}
