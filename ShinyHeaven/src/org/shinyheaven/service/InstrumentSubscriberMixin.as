import flash.events.Event;

import mx.binding.utils.BindingUtils;
import mx.core.FlexGlobals;

import org.shinyheaven.service.Instrument;

/**
 * This is a mixin. This might very well be not the best way to solve this problem (another idea would be a common superclass)...
 *
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/7/13
 * Time: 2:41 PM
 */
private var InstrumentSubscriberMixin_subscribed:String;

public function subscribeToInstrument(id:String):void {
    if (InstrumentSubscriberMixin_subscribed != null) {
        unsubscribeFromInstrument();
    }
    InstrumentSubscriberMixin_subscribed = id;
    var instrument:Instrument = FlexGlobals.topLevelApplication.instrumentManager.addNewInstrument(id, this);
    BindingUtils.bindProperty(this, "dataProvider", instrument.chartDataProvider, "data");

    addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
}

protected function onRemovedFromStage(event:Event):void {
    unsubscribeFromInstrument();
    removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
}

public function unsubscribeFromInstrument():void {
    FlexGlobals.topLevelApplication.instrumentManager.unsubscribe(InstrumentSubscriberMixin_subscribed, this);
}
