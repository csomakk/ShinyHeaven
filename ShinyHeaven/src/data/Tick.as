package data
{
   
    [RemoteClass(alias='org.postabank.data.Tick')]
    public class Tick
    {
        [Bindable]
        public var timestamp : String;
        [Bindable]
        public var open	: Number;
        [Bindable]
        public var low	: Number;
        [Bindable]
        public var high	: Number;
        [Bindable]
        public var close : Number;
        [Bindable]
        public var volume : Number;
        
        public function Tick()
        {
            super();
        }
        
        public function toString():String {
            return "Tick Object: " + timestamp + open + " " + low + " " + high + " " + close + " " + volume;
        }
        
    }
}