package org.shinyheaven.datavisualization.charting
{
	import flash.events.Event;
	
	import spark.components.CheckBox;
	import spark.components.HSlider;
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.shinyheaven.datavisualization.charting.events.UserControlEvent;
	import org.shinyheaven.datavisualization.charting.skins.ChartControls;
	
	public class LineChartUIControls extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var isMovingAverageCheckBox:CheckBox;
		
		[SkinPart(required="true")]
		public var movingAvrgWindow:HSlider;
		
		public function LineChartUIControls()
		{
			super();
			setStyle('skinClass', ChartControls);
		}

		public function get isMovingAvrgEnabled():Boolean
		{
			if (isMovingAverageCheckBox)
			{
				return isMovingAverageCheckBox.selected;
			}
			else
			{
				return false;
			}
		}
		
		public function get avrgWindow():int
		{
			if (movingAvrgWindow) 
			{
				return movingAvrgWindow.value;
			}
			else 
			{
				return 20;
			}
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch(instance)
			{
				case isMovingAverageCheckBox:
				{
					isMovingAverageCheckBox.addEventListener(Event.CHANGE, dispatchChangeEvent);
					break;
				}
				case movingAvrgWindow:
				{
					movingAvrgWindow.addEventListener(Event.CHANGE, dispatchChangeEvent);
					break;
				}
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch(instance)
			{
				case isMovingAverageCheckBox:
				{
					isMovingAverageCheckBox.removeEventListener(Event.CHANGE, dispatchChangeEvent);
					break;
				}
				case movingAvrgWindow:
				{
					movingAvrgWindow.removeEventListener(Event.CHANGE, dispatchChangeEvent);
					break;
				}
			}
		}
		
		protected function dispatchChangeEvent(event:Event):void
		{
			dispatchEvent(new UserControlEvent(UserControlEvent.MOVING_AVERAGE_CHANGED));
		}
		
	}
}