/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/7/13
 * Time: 11:52 AM
 */
package org.shinyheaven.datavisualization.datagrid {
    import mx.collections.IList;

    import org.shinyheaven.service.IInstrumentWatcher;

    import spark.components.DataGrid;
    import spark.components.supportClasses.SkinnableComponent;

    public class InstrumentGrid extends SkinnableComponent implements IInstrumentWatcher {
        [SkinPart(required=true)]
        public var dataGrid:DataGrid;

        public function InstrumentGrid() {
            super();
            setStyle("skinClass", InstrumentGridSkin);
        }

        private var _dataProvider:IList;

        public function set dataProvider(value:IList):void {
            _dataProvider = value;
        }

        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);
            switch (instance) {
                case dataGrid: {
                    dataGrid.dataProvider = _dataProvider;
                    break;
                }
            }
        }

        include "../../service/InstrumentSubscriberMixin.as";
    }
}
