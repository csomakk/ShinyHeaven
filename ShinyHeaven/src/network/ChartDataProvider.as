package network
{
    import data.IChartDataProvider;

    import mx.collections.ArrayCollection;

    public class ChartDataProvider implements IChartDataProvider
	{
        private static var _data:ArrayCollection = new ArrayCollection();

	    public function get data():ArrayCollection {
            return _data;
        }
	}
}
