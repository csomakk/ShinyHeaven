package org.shinyheaven.service
{
    import org.shinyheaven.service.dto.IChartDataProvider;

    import mx.collections.ArrayCollection;

    public class ChartDataProvider implements IChartDataProvider
	{
        private const _data:ArrayCollection = new ArrayCollection();

	    public function get data():ArrayCollection {
            return _data;
        }
	}
}
