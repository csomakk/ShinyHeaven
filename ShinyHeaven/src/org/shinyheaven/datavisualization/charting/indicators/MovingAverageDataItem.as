package org.shinyheaven.datavisualization.charting.indicators {
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
