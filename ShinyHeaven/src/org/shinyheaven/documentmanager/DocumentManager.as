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
    import org.shinyheaven.instrumenthandling.SubscriptionManager;
    import org.shinyheaven.news.INewsDataProvider;
    import org.shinyheaven.news.NewsDisplay;
    import org.shinyheaven.uiframe.adddocument.AddDocumentDialog;
    import org.shinyheaven.uiframe.adddocument.AddDocumentFinishedMsg;
    import org.shinyheaven.uiframe.adddocument.AddDocumentPopupClosedMsg;
    import org.shinyheaven.uiframe.adddocument.CenterAddDocumentDialogMsg;
    import org.shinyheaven.uiframe.controlbar.AddDocumentMsg;
    import org.shinyheaven.uiframe.mdi.MDIController;

    public class DocumentManager {
		[Inject]
		public var addDocumentDialog:AddDocumentDialog;
		[Inject]
		public var mdi:MDIController;
		[Inject]
		public var subscriptionManager:SubscriptionManager;
        [Inject]
        public var newsDataProvider:INewsDataProvider;
		
        [MessageDispatcher]
        public var dispatcher:Function;

		[MessageHandler]
        public function onAddDocument(message:AddDocumentMsg):void {
            PopUpManager.addPopUp(addDocumentDialog, FlexGlobals.topLevelApplication as DisplayObject, true);
            onCenterAddDocumentDialog(null);
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

        [MessageHandler]
        public function onAddDocumentFinished(message:AddDocumentFinishedMsg):void {
            ShinyHeaven.logger.info("addDocumentFinished instrument={0} viewVariant={1}", message.selectedInstrument, message.selectedVariant);
            var selectedClass:Class = message.selectedVariant;
            var view:UIComponent = new selectedClass();
            view.percentWidth = 100;
            view.percentHeight = 100;
            switch (selectedClass) {
                case LineChart: {
                    view.setStyle("skinClass", DefaultLineChartSkin);
                    subscriptionManager.addSubscription(message.selectedInstrument, view, "dataProvider");
                    break;
                }
                case NewsDisplay: {
                    BindingUtils.bindProperty(newsDataProvider, "data", view, "dataProvider");
                    break;
                }
                default: {
                    subscriptionManager.addSubscription(message.selectedInstrument, view, "dataProvider");
                    break;
                }
            }
            mdi.addDocument(view);
        }
    }
}
