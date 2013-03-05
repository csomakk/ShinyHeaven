/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 7:05 PM
 */
package org.shinyheaven.uiframe.controlbar {
    import flash.events.MouseEvent;

    import spark.components.Button;
    import spark.components.supportClasses.SkinnableComponent;

    public class AddDocumentButton extends SkinnableComponent {
        [SkinPart(required=true)]
        public var button:Button;

        [MessageDispatcher]
        public var dispatcher:Function;

        public function AddDocumentButton() {
            super();
            setStyle("skinClass", AddDocumentButtonSkin);
        }

        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);
            switch (instance) {
                case button: {
                    button.addEventListener(MouseEvent.CLICK, onButtonClick);
                    break;
                }
            }
        }

        protected function onButtonClick(event:MouseEvent):void {
            dispatcher(new AddDocumentMsg());
        }
    }
}
