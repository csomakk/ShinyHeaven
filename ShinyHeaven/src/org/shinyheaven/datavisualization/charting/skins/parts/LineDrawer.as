package org.shinyheaven.datavisualization.charting.skins.parts
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	
	import org.shinyheaven.service.dto.IHistoricalDataItem;
	
	public class LineDrawer extends UIComponent
	{
		private var g:Graphics;
		private var _data:ArrayCollection;
		
		public var minVal:Number = 1;
		public var maxVal:Number = 1;
		
		public function LineDrawer()
		{
			g = graphics;
		}

		public function set data(value:ArrayCollection):void
		{
			//_data.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChange);
			_data = value;
			_data.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChange);
			//addBehavior()
		}
		
		private function addBehavior():void
		{
			_data.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleDataChange);
		}
		
		protected function handleDataChange(event:CollectionEvent):void
		{
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (!_data) return;
			
			g.clear();
			g.moveTo(0, unscaledHeight*0.5);
			g.lineStyle(1);
			
			var coordinates:Vector.<Point> = getPoints(unscaledWidth, unscaledHeight, _data);
			var moveTo:Point = coordinates.shift()
			g.moveTo(moveTo.x, moveTo.y);
			
			var point:Point;
			for (var i:int = 0; i < coordinates.length; i++) 
			{
				point = coordinates[i];
				g.lineTo(point.x, point.y);
			}
		}
		
		private function getPoints(width:Number, height:Number, data:ArrayCollection):Vector.<Point>
		{
			var result:Vector.<Point> = new Vector.<Point>();
			
			var xOffset:Number = width / (data.length-1);
			
			for (var i:int = 0; i < data.length; i++) 
			{
				var dataItem:IHistoricalDataItem = data.getItemAt(i) as IHistoricalDataItem;
				var unchangingRange:Number =  minVal;
				var x:Number = xOffset * i;
				var y:Number = height * ((dataItem.value - unchangingRange) / (maxVal - unchangingRange));
				y = height - y; // mirror the drawing direction
				var point:Point = new Point(x, y);
				result.push(point);
			}
			
			return result;
		}
	}
}