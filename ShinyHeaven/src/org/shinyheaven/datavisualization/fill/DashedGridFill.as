/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/13/13
 * Time: 4:13 PM
 */
package org.shinyheaven.datavisualization.fill {
    import spark.components.Group;

    [Style(name="backgroundColor", type="uint", format="Color")]
    [Style(name="gridColor", type="uint", format="Color")]
    public class DashedGridFill extends Group {
        public function DashedGridFill() {
            super();
            cacheAsBitmap = true;
        }

        private var _invalid:Boolean = true;

        override public function invalidateSize():void {
            super.invalidateSize();
            _invalid = true;
        }

        override public function invalidateDisplayList():void {
            super.invalidateDisplayList();
            _invalid = true;
        }

        private static const GRID_STEP:Number = 50.1;
        private static const GRID_STROKE_WIDTH:Number = 0.75;

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (_invalid) {
                graphics.clear();
                graphics.beginFill(0xffe4c4);
                graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
                graphics.endFill();
                graphics.lineStyle(GRID_STROKE_WIDTH, 0xb67c3d);
                for (var x:Number = -2; x < unscaledWidth; x+=GRID_STEP) {
                    graphics.moveTo(x, 0);
                    graphics.lineTo(x, unscaledHeight);
                }
                for (var y:Number = -2; y < unscaledHeight; y+=GRID_STEP) {
                    graphics.moveTo(0, y);
                    graphics.lineTo(unscaledWidth, y);
                }
                _invalid = false;
            }
        }
    }
}
