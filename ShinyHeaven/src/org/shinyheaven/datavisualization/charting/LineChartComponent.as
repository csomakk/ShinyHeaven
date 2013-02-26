package org.shinyheaven.datavisualization.charting
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.shinyheaven.datavisualization.charting.skins.parts.ChartControls;
	import org.shinyheaven.datavisualization.charting.skins.parts.LineDrawer;
	
	[SkinStates("normal")]
	
	public class LineChartComponent extends SkinnableComponent
	{
		
		[SkinPart]
		public var lineDrawer:LineDrawer;
		[SkinPart]
		public var controls:ChartControls;
		
		[Bindable]
		public var logic:ChartingLogic = new ChartingLogic();
				
		public var _dataProvider:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var drawingCoordinates:Array = [];
		
		public function LineChartComponent()
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
		
		private function getDrawingCoordinates():Array
		{
			return DataToCoordinates.sampleDataAndGetPoints(
				lineDrawer.width, lineDrawer.height, 
				dataProvider.source, logic.minVal, logic.maxVal
			);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			updateChart();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			updateChart();
		}
		
		private function updateChart():void
		{
			drawingCoordinates = getDrawingCoordinates();
			lineDrawer.data = drawingCoordinates;			
		}
		
		private function passDataToLogic(data:ArrayCollection):void
		{
			logic.data = data;
		}
	}
}