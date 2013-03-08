package org.shinyheaven.uiframe.mdi
{
    import spark.core.SpriteVisualElement;

    public class DragMarker extends SpriteVisualElement
	{
		override public function set height(value:Number):void{
            if (value != super.height) {
                super.height = value;
                refresh();
            }
		}
		
		override public function set width(value:Number):void{
            if (value != super.width) {
                super.width = value;
                refresh();
            }
		}

		private function refresh():void{
			graphics.clear();
			graphics.lineStyle(3,0xdd5500);
			graphics.lineTo(width,height);
		}
	}
}