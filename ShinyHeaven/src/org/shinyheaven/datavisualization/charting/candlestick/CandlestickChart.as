/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/12/13
 * Time: 5:21 PM
 */
package org.shinyheaven.datavisualization.charting.candlestick {
    import flash.utils.getQualifiedClassName;

    import org.spicefactory.parsley.view.Configure;

    import spark.core.SpriteVisualElement;

    public class CandlestickChart extends SpriteVisualElement {
        public function CandlestickChart() {
            super();
            Configure.view(this).execute();
        }

        [MessageHandler]
        public function onInstrumentUpdate(message:InstrumentUpdateMsg):void {
            ShinyHeaven.logger.warn(getQualifiedClassName(message));
        }
    }
}
