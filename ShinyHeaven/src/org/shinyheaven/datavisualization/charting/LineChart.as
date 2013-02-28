package org.shinyheaven.datavisualization.charting
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.shinyheaven.datavisualization.charting.events.UserControlEvent;
	import org.shinyheaven.datavisualization.charting.skins.parts.LineDrawer;
	
	public class LineChart extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var lineDrawer:LineDrawer;
		[SkinPart(required="true")]
		public var averageDrawer:LineDrawer;
		[SkinPart(required="true")]
		public var controls:LineChartUIControls; 
		
		[Bindable]
		public var logic:ChartingLogic = new ChartingLogic();
				
		public var _dataProvider:ArrayCollection = new ArrayCollection();
		
		private var valueCoordinates:Array = [];
		private var averageCoordinates:Array = [];
		
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
				_dataProvider = value as ArrayCollection;
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
				passDataToLogic(value as ArrayCollection);
			}
			else if (value !== null)
			{
				// INIT DATA
				_dataProvider = value as ArrayCollection;
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
				passDataToLogic(value as ArrayCollection);
			}
			else
			{
				// NULL DATA
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChanged);
				_dataProvider = value as ArrayCollection;
			}
			invalidateProperties();
		}
		
		protected function handleDataChanged(event:CollectionEvent):void
		{
			passDataToLogic(event.target as ArrayCollection);
			invalidateProperties();
		}
		
		private function getDrawingCoordinates(data:Array):Array
		{
			return DataToCoordinates.sampleDataAndGetPoints(
				lineDrawer.width, lineDrawer.height, 
				data, logic.minVal, logic.maxVal
			);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
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
			valueCoordinates = getDrawingCoordinates(_dataProvider.source);
			lineDrawer.data = valueCoordinates;
		}
		
		private function updateMovingAverageDrawer():void
		{
			if (controls.isMovingAvrgEnabled)
			{
				averageCoordinates = getDrawingCoordinates(logic.getMovingAverage(_dataProvider, controls.avrgWindow));
				averageDrawer.data = averageCoordinates;
				averageDrawer.visible = true;
			}
			else
			{
				averageDrawer.visible = false;
			}
		}
		
		private function passDataToLogic(data:ArrayCollection):void
		{
			logic.data = data;
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