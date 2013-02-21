package org.shinyheaven.uiframe
{
    import spark.core.SpriteVisualElement;

    public class DragMarker extends SpriteVisualElement
	{
		public function DragMarker()
		{
			super();
		}
		override public function set height(value:Number):void{
			super.height = value;
			refresh();
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			refresh();
		}
		
		private function refresh():void{
			graphics.clear();
			graphics.lineStyle(3,0xdd5500);
			graphics.lineTo(width,height);
		}
	}
}