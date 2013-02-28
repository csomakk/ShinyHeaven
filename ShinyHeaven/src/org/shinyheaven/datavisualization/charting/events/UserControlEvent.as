package org.shinyheaven.datavisualization.charting.events
{
	import flash.events.Event;
	
	public class UserControlEvent extends Event
	{
		
		public static const MOVING_AVERAGE_CHANGED:String = "EventMovingAverageChanged";
		
		public function UserControlEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}