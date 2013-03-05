/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/5/13
 * Time: 6:28 PM
 */
package org.shinyheaven.uiframe.adddocument {
    public class AddDocumentFinishedMsg {
        public var selectedInstrument:String;
        public var selectedVariant:int;

        public function AddDocumentFinishedMsg(selectedInstrument:String, selectedVariant:int) {
            this.selectedInstrument = selectedInstrument;
            this.selectedVariant = selectedVariant;
        }
    }
}
