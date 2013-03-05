package org.shinyheaven.datavisualization.charting.drawers
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Point;
	
	import mx.charts.chartClasses.GraphicsUtilities;
	import mx.core.UIComponent;
	
	[Style(name="fillAlpha", type="Number", format="Number", inherit="yes")]
	[Style(name="fillColor", type="uint", format="Color", inherit="yes")]
	[Style(name="lineColor", type="uint", format="Color", inherit="yes")]
	[Style(name="lineForm", type="String", format="String", enumeration="strait, curve", inherit="yes")]
	
	public class LineDrawer extends UIComponent
	{
		private var g:Graphics;
		private var _data:Array;
		
		[Inspectable]
		public var isFill:Boolean = false;
		

		[Inspectable(category="Styles")]
		public function get fillAlpha():Number
		{
			return getStyle('fillAlpha') as Number;
		}
		public function set fillAlpha(value:Number):void
		{
			setStyle('fillAlpha', value);
		}
		[Inspectable(category="Styles")]
		public function get fillColor():uint
		{
			return getStyle('fillColor') as uint;
		}
		public function set fillColor(value:uint):void
		{
			setStyle('fillColor', value);
		}
		[Inspectable(category="Styles")]
		public function get lineForm():String
		{
			return getStyle('form') as String;
		}
		public function set lineForm(value:String):void
		{
			setStyle('form', value);
		}
		[Inspectable(category="Styles")]
		public function get lineColor():uint
		{
			return getStyle('lineColor') as uint;
		}
		public function set lineColor(value:uint):void
		{
			setStyle('lineColor', value);
		}

		
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
			g.lineStyle(1, getStyle('lineColor'), 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
						
			if (isFill) g.beginFill(getStyle("fillColor"), getStyle("fillAlpha"));
			
			GraphicsUtilities.drawPolyLine(g, _data, 0, _data.length, "x","y", null, getStyle("lineForm"));
			
			if (isFill)
			{
				g.lineStyle();
				g.lineTo((_data[_data.length-1] as Point).x, unscaledHeight);
				g.lineTo(0, unscaledHeight);
				
				g.endFill();
			}
		}
		
	}
}