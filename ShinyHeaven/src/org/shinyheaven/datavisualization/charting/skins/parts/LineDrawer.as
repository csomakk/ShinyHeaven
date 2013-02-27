package org.shinyheaven.datavisualization.charting.skins.parts
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Point;
	
	import mx.charts.chartClasses.GraphicsUtilities;
	import mx.core.UIComponent;
	import mx.graphics.IStroke;
	
	public class LineDrawer extends UIComponent
	{
		private var g:Graphics;
		private var _data:Array;
		
		[Inspectable]
		public var isFill:Boolean = false;
		
		public function LineDrawer()
		{
			g = graphics;
		}

		public function set data(value:Array):void
		{
			_data = value;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (!_data || _data.length < 2) return;
			
			g.clear();
			
			g.lineStyle(1, 0x454545, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
			
			var stroke:IStroke = getStyle("lineStroke");
			var form:String = getStyle("form");
			
			if (isFill) g.beginFill(0x000000, .1);
			
			GraphicsUtilities.drawPolyLine(g, _data, 0, _data.length, "x","y", stroke, form);
			
			g.lineStyle();
			g.lineTo((_data[_data.length-1] as Point).x, unscaledHeight);
			g.lineTo(0, unscaledHeight);
			
			if (isFill) g.endFill();
		}
		
		
	}
}