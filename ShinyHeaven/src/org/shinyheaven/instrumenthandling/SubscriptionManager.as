package org.shinyheaven.instrumenthandling
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;

	public class SubscriptionManager
	{
		[Inject]
		public var instrumentManager:InstrumentManager; 
		
		private var subscriptionsDictionary:Dictionary = new Dictionary();
		
		public static var ignoreRemovalFromStage:Boolean = false;
		
		public function SubscriptionManager()
		{
		}
				
		/** *
		 * @attributes propField: the prop to bind dataprovider.
		 ** */
		public function addSubscription(instrumentId:String, object:Object, propField:String, objectCanListenToMore:Boolean = false):void {
			ShinyHeaven.logger.info("SubscriptionManager: addSubscription id:{0}", instrumentId)
			var dictObj:ArrayCollection = subscriptionsDictionary[object] as ArrayCollection;
			
			if(dictObj == null) {
				subscriptionsDictionary[object] = new ArrayCollection();
				dictObj = subscriptionsDictionary[object];
			}
			
			if(objectCanListenToMore == false && dictObj.length > 0) {
				removeSubscription(dictObj.getItemAt(0) as String, object);
			}

			dictObj.addItem(instrumentId);
			
			var inst:Instrument = instrumentManager.addNewInstrument(instrumentId, object)
			BindingUtils.bindProperty(object, "dataProvider", inst.chartDataProvider, "data");
			
			if(object is DisplayObject) {
				(object as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
		}
		
		protected function onRemovedFromStage(event:Event):void
		{
			if( ignoreRemovalFromStage == false ){
				removeAllSubscriptions(event.currentTarget)
			}
		}		
		
		public function removeSubscription(instrumentId:String, object:Object):void {
			ShinyHeaven.logger.info("SubscriptionManager: removeSubscription id:{0}", instrumentId)
			instrumentManager.unsubscribe(instrumentId, object);
		}
		
		public function removeAllSubscriptions(object:Object):void {
			var dictObj:ArrayCollection = subscriptionsDictionary[object] as ArrayCollection;
			for each (var s:String in dictObj) {
				removeSubscription(s, object);
			}
			delete subscriptionsDictionary[object];
		}
		
		
	}
}