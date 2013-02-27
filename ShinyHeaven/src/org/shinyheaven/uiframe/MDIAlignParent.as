/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 2/27/13
 * Time: 3:15 PM
 */
package org.shinyheaven.uiframe {
    import mx.utils.StringUtil;

    public class MDIAlignParent {
        private var _top:Boolean;
        private var _bottom:Boolean;
        private var _left:Boolean;
        private var _right:Boolean;

        public static function parse(input:String):MDIAlignParent {
            var result:MDIAlignParent = new MDIAlignParent();
            if (/^top/i.test(input)) result._top = true;
            if (/^bottom/i.test(input)) result._bottom = true;
            if (/right$/i.test(input)) result._right = true;
            if (/left$/i.test(input)) result._left = true;
            return result;
        }

        public function isTop():Boolean {
            return _top;
        }

        public function isTopRight():Boolean {
            return _top && _right;
        }

        public function isRight():Boolean {
            return _right;
        }

        public function isBottomRight():Boolean {
            return _bottom && _right;
        }

        public function isBottom():Boolean {
            return _bottom;
        }

        public function isBottomLeft():Boolean {
            return _bottom && _left;
        }

        public function isLeft():Boolean {
            return _left;
        }

        public function isTopLeft():Boolean {
            return _top && _left;
        }

        public function toString():String {
            return StringUtil.substitute("top:{0} right:{1} bottom:{2} left:{3}", _top, _right, _bottom, _left);
        }
    }
}
