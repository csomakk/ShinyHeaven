package org.shinyheaven.datavisualization.charting.indicators {

    import mx.collections.ArrayCollection;
    import mx.utils.ObjectUtil;

    import org.shinyheaven.service.dto.ChartPoint;
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
            var sum:Number = 0.0;

            for (var i:int = 0, l:int = data.length; i < l; i++) {
                if (i <= window - 1) {
                    if (data.length >= window) {
                        var originalTick:IHistoricalDataItem = ObjectUtil.clone(data.getItemAt(window - 1)) as Tick;
                        var clonedTick:IHistoricalDataItem = new ChartPoint(originalTick.value, originalTick.timestamp);
                        sum += clonedTick.value / window;
                        result.addItem(clonedTick);
                    }
                } else {
                    var thisTick:IHistoricalDataItem = (data.getItemAt(i) as Tick);
                    var averageTick:ChartPoint = new ChartPoint(sum, thisTick.timestamp);
                    result.addItem(averageTick);
                    sum += thisTick.value / window;
                    sum -= (data.getItemAt(i - window) as Tick).value / window;
                }
            }

            return result;

        }
    }

}
