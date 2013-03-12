/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/12/13
 * Time: 5:33 PM
 */
package org.shinyheaven.datavisualization.charting.candlestick {
    import org.shinyheaven.service.dto.OHLCUpdate;

    public class InstrumentUpdateMsg {
        public var instrumentName:String;
        public var data:OHLCUpdate;

        public function InstrumentUpdateMsg(name:String, data:OHLCUpdate) {
            instrumentName = name;
            this.data = data;
        }
    }
}
