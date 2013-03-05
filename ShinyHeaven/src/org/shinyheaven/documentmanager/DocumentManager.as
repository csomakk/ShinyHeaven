/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 2:01 PM
 */
package org.shinyheaven.documentmanager {
    import flash.display.DisplayObject;

    import mx.core.FlexGlobals;
    import mx.managers.PopUpManager;

    import org.shinyheaven.uiframe.adddocument.AddDocumentDialog;
    import org.shinyheaven.uiframe.adddocument.AddDocumentFinishedMsg;
    import org.shinyheaven.uiframe.adddocument.AddDocumentPopupClosedMsg;
    import org.shinyheaven.uiframe.controlbar.AddDocumentMsg;

    public class DocumentManager {
		[Inject]
		public var addDocumentDialog:AddDocumentDialog;
		
		[MessageHandler]
        public function onAddDocument(message:AddDocumentMsg):void {
            PopUpManager.addPopUp(addDocumentDialog, FlexGlobals.topLevelApplication as DisplayObject, true);
            PopUpManager.centerPopUp(addDocumentDialog);
        }

        [MessageHandler]
        public function onAddDocumentPopupClosed(message:AddDocumentPopupClosedMsg):void {
            PopUpManager.removePopUp(addDocumentDialog);
            addDocumentDialog.skin.setCurrentState("instrument");
        }

        [MessageHandler]
        public function onAddDocumentFinished(message:AddDocumentFinishedMsg):void {
            ShinyHeaven.logger.info("addDocumentFinished", message.selectedInstrument, message.selectedVariant);
        }
    }
}
