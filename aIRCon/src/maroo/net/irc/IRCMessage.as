package maroo.net.irc
{
	public class IRCMessage
	{
		public static const PRIVMSG:String = 'PRIVMSG';
		public static const PING:String = 'PING';

		public var type:String;
		public var message:String;
		
		public function IRCMessage(type:String='privmsg', message:String='')
		{
			this.type = type;
			this.message = message;
		}
		
		public function toString():String
		{
			return type + ' ' + message + "\r\n";
		}
		
		public function format():String
		{
			switch (type) {
				case PRIVMSG:
					var m:Array = message.split(' ', 2);
					return '<font color="#0000FF">' + '&lt;' + m[0] + '&gt;' + '</font>' + m[1] + '\n';
				case PING:
					return '<font color="#FF0000">' + type + '</font>' + message + '\n';
				default:
					return '<font color="#00FF00">' + type + '</font>' + message + '\n';
			}
		}
	}
}