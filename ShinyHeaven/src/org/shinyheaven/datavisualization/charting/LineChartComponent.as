package org.shinyheaven.datavisualization.charting
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.shinyheaven.datavisualization.charting.skins.parts.LineDrawer;
	
	[SkinStates("normal")]
	
	public class LineChartComponent extends SkinnableComponent
	{
		
		[SkinPart]
		public var lineDrawer:LineDrawer;
		
		[Bindable]
		public var logic:ChartingLogic = new ChartingLogic();
				
		public var _dataProvider:ArrayCollection;
		
		
		
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
		}

		
		protected function handleDataChanged(event:CollectionEvent):void
		{
			passDataToLogic(event.target as ArrayCollection);
		}
		
		private function passDataToLogic(data:ArrayCollection):void
		{
			if (logic)
			{
				logic.data = data;
			}
		}
		
	}
}