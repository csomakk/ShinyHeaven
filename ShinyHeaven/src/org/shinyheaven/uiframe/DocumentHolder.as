package org.shinyheaven.uiframe
{
    import flash.events.MouseEvent;
    import flash.geom.Point;

    import mx.controls.Button;
    import mx.core.IVisualElement;

    import spark.components.Panel;

    public class DocumentHolder extends Panel
	{
		
		private var closeBtn:Button;
		
		private var _dockedDirection:int = 0;
		
		private var _element:IVisualElement;
		
		private var resizer:Button = new Button();
		
		private var originalRightBottom:Point;
		
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
			resizer.addEventListener(MouseEvent.MOUSE_DOWN, resizerOnMouseDown);
		}
		
		protected function resizerOnMouseDown(event:MouseEvent):void
		{
			originalRightBottom = new Point(x + width, y+height);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resizeOnMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, resizeMouseUp);
		}
		
		protected function resizeMouseUp(event:MouseEvent):void
		{
			resizeOnMouseMove(event);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizeOnMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, resizeMouseUp);
			(parent as MDI).arrangeUnDocked();
		}
		
		protected function resizeOnMouseMove(event:MouseEvent):void
		{
			switch(dockedDirection)
			{
				case MDI.LEFT:
				{
					width = globalToLocal(new Point(event.stageX, event.stageY)).x;
					break;
				}
				case MDI.RIGHT:
				{
					x = event.stageX
					width = originalRightBottom.x - x;
					break;
				}
				case MDI.TOP:
				{
					height = globalToLocal(new Point(event.stageX, event.stageY)).y;
					break;
				}
				case MDI.BOTTOM:
				{
					y = event.stageY
					height = originalRightBottom.y - y;
					break;
				}
			}
			
		}
		
		public function get dockedDirection():int
		{
			return _dockedDirection;
		}

		public function set dockedDirection(value:int):void
		{
			_dockedDirection = value;
			addElement(resizer);
			
			resizer.right = NaN;
			resizer.left = NaN;
			resizer.top = NaN;
			resizer.bottom = NaN;
			
			switch(value)
			{
				case MDI.LEFT:
				{
					resizer.right = 0;
					resizer.width = 5;
					resizer.top = 0;
					resizer.bottom = 0;
					break;
				}
				case MDI.RIGHT:
				{
					resizer.left = 0;
					resizer.width = 5;
					resizer.top = 0;
					resizer.bottom = 0;
					break;
				}
				case MDI.TOP:
				{
					resizer.right = 0;
					resizer.left = 0;
					resizer.bottom = 0;
					resizer.height = 5;
					break;
				}
				case MDI.BOTTOM:
				{
					resizer.right = 0;
					resizer.left = 0;
					resizer.top = 0;
					resizer.height = 5;
					break;
				}
					
				default:
				{
					removeElement(resizer);
					break;
				}
			}
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