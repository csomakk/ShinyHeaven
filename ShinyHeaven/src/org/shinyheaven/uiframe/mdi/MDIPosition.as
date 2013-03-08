/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 2/27/13
 * Time: 3:13 PM
 */
package org.shinyheaven.uiframe.mdi {
    import mx.utils.StringUtil;

    public class MDIPosition {
        public var alignParent:MDIAlignParent;
        public var weight:uint = 100;
        public var rest:Boolean = false;

        private static const REST_REGEXP:RegExp = /^rest\s*:\s*/i;
        private static const XTIMES_REGEXP:RegExp = /^(\d+)x\s+/i;

        public function MDIPosition(input:String) {
            if (REST_REGEXP.test(input)) rest = true;
            var trimmed:Array = input.replace(REST_REGEXP, "").split(/\s+/);
            if (trimmed.length > 0) alignParent = MDIAlignParent.parse(trimmed[0]);
            if (trimmed.length > 1) weight = uint(trimmed[1].replace(/\s*%$/, ""));
        }

        /**
         * This parses MDI child position descriptions.
         * @param input String
         * @return a {@link Vector} containing the parsed {@link MDIPosition}s
         */
        public static function parseList(input:String):Vector.<MDIPosition> {
            var result:Vector.<MDIPosition> = new Vector.<MDIPosition>();
            var repeatCount:uint;

            for each (var e:String in input.split(/\s*,\s*/).map(function(f:String, ... _):String { return StringUtil.trim(f); })) {
                if (XTIMES_REGEXP.test(e)) {
                    repeatCount = uint(e.match(XTIMES_REGEXP)[1]);
                } else {
                    repeatCount = 1;
                }

                var expression:String = e.replace(XTIMES_REGEXP, "");

                for (var i:uint = 0; i < repeatCount; i++) {
                    result.push(new MDIPosition(expression));
                }
            }
            return result;
        }

        public function get direction():int {
            if (alignParent.isTop())    return MDI.TOP;
            if (alignParent.isBottom()) return MDI.BOTTOM;
            if (alignParent.isRight())  return MDI.RIGHT;
            if (alignParent.isLeft())   return MDI.LEFT;
            return MDI.UNDOCKED;
        }

        public function toString():String {
            return StringUtil.substitute("<MDIPosition alignParent={0} weight={1} rest={2}/>", alignParent.toString(), weight, rest);
        }

        public static function getRest(_positions:Vector.<MDIPosition>):MDIPosition {
            for each (var e:MDIPosition in _positions) if (e.rest) return e;
            return new MDIPosition("rest: undocked");
        }
    }
}
