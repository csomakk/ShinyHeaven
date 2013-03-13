/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 3/13/13
 * Time: 12:31 PM
 */
package org.shinyheaven.common {
    /**
     * RGB-to-uint color utility class.
     */
    public class ShinyColorUtil {
        public function ShinyColorUtil() {
            throw new Error("Don't instantiate a utility class!");
        }

        public static function fromRGB(red:uint, green:uint, blue:uint):uint {
            return ((modulo256(red) << 16) | (modulo256(green) << 8) | (modulo256(blue)));
        }

        public static function modulo256(value:uint):uint {
            return value % 0x100;
        }
    }
}
