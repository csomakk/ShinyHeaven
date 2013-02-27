package org.shinyheaven.datavisualization.charting.indicators {
import mx.collections.ArrayCollection;

import org.flexunit.assertThat;

import org.flexunit.asserts.assertEquals;
    import org.shinyheaven.service.dto.IHistoricalDataItem;

    import org.shinyheaven.service.dto.Tick;

    public class MovingAverageCalculatorTest {
        public function MovingAverageCalculatorTest() {
        }

        [Before]
        public function setUp():void {

        }

        [After]
        public function tearDown():void {

        }

        [Test]
        public function testCalculate():void {
            var ticks:ArrayCollection = new ArrayCollection();
            for (var i:int = 0; i <= 100; ++i) {
                var tick:Tick = new Tick();
                tick.close = 10 + i;
                tick.high = 12 + i;
                tick.low = 15 + i;
                tick.timestamp = new Date(2000, 01, 01, 10, i);
                ticks.addItem(tick);
            }
            var ma20:ArrayCollection = MovingAverageCalculator.calculate(ticks, 20);
            // other must be non nan
            for (var i = 20; i <= 100; ++i) {
                assertThat((ma20.getItemAt(i) as IHistoricalDataItem).value > 0);
            }
            trace('testCalculate done...');
        }

        [Test]
        public function testCalculateConstant():void {
            var ticks:ArrayCollection = new ArrayCollection();
            for (var i:int = 0; i <= 100; ++i) {
                var tick:Tick = new Tick();
                tick.close = 10;
                tick.high = 10;
                tick.low = 10;
                tick.timestamp = new Date(2000, 01, 01, 10, i);
                ticks.addItem(tick);
            }
            var ma20:ArrayCollection = MovingAverageCalculator.calculate(ticks, 20);
            // other must be non nan
            for (var i = 20; i <= 100; ++i) {
                assertThat((ma20.getItemAt(i) as IHistoricalDataItem).value == 10);
            }
            trace('testCalculate done...');
        }

    }
}
