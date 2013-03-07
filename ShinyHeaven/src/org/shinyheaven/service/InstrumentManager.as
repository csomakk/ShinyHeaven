package org.shinyheaven.service
{
	import flash.utils.Dictionary;

	public class InstrumentManager
	{
		
		[Inject]
		public var comm:CommunicationModule;
		
		private var instrumentDictionary:Dictionary = new Dictionary();
		
		public function InstrumentManager()
		{		
		}
		
		public function addInstrument(id:String, instrument:Instrument):void {
			if(instrumentDictionary[id] == null) {
				instrumentDictionary[id] = instrument;
				comm.lookupRequest(id);
			}
		}
		
		public function unsubscribe(id:String, callee:Object):void {
			var inst:Instrument = instrumentDictionary[id];
			if(inst != null) {
				inst.removeSubscriber(callee);
				if(inst.hasSubscribers() == false) {
					removeInstrument(id);
				}
			}
		}
		
		private function removeInstrument(id:String):void {
			delete instrumentDictionary[id]; 
		}		
		
		/**returns existing instrument if its already added*/
		public function addNewInstrument(id:String, callee:Object):Instrument{
			var inst:Instrument = new Instrument();
			addInstrument(id, inst);
			inst = getInstrument(id);
			inst.addSubscriber(callee);
			return getInstrument(id);
		}
		
		public function getInstrument(id:String):Instrument {
			return instrumentDictionary[id];
		}
		
		public function getInstrumentNames():Vector.<String> {
			var a:Vector.<String> = new Vector.<String>();
			for (var key:Object in instrumentDictionary) {
				a.push(key);
			}
			return a;
		}
		
		
	}
}