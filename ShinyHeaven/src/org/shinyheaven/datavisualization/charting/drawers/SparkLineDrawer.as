package org.shinyheaven.datavisualization.charting.drawers
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Point;
	
	import mx.charts.chartClasses.GraphicsUtilities;
	
	import spark.core.SpriteVisualElement;

	public class SparkLineDrawer extends SpriteVisualElement
	{
		private var _data:Array = [];
		
		[Inspectable(category="Styles")]
		public var fillColor:uint;
		[Inspectable(category="Styles")]
		public var lineColor:uint;
		[Inspectable(category="Styles")]
		public var fillAlpha:Number;
		
		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
			
			if (
				_data && _data.length >= 2 &&
				width > 0 && height > 0
			)
			{
				draw(width, height, data);
			}
		}
		
		private function draw(width:Number, height:Number, data:Array):void
		{
			var g:Graphics = graphics;
			
			g.clear();
			g.lineStyle(1, lineColor, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			if (fillColor) g.beginFill(fillColor, fillAlpha);
			
			GraphicsUtilities.drawPolyLine(g, data, 0, data.length, "x","y", null, "step");
			
			if (fillColor)
			{
				g.lineStyle();
				g.lineTo((data[data.length-1] as Point).x, height);
				g.lineTo(0, height);
				
				g.endFill();
			}
		}
		
		
		
	}
}