package maroo.events
{
	import flash.events.Event;

	public class IRCEvent extends Event
	{
		public static const CONNECT:String = 'connect';
		public static const DATA:String = 'data';
		public static const NOTICE:String = 'notice';
		public static const JOIN:String = 'join';
		public static const PART:String = 'part';
		public static const NICK:String = 'nick';
		public static const MESSAGE:String = 'part';
		public static const SEND:String = 'part';
		public static const RAW:String = 'raw';

		private var _data:Object;

		public function IRCEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void {}
	}
}