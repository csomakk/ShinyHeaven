/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 2:01 PM
 */
package org.shinyheaven.documentmanager {
    import flash.display.DisplayObject;

    import mx.binding.utils.BindingUtils;
    import mx.core.FlexGlobals;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;

    import org.shinyheaven.datavisualization.charting.LineChart;
    import org.shinyheaven.datavisualization.charting.skins.DefaultLineChartSkin;
    import org.shinyheaven.service.InstrumentManager;
    import org.shinyheaven.service.dto.IChartDataProvider;
    import org.shinyheaven.uiframe.MDIController;
    import org.shinyheaven.uiframe.adddocument.AddDocumentDialog;
    import org.shinyheaven.uiframe.adddocument.AddDocumentFinishedMsg;
    import org.shinyheaven.uiframe.adddocument.AddDocumentPopupClosedMsg;
    import org.shinyheaven.uiframe.adddocument.CenterAddDocumentDialogMsg;
    import org.shinyheaven.uiframe.controlbar.AddDocumentMsg;

    public class DocumentManager {
		[Inject]
		public var addDocumentDialog:AddDocumentDialog;
		[Inject]
		public var mdi:MDIController;
		
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
        public function onCenterAddDocumentDialog(message:CenterAddDocumentDialogMsg):void {
            PopUpManager.centerPopUp(addDocumentDialog);
        }

        [Inject]
        public var instrumentManager:InstrumentManager;

        [MessageHandler]
        public function onAddDocumentFinished(message:AddDocumentFinishedMsg):void {
            ShinyHeaven.logger.info("addDocumentFinished instrument={0} viewVariant={1}", message.selectedInstrument, message.selectedVariant);
            var view:UIComponent = new message.selectedVariant();
            view.percentWidth = 100;
            view.percentHeight = 100;
            if (message.selectedVariant == LineChart) {
                view.setStyle("skinClass", DefaultLineChartSkin);
            }
            var dataProvider:IChartDataProvider = instrumentManager.addNewInstrument(message.selectedInstrument).chartDataProvider;
            BindingUtils.bindProperty(view, "dataProvider", dataProvider, "data");
            mdi.addDocument(view);
        }
    }
}
