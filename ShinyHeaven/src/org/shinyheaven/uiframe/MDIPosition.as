/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 2/27/13
 * Time: 3:13 PM
 */
package org.shinyheaven.uiframe {
    import mx.utils.StringUtil;
    import mx.utils.StringUtil;

    import org.spicefactory.lib.collection.List;
    import org.spicefactory.lib.collection.MultiMap;

    public class MDIPosition {
        public var alignParent:MDIAlignParent;
        public var weight:uint = 100;
        public var rest:Boolean = false;

        private static const REST_RE:RegExp = /^rest\s*:\s*/i;

        public function MDIPosition(input:String) {
            if (REST_RE.test(input)) rest = true;
            var trimmed:Array = input.replace(REST_RE, "").split(/\s+/);
            alignParent = MDIAlignParent.parse(trimmed[0]);
            if (trimmed.length > 1) weight = uint(trimmed[1].replace(/\s*%$/, ""));
        }

        /**
         * This can parse MDI child position descriptions, in the following format:
         * @param input for example "left 20%, bottom 25%, rest: topright"
         * @return a {@link Vector} containing the parsed {@link MDIPosition}s
         */
        public static function parseList(input:String):Vector.<MDIPosition> {
            var result:Vector.<MDIPosition> = new Vector.<MDIPosition>();
            for each (var e:String in input.split(/\s*,\s*/).map(function(f:String, ... rest):String { return StringUtil.trim(f); })) {
                result.push(new MDIPosition(e));
                trace(StringUtil.substitute("e: <{0}>", e));
            }
            return result;
        }
    }
}
