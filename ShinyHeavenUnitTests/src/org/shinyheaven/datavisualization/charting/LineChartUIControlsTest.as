package org.shinyheaven.datavisualization.charting
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.shinyheaven.datavisualization.charting.events.UserControlEvent;
	import org.shinyheaven.datavisualization.charting.skins.ChartControls;

	public class LineChartUIControlsTest
	{		

		private var controlPanel:LineChartUIControls;
		
		[Before(async, ui)]
		public function setUp():void
		{
			controlPanel = new LineChartUIControls();
			Async.proceedOnEvent(this, controlPanel, FlexEvent.CREATION_COMPLETE);
			UIImpersonator.addChild(controlPanel);
		}
		
		[After]
		public function tearDown():void
		{
			UIImpersonator.removeChild(controlPanel);
			controlPanel = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function checkSkinPartsInClosedState():void
		{
			assertNull(controlPanel.isMovingAverage);
			assertNull(controlPanel.movingAvrgWindow);
		}
		
		[Test]
		public function isMovingAvrgEnabled_DefaultValueCheck():void
		{
			assertFalse(controlPanel.isMovingAvrgEnabled);
		}
		
		[Test]
		public function isMovingAvrgEnabled_UserSetedValueCheck():void
		{
			openChartControlPanel();
			(controlPanel.skin as ChartControls).isMovingAverage.selected = true;
			assertTrue(controlPanel.isMovingAvrgEnabled);
		}
		
		[Test]
		public function avrgWindow_DefaultValueCheck():void
		{
			assertEquals(controlPanel.avrgWindow, 20);
		}
		
		[Test]
		public function avrgWindow_UserSetedValueCheck():void
		{
			openChartControlPanel();
			(controlPanel.skin as ChartControls).movingAvrgWindow.value = 30;
			assertEquals(controlPanel.avrgWindow, 30);
		}
		
		[Test]
		public function checkSkinPartsInOpenedState():void
		{
			openChartControlPanel();
			
			assertNotNull(controlPanel.isMovingAverage);
			assertNotNull(controlPanel.movingAvrgWindow);
		}
		
		[Test(async)]
		public function movingAverageChangedEvent():void
		{
			openChartControlPanel();
			
			Async.proceedOnEvent(this, controlPanel, UserControlEvent.MOVING_AVERAGE_CHANGED, 500);
			(controlPanel.skin as ChartControls).movingAvrgWindow.dispatchEvent(new Event(Event.CHANGE));
			
			Async.proceedOnEvent(this, controlPanel, UserControlEvent.MOVING_AVERAGE_CHANGED, 500);
			(controlPanel.skin as ChartControls).isMovingAverage.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function openChartControlPanel():void
		{
			controlPanel.skin.currentState = ChartControls.STATE_OPENED;
		}
	}
}