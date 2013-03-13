/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/13/13
 * Time: 12:31 PM
 */
package org.shinyheaven.common {
    /**
     * Convert a red/green/blue triplet to a color {@link uint}.
     */
    public function colorFromRGB(red:uint, green:uint, blue:uint):uint {
        var modulo256:Function = function(value:uint):uint { return value % 0x100; };
        return ((modulo256(red) << 16) | (modulo256(green) << 8) | modulo256(blue));
    }
}
