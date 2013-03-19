/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 7:30 PM
 */
package org.shinyheaven.uiframe.adddocument {
    import flash.events.Event;

    import mx.events.ValidationResultEvent;

    import org.shinyheaven.service.AvailableInstrumentsDataProvider;

    import spark.components.ButtonBar;
    import spark.components.ComboBox;
    import spark.components.TitleWindow;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.validators.NumberValidator;

    [SkinState("instrument")]
    [SkinState("variant")]
    public class AddDocumentDialog extends SkinnableComponent {
        [SkinPart(required=true)]
        public var popupWindow:TitleWindow;
        [SkinPart(required=true)]
        public var comboBox:ComboBox;
        [SkinPart(required=true)]
        public var comboBoxValidator:NumberValidator;
        [SkinPart(required=true)]
        public var styleButtonBar:ButtonBar;
        [SkinPart(required=true)]
        public var styleButtonBarValidator:NumberValidator;

		[Inject]
		public var arrayOfInstruments:AvailableInstrumentsDataProvider;

        [MessageDispatcher]
        public var dispatcher:Function;

        public function AddDocumentDialog() {
            super();
            setStyle("skinClass", AddDocumentDialogSkin);
        }

        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);
            switch (instance) {
                case popupWindow: {
                    popupWindow.addEventListener(Event.CLOSE, onCloseWindow);
                    break;
                }
                case comboBoxValidator: {
                    comboBoxValidator.addEventListener(ValidationResultEvent.VALID, onInstrumentValid);
                    break;
                }
				case comboBox: {
					comboBox.dataProvider = arrayOfInstruments;
					break;
				}
                case styleButtonBarValidator: {
                    styleButtonBarValidator.addEventListener(ValidationResultEvent.VALID, onVariantValid);
                    break;
                }
            }
        }

        protected function onCloseWindow(event:Event):void {
            dispatcher(new AddDocumentPopupClosedMsg());
        }

        private var selectedInstrument:String;

        protected function onInstrumentValid(event:ValidationResultEvent):void {
            selectedInstrument = comboBox.selectedItem as String;
            skin.setCurrentState("variant");
            dispatcher(new CenterAddDocumentDialogMsg());
        }

        private var selectedVariant:Class;

        protected function onVariantValid(event:ValidationResultEvent):void {
            selectedVariant = styleButtonBar.selectedItem.variant;
            dispatcher(new AddDocumentPopupClosedMsg());
            finishAdd();
        }

        private function finishAdd():void {
            dispatcher(new AddDocumentFinishedMsg(selectedInstrument, selectedVariant));
        }
    }
}
