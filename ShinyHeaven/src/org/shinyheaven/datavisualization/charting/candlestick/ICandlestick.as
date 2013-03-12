/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/12/13
 * Time: 5:21 PM
 */
package org.shinyheaven.datavisualization.charting.candlestick {
    public interface ICandlestick {
        function get open():Number;
        function get high():Number;
        function get low():Number;
        function get close():Number;
        function get date():Date;
    }
}
