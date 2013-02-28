/**
 * Created with IntelliJ IDEA.
 * User: Peter_Varga
 * Date: 2/28/13
 * Time: 3:15 PM
 */
package org.shinyheaven.uiframe {
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class MDIAlignParentTest {
        [Test]
        public function testParse():void {
            var result:MDIAlignParent = MDIAlignParent.parse("tOpriGHt");
            assertTrue(result.isTop());
            assertTrue(result.isRight());
            assertFalse(result.isBottom());
        }
    }
}
