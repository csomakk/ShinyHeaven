/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/13/13
 * Time: 4:13 PM
 */
package org.shinyheaven.datavisualization.fill {
    import flash.display.BitmapData;

    import spark.components.Group;

    [Style(name="gridBackground", type="uint", format="Color")]
    [Style(name="gridColor", type="uint", format="Color")]
    [Style(name="gridDistance", type="Number", format="Length")]
    public class DashedGridFill extends Group {
        public function DashedGridFill() {
            setStyle("gridBackground", 0xffffff);
            setStyle("gridColor", 0x888888);
            setStyle("gridDistance", 45);
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

        override public function styleChanged(styleProp:String):void {
            super.styleChanged(styleProp);
            _invalid = true;
        }

        private static const GRID_STEP:Number = 50.1;
        private static const GRID_STROKE_WIDTH:Number = 0.75;

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (_invalid) {
                var bmp:BitmapData = new BitmapData(unscaledWidth, unscaledHeight, true, getStyle("gridBackground"));
                var fn:Function = function(x:int):Boolean { return x % getStyle("gridDistance") == 0; };
                for (var x:int = 0; x < unscaledWidth; x++) for (var y:int = 0; y < unscaledHeight; y++) {
                    bmp.setPixel(x, y, ([x, y].some(fn))? getStyle("gridColor") : getStyle("gridBackground"));
                }
                graphics.clear();
                graphics.beginBitmapFill(bmp);
                graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
                graphics.endFill();
                _invalid = false;
            }
        }
    }
}
