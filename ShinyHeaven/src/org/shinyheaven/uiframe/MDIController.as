package org.shinyheaven.uiframe
{
	import mx.core.IVisualElement;

	public class MDIController
	{
		public function MDIController()
		{
			
		}
		
		public var mdi:MDI;
		
		public function addDocument(element:IVisualElement):DocumentHolder {
			return mdi.addDocument(element);
		}
		
		public function dockDocument(element:IVisualElement, direction:int = 1):DocumentHolder {
			return mdi.dockDocument(element, direction);
		}
		
		public function removeDocument(element:IVisualElement):void {
			mdi.removeDocument(element);
		}
		
		public function addCloseListener(element:IVisualElement, callback:Function):void {
			mdi.addCloseListener(element, callback);
		}
	}
}