/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 2:42 PM
 */
package org.shinyheaven.uiframe.adddocument {
    public class AddDocumentPopupClosed {
        private var _popup:AddDocumentPopup;

        public function AddDocumentPopupClosed(popup:AddDocumentPopup) {
            _popup = popup;
        }

        public function get popup():AddDocumentPopup {
            return _popup;
        }
    }
}
