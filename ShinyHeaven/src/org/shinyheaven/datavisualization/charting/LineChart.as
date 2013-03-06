package org.shinyheaven.datavisualization.charting
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.shinyheaven.datavisualization.charting.calculators.DataRangeCalculator;
	import org.shinyheaven.datavisualization.charting.calculators.DataToCoordinates;
	import org.shinyheaven.datavisualization.charting.calculators.indicators.MovingAverageCalculator;
	import org.shinyheaven.datavisualization.charting.drawers.SparkLineDrawer;
	import org.shinyheaven.datavisualization.charting.events.UserControlEvent;
	import org.shinyheaven.datavisualization.charting.vo.DataRange;
	
	public class LineChart extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var valueDrawer:SparkLineDrawer;
		[SkinPart(required="true")]
		public var averageDrawer:SparkLineDrawer;
		[SkinPart(required="true")]
		public var controls:LineChartUIControls;
				
		public var _dataProvider:ArrayCollection = new ArrayCollection();
		
		private var valueCoordinates:Array = [];
		private var averageCoordinates:Array = [];
		
		private var initAmountOfDataEnabled:Boolean = true;
		private var amountOfData:int;
		
		private var rangeForRendering:DataRange;
		
		private var readyToDraw:Boolean = false;
		
		public function LineChart()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, addBehavior);
		}
		
		protected function addBehavior(event:FlexEvent):void
		{
			readyToDraw = true;
			addEventListener(ResizeEvent.RESIZE, handleChartResized);
		}
		
		
		[Bindable]
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		public function set dataProvider(value:ArrayCollection):void
		{
			_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
			_dataProvider = value;
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);

			dataOrSizeChanged();
		}
		
		protected function handleChartResized(event:ResizeEvent):void
		{
			callLater(dataOrSizeChanged);
		}
		
		protected function handleDataChanged(event:CollectionEvent):void
		{
			dataOrSizeChanged();
		}
		
		private function getInitAmountOFData():int
		{
			var result:int;
			if (amountOfData < 1 || !initAmountOfDataEnabled)
			{
				result = _dataProvider.length;
			}
			else
			{
				result = amountOfData;
			}
			return result;
		}
		
		
		private function getDrawingCoordinates(data:Array):Array
		{
			var result:Array;
			if (valueDrawer && rangeForRendering)
			{
				result = DataToCoordinates.sampleDataAndGetPoints(
					valueDrawer.width, valueDrawer.height, 
					data, rangeForRendering.minVal, rangeForRendering.maxVal
				);
			}
			return result;
		}
		
		protected function dataOrSizeChanged():void
		{
			if (!readyToDraw) return;
			
			amountOfData = getInitAmountOFData();
			
			rangeForRendering = new DataRangeCalculator().getDataRange(
				getDataToVisualize(_dataProvider.toArray(), amountOfData)
				);
			
			updateMainVolumeDrawer();
			updateMovingAverageDrawer();
		}
		
		private function updateMainVolumeDrawer():void
		{
			valueCoordinates = getDrawingCoordinates(
				getDataToVisualize(_dataProvider.toArray(), amountOfData)
			);
			valueDrawer.data = valueCoordinates;
		}
		
		private function updateMovingAverageDrawer():void
		{
			if (controls.isMovingAvrgEnabled)
			{
				averageCoordinates = getDrawingCoordinates(
					MovingAverageCalculator.calculate(
						getDataToVisualize(_dataProvider.toArray(), amountOfData), 
						controls.avrgWindow));
				averageDrawer.data = averageCoordinates;
				averageDrawer.visible = true;
			}
			else
			{
				averageDrawer.visible = false;
			}
		}
		
		private function getDataToVisualize(data:Array, amount:int):Array
		{
			return data.slice(data.length-amount, data.length-1);
		}
		
		protected function handleMovingAverageUserControlEvent(event:UserControlEvent):void
		{
			updateMovingAverageDrawer();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch(instance)
			{
				case controls:
				{
					controls.addEventListener(UserControlEvent.MOVING_AVERAGE_CHANGED, handleMovingAverageUserControlEvent);
					break;
				}
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			switch(instance)
			{
				case controls:
				{
					controls.removeEventListener(UserControlEvent.MOVING_AVERAGE_CHANGED, handleMovingAverageUserControlEvent);
					break;
				}
			}
		}
		
	}
}