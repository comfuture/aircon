package maroo.net.irc
{
	public class IRCServer
	{
		public var host:String;
		public var port:uint = 6667;
		public var encoding:String;
		
		public function IRCServer(host:String, port:uint, encoding:String='utf-8')
		{
			this.host = host;
			this.port = port;
			this.encoding = encoding;
		}
	}
}