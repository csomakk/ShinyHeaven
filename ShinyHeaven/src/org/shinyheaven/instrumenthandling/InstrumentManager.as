package org.shinyheaven.instrumenthandling
{
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	import org.shinyheaven.service.CommunicationModule;

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
				ShinyHeaven.logger.info("InstrumentManager: addInstrument id:{0}", id)
				instrumentDictionary[id] = instrument;
				comm.lookupRequest(id);
			}
		}
		
		public function unsubscribe(id:String, callee:Object):void {
			var inst:Instrument = instrumentDictionary[id];
			ShinyHeaven.logger.info("InstrumentManager: unsubscribe id:{0}", id)
			if(inst != null) {
				inst.removeSubscriber(callee);
				if(inst.hasSubscribers() == false) {
					removeInstrument(id);
				}
			}
		}
		
		private function removeInstrument(id:String):void {
			ShinyHeaven.logger.info("InstrumentManager: removeInstrument id:{0}", id)
			delete instrumentDictionary[id]; 
		}		
		
		/**returns existing instrument if its already added*/
		public function addNewInstrument(id:String, callee:Object):Instrument {
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