/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 2/28/13
 * Time: 3:13 PM
 */
package org.shinyheaven.uiframe {
    import mx.utils.StringUtil;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class MDIPositionTest {
        [Test]
        public function testParseList():void {
            var result:Vector.<MDIPosition> = MDIPosition.parseList(" \ttop  50%   ,right 75 %\t,  rest :botTOMlEft");
            assertTrue(result[0].alignParent.isTop());
            assertEquals(result[0].weight, 50);
            assertFalse(result[0].rest);
            assertTrue(result[1].alignParent.isRight());
            assertEquals(result[1].weight, 75);
            assertFalse(result[1].rest);
            assertTrue(result[2].alignParent.isBottom());
            assertTrue(result[2].alignParent.isLeft());
            assertEquals(result[2].weight, 100);
            assertTrue(result[2].rest);
        }
    }
}
