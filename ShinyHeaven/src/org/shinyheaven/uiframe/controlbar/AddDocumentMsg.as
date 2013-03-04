/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/4/13
 * Time: 1:21 PM
 */
package org.shinyheaven.uiframe.controlbar {
    import flash.display.DisplayObjectContainer;

    public class AddDocumentMsg {
        private var _container:DisplayObjectContainer;

        public function AddDocumentMsg(container:DisplayObjectContainer) {
            _container = container;
        }

        public function get container():DisplayObjectContainer {
            return _container;
        }
    }
}
