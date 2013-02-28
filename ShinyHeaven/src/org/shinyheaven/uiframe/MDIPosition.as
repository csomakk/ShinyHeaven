/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 2/27/13
 * Time: 3:13 PM
 */
package org.shinyheaven.uiframe {
    import mx.utils.StringUtil;

    public class MDIPosition {
        public var alignParent:MDIAlignParent;
        public var weight:uint = 100;
        public var rest:Boolean = false;

        private static const REST_RE:RegExp = /^rest\s*:\s*/i;
        private static const XTIMES_RE:RegExp = /^(\d+)x\s+/i;

        public function MDIPosition(input:String) {
            if (REST_RE.test(input)) rest = true;
            var trimmed:Array = input.replace(REST_RE, "").split(/\s+/);
            if (trimmed.length > 0) alignParent = MDIAlignParent.parse(trimmed[0]);
            if (trimmed.length > 1) weight = uint(trimmed[1].replace(/\s*%$/, ""));
        }

        /**
         * This can parse MDI child position descriptions, in the following format:
         * @param input for example "left 20%, 3x bottom, rest: topright 10%"
         * @return a {@link Vector} containing the parsed {@link MDIPosition}s
         */
        public static function parseList(input:String):Vector.<MDIPosition> {
            var result:Vector.<MDIPosition> = new Vector.<MDIPosition>();
            for each (var e:String in input.split(/\s*,\s*/).map(function(f:String, ... rest):String { return StringUtil.trim(f); })) {
                var h:uint = 1;
                if (XTIMES_RE.test(e)) h = uint(e.match(XTIMES_RE)[1]);
                var g:String = e.replace(XTIMES_RE, "");
                for (var i:uint = 0; i < h; i++) {
                    result.push(new MDIPosition(g));
                }
            }
            return result;
        }

        public function get direction():int {
            if (alignParent.isTop()) return MDI.TOP;
            if (alignParent.isBottom()) return MDI.BOTTOM;
            if (alignParent.isRight()) return MDI.RIGHT;
            if (alignParent.isLeft()) return MDI.LEFT;
            return MDI.UNDOCKED;
        }

        internal function get directionAsString():String {
            switch (direction) {
                case MDI.TOP: {
                    return "TOP";
                    break;
                }
                case MDI.BOTTOM: {
                    return "BOTTOM";
                    break;
                }
                case MDI.RIGHT: {
                    return "RIGHT";
                    break;
                }
                case MDI.LEFT: {
                    return "LEFT";
                    break;
                }
            }
            return "";
        }

        public function toString():String {
            return StringUtil.substitute("<MDIPosition alignParent={0} weight={1} rest={2}/>", directionAsString, weight, rest);
        }
    }
}
