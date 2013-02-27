package org.shinyheaven.datavisualization.charting.indicators {

    import mx.collections.ArrayCollection;
    import mx.utils.ObjectUtil;

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
                        var clonedTick:Tick = ObjectUtil.clone(data.getItemAt(window - 1)) as Tick;
                        sum += clonedTick.close / window;
                        result.addItem(clonedTick);
                    }
                } else {
                    var thisTick:Tick = (data.getItemAt(i) as Tick);
                    var averageTick:Tick = new Tick();
                    averageTick.close = sum;
                    averageTick.timestamp = thisTick.timestamp;
                    result.addItem(averageTick);
                    sum += thisTick.close / window;
                    sum -= (data.getItemAt(i - window) as Tick).close / window;
                }
            }

            return result;

        }
    }

}
