package org.shinyheaven.datavisualization.charting.calculators.indicators {

    import org.shinyheaven.datavisualization.charting.vo.MovingAverageDataItem;
    import org.shinyheaven.service.dto.IHistoricalDataItem;

    public class MovingAverageCalculator {

        /**
         * Calculate Standard Moving Average statistics on given
         * data.
         *
         * @param data initial price data
         * @param window size of moving window
         * @return indicator array with average values
         */
        public static function calculate(data:Array, window:int = 20):Array {

            var result:Array = new Array();
            var sum:Number = 0.0;

            for (var i:int = 0, l:int = data.length; i < l; i++) {
                if (i <= window - 1) {
                    if (data.length >= window) {
						var originalTick:IHistoricalDataItem = (data[window - 1] as IHistoricalDataItem).clone();
                        var clonedTick:MovingAverageDataItem = new MovingAverageDataItem(originalTick.value, originalTick.timestamp);
                        sum += clonedTick.value / window;
                        result.push(clonedTick);
                    }
                } else {
                    var thisTick:IHistoricalDataItem = (data[i] as IHistoricalDataItem);
                    var averageTick:MovingAverageDataItem = new MovingAverageDataItem(sum, thisTick.timestamp);
                    result.push(averageTick);
                    sum += thisTick.value / window;
                    sum -= (data[i - window] as IHistoricalDataItem).value / window;
                }
            }

            return result;

        }
    }

}
