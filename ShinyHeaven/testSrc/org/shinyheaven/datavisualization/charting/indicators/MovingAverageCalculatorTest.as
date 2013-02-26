package org.shinyheaven.datavisualization.charting.indicators {
import mx.collections.ArrayCollection;

import org.flexunit.assertThat;

import org.flexunit.asserts.assertEquals;

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
                tick.timestamp = new Date(2000, 01, 01, 10, i);
                ticks.addItem(tick);
            }
            var ma20:ArrayCollection = MovingAverageCalculator.calculate(ticks, 20);
            // first 20 elements must be NAN
            for (var i = 0; i <= 19; ++i) {
                assertThat(isNaN((ma20.getItemAt(i) as Tick).value));
            }
            // other must be non nan
            for (var i = 20; i <= 100; ++i) {
                assertThat((ma20.getItemAt(i) as Tick).value > 0);
            }
            trace('testCalculate done...');
        }

        [Test]
        public function testCalculateConstant():void {
            var ticks:ArrayCollection = new ArrayCollection();
            for (var i:int = 0; i <= 100; ++i) {
                var tick:Tick = new Tick();
                tick.close = 10;
                tick.timestamp = new Date(2000, 01, 01, 10, i);
                ticks.addItem(tick);
            }
            var ma20:ArrayCollection = MovingAverageCalculator.calculate(ticks, 20);
            // first 20 elements must be NAN
            for (var i = 0; i <= 19; ++i) {
                assertThat(isNaN((ma20.getItemAt(i) as Tick).value));
            }
            // other must be non nan
            for (var i = 20; i <= 100; ++i) {
                assertThat((ma20.getItemAt(i) as Tick).value == 10);
            }
            trace('testCalculate done...');
        }

    }
}