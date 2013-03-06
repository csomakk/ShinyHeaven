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
			draw(width, height);
		}

		override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean=true):void 
		{
			super.setLayoutBoundsSize(width, height, postLayoutTransform);
			trace("SparkLineDrawer.setLayoutBoundsSize(width, height, postLayoutTransform)");
			
			draw(width, height);
		}
		
		private function draw(width:Number, height:Number):void
		{
			if (!_data || _data.length < 2) return;
			
			var g:Graphics = graphics;
			
			g.clear();
			g.lineStyle(1, lineColor, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			if (fillColor) g.beginFill(fillColor, fillAlpha);
			
			GraphicsUtilities.drawPolyLine(g, _data, 0, _data.length, "x","y", null, "step");
			
			if (fillColor)
			{
				g.lineStyle();
				g.lineTo((_data[_data.length-1] as Point).x, height);
				g.lineTo(0, height);
				
				g.endFill();
			}
		}
		
		
		
	}
}