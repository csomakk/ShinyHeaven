package org.shinyheaven.datavisualization.charting
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.shinyheaven.datavisualization.charting.calculations.DataToCoordinates;
	import org.shinyheaven.datavisualization.charting.calculations.indicators.MovingAverageCalculator;
	import org.shinyheaven.datavisualization.charting.events.UserControlEvent;
	import org.shinyheaven.datavisualization.charting.skins.parts.LineDrawer;
	import org.shinyheaven.datavisualization.charting.vo.DataRange;
	import org.shinyheaven.datavisualization.charting.calculations.DataRangeCalculator;
	
	public class LineChart extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var lineDrawer:LineDrawer;
		[SkinPart(required="true")]
		public var averageDrawer:LineDrawer;
		[SkinPart(required="true")]
		public var controls:LineChartUIControls;
				
		public var _dataProvider:ArrayCollection = new ArrayCollection();
		
		private var valueCoordinates:Array = [];
		private var averageCoordinates:Array = [];
		
		private var initAmountOfData:int;
		
		private var rangeForRendering:DataRange;
		
		public function LineChart()
		{
			super();
		}
		
		[Bindable]
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		public function set dataProvider(value:ArrayCollection):void
		{
			if (_dataProvider !== null && value !== null)
			{
				// SWAP DATA
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
				_dataProvider = value;
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
			}
			else if (value !== null)
			{
				// INIT DATA
				_dataProvider = value;
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
			}
			else
			{
				// NULL DATA
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
				_dataProvider = value;
			}

			invalidateProperties();
		}
		
		private function getInitAmountOFData():int
		{
			var result:int;
			if (initAmountOfData < 1)
			{
				result = _dataProvider.length;
			}
			else
			{
				result = initAmountOfData;
			}
			return result;
		}
		
		protected function handleDataChanged(event:CollectionEvent):void
		{
			invalidateProperties();
		}
		
		private function getDrawingCoordinates(data:Array):Array
		{
			var result:Array;
			if (lineDrawer && rangeForRendering)
			{
				result = DataToCoordinates.sampleDataAndGetPoints(
					lineDrawer.width, lineDrawer.height, 
					data, rangeForRendering.minVal, rangeForRendering.maxVal
				);
			}
			return result;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			initAmountOfData = getInitAmountOFData();
			
			rangeForRendering = new DataRangeCalculator().getDataRange(
				getDataToVisualize(_dataProvider.toArray(), initAmountOfData)
				);
			
			updateMainVolumeDrawer();
			updateMovingAverageDrawer();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			updateMainVolumeDrawer();
			updateMovingAverageDrawer();
		}
		
		private function updateMainVolumeDrawer():void
		{
			valueCoordinates = getDrawingCoordinates(
				getDataToVisualize(_dataProvider.toArray(), initAmountOfData)
			);
			lineDrawer.data = valueCoordinates;
		}
		
		private function updateMovingAverageDrawer():void
		{
			if (controls.isMovingAvrgEnabled)
			{
				averageCoordinates = getDrawingCoordinates(
					MovingAverageCalculator.calculate(
						getDataToVisualize(_dataProvider.toArray(), initAmountOfData), 
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