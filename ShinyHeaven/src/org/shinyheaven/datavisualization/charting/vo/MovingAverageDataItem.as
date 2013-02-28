package org.shinyheaven.datavisualization.charting.vo {
    import org.shinyheaven.service.dto.HistoricalDataItem;

    /**
     * Value Object for Moving Average result representation
     *
     * @author Attila
     */
    public class MovingAverageDataItem extends HistoricalDataItem {
        public function MovingAverageDataItem(value:Number, timestamp:Date) {
            super(value, timestamp);
        }
    }
}
