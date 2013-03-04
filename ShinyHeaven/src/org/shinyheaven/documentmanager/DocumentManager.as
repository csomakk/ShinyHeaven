/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 2:01 PM
 */
package org.shinyheaven.documentmanager {
    import flash.display.DisplayObject;

    import mx.core.FlexGlobals;
    import mx.core.IFlexDisplayObject;
    import mx.managers.PopUpManager;

    import org.shinyheaven.uiframe.adddocument.AddDocumentDialog;
    import org.shinyheaven.uiframe.adddocument.AddDocumentPopupClosed;
    import org.shinyheaven.uiframe.controlbar.AddDocumentMsg;

    public class DocumentManager {
        //[Inject]
        //public var addDocumentPopup:AddDocumentPopup;

        [MessageHandler]
        public function onAddDocument(message:AddDocumentMsg):void {
            var popup:IFlexDisplayObject;
            popup = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, AddDocumentDialog, true);
            PopUpManager.centerPopUp(popup);
            //context.viewManager.addViewRoot(popup as DisplayObject);
        }

        [MessageHandler]
        public function onAddDocumentPopupClosed(message:AddDocumentPopupClosed):void {
            PopUpManager.removePopUp(message.popup);
            //context.viewManager.removeViewRoot(message.popup);
        }
    }
}
