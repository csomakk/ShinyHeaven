package org.shinyheaven.service
{
	import flash.utils.Dictionary;

	public class InstrumentManager
	{
		
		
		[Inject]
		public var comm:CommunicationModule;
		
		private var dict:Dictionary = new Dictionary();
		
		public function InstrumentManager()
		{		
		}
		
		public function addInstrument(id:String, instrument:Instrument):void {
			if(dict[id] == null) {
				dict[id] = instrument;
				comm.lookupRequest(id);
			}
		}
		
		public function addNewInstrument(id:String):Instrument{
			var inst:Instrument = new Instrument();
			addInstrument(id, inst);
			return getInstrument(id);
		}
		
		public function getInstrument(id:String):Instrument {
			return dict[id];
		}
		
		public function getInstrumentNames():Vector.<String> {
			var a:Vector.<String> = new Vector.<String>();
			for (var key:Object in dict) {
				a.push(key);
			}
			return a;
		}
		
		
	}
}