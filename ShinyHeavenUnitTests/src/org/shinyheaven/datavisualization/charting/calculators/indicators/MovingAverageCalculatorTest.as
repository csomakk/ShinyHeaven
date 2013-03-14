package org.shinyheaven.datavisualization.charting.calculators.indicators {
	
import org.flexunit.assertThat;
import org.shinyheaven.service.dto.IHistoricalDataItem;
import org.shinyheaven.service.dto.OHLCUpdate;

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
            var ticks:Array = new Array();
            for (var i:int = 0; i <= 100; ++i) {
                var tick:OHLCUpdate = new OHLCUpdate();
                tick.close = 10 + i;
                tick.high = 12 + i;
                tick.low = 15 + i;
                tick.timestamp = new Date(2000, 01, 01, 10, i);
                ticks.push(tick);
            }
            var ma20:Array = MovingAverageCalculator.calculate(ticks, 20);
            // other must be non nan
            for (i = 20; i <= 100; ++i) {
                assertThat((ma20[i] as IHistoricalDataItem).value > 0);
            }
            trace('testCalculate done...');
        }

        [Test]
        public function testCalculateConstant():void {
            var ticks:Array = new Array();
            for (var i:int = 0; i <= 100; ++i) {
                var tick:OHLCUpdate = new OHLCUpdate();
                tick.close = 10;
                tick.high = 10;
                tick.low = 10;
                tick.timestamp = new Date(2000, 01, 01, 10, i);
                ticks.push(tick);
            }
            var ma20:Array = MovingAverageCalculator.calculate(ticks, 20);
            // other must be non nan
            for (i = 20; i <= 100; ++i) {
                assertThat((ma20[i] as IHistoricalDataItem).value == 10);
            }
            trace('testCalculate done...');
        }

    }
}
