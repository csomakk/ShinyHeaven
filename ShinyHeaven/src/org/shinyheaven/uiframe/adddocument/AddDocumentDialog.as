/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 7:30 PM
 */
package org.shinyheaven.uiframe.adddocument {
    import flash.events.MouseEvent;

    import org.shinyheaven.service.AvailableInstrumentsDataProvider;

    import spark.components.Button;
    import spark.components.ButtonBar;
    import spark.components.ComboBox;
    import spark.components.supportClasses.SkinnableComponent;

    [SkinState("instrument")]
    [SkinState("variant")]
    public class AddDocumentDialog extends SkinnableComponent {
        [SkinPart(required=true)]
        public var comboBox:ComboBox;
        [SkinPart(required=true)]
        public var nextButton:Button;
        [SkinPart(required=true)]
        public var styleButtonBar:ButtonBar;
        [SkinPart(required=true)]
        public var finishButton:Button;

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
                case nextButton: {
                    nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
                    break;
                }
				case comboBox: {
					comboBox.dataProvider = arrayOfInstruments;
					break;
				}
                case finishButton: {
                    finishButton.addEventListener(MouseEvent.CLICK, onFinishClick);
                    break;
                }
            }
        }

        protected function onNextClick(event:MouseEvent):void {
            trace("hej da", dispatcher);
            setCurrentState("variant");
        }

        protected function onFinishClick(event:MouseEvent):void {
            trace("hej san", dispatcher);
        }
    }
}
