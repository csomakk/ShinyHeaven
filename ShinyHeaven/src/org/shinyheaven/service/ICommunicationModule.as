package org.shinyheaven.service
{
	public interface ICommunicationModule
	{
		function getAvailableInstruments():void;
		function getNews():void;
		function lookupRequest(instrumentId:String):void;
	}
}