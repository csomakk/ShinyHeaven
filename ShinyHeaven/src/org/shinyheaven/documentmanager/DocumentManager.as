/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 2:01 PM
 */
package org.shinyheaven.documentmanager {
    import mx.managers.PopUpManager;

    import org.shinyheaven.uiframe.adddocument.AddDocumentPopup;
    import org.shinyheaven.uiframe.adddocument.AddDocumentPopupClosed;
    import org.shinyheaven.uiframe.controlbar.AddDocumentMsg;

    /**
     * Singleton.
     */
    public class DocumentManager {
        [Inject]
        public var addDocumentPopup:AddDocumentPopup;

        [MessageHandler]
        public function onAddDocument(message:AddDocumentMsg):void {
            PopUpManager.addPopUp(addDocumentPopup, message.container, true);
            //context.viewManager.addViewRoot(popup as DisplayObject);
            PopUpManager.centerPopUp(addDocumentPopup);
        }

        [MessageHandler]
        public function onAddDocumentPopupClosed(message:AddDocumentPopupClosed):void {
            PopUpManager.removePopUp(message.popup);
            //context.viewManager.removeViewRoot(message.popup);
        }
    }
}
