package org.shinyheaven.uiframe.mdi
{
	import mx.core.IVisualElement;

	public class MDIController
	{
		public function MDIController()
		{
			
		}
		
		public var mdi:MDI;
		
		public function addDocument(element:IVisualElement):DocumentHolder {
			ShinyHeaven.logger.info("MDIController.addDocument");
			return mdi.addDocument(element);
		}
		
		public function dockDocument(element:IVisualElement, direction:int = 1):DocumentHolder {
			ShinyHeaven.logger.info("MDIController.dockDocument: direction={0}", direction);
			return mdi.dockDocument(element, direction);
		}
		
		public function removeDocument(element:IVisualElement):void {
			ShinyHeaven.logger.info("MDIController.removeDocument");
			mdi.removeDocument(element);
		}
		
		public function addCloseListener(element:IVisualElement, callback:Function):void {
			ShinyHeaven.logger.info("MDIController.addCloseListener");
			mdi.addCloseListener(element, callback);
		}
	}
}