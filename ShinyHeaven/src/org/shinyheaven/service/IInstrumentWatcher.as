package org.shinyheaven.service
{
	public interface IInstrumentWatcher
	{
		
			
		function subscribeToInstrument(id:String):void
			
		function unsubscribeFromInstrument():void
	}
}