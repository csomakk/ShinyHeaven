package org.shinyheaven.instrumenthandling 
{
	import flexunit.framework.Assert;
	
	public class InstrumentTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
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
		public function testHasSubscribers():void
		{
			Assert.assertTrue(true);
		}
	}
}