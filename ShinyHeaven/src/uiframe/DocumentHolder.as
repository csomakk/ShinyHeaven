package uiframe
{
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.core.IVisualElement;
	
	import spark.components.Panel;
	
	public class DocumentHolder extends Panel
	{
		
		private var closeBtn:Button;
		
		public var dockedDirection:int = 0;
		
		private var _element:IVisualElement;
		
		public function DocumentHolder()
		{
			super();
			closeBtn = new Button();
			closeBtn.label = "x";
			closeBtn.right = 3;
			closeBtn.top = -27;
			closeBtn.width = 25;
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseClick);
			addElement(closeBtn);
		}
		
		protected function onCloseClick(event:MouseEvent):void
		{
			(parent as MDI).removeDocument(_element);
		}
		
		public function get element():IVisualElement
		{
			return _element;
		}
		
		public function set element(value:IVisualElement):void
		{
			_element = value;
			addElement(_element);
		}
	}
}