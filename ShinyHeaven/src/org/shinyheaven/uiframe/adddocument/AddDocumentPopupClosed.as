/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 2:42 PM
 */
package org.shinyheaven.uiframe.adddocument {
    import mx.core.IFlexDisplayObject;

    public class AddDocumentPopupClosed {
        private var _popup:IFlexDisplayObject;

        public function AddDocumentPopupClosed(popup:IFlexDisplayObject) {
            _popup = popup;
        }

        public function get popup():IFlexDisplayObject {
            return _popup;
        }
    }
}
