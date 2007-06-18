package maroo.net.irc
{
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import mx.utils.StringUtil;
	import maroo.events.IRCEvent;

	/**
	 * IRC (Internet Relay Chat) Client library written by ActionScript 3
	 * 
	 * @author 거친마루 <comfuture@gmail.com>
	 * @license BSD Style License
	 */
	public class IRCClient extends Socket
	{
		public var nick:String;

		private var _connected:Boolean;
		private var readBuffer:String = '';
		private var _server:IRCServer;

		public function IRCClient(server:IRCServer=null, nick:String=null)
		{
			this.server = server;
			this.nick = nick;
		}
		
		/*
		[Bindable]
		public function get connected():Boolean
		{
			return _connected;
		}
		public function set connected(value:Boolean):void {}
		*/
		public function get server():IRCServer
		{
			return _server;
		}
		
		public function set server(value:IRCServer):void
		{
			this._server = value;
			this.Connect(value);
		}
		
		public function Connect(server:IRCServer):void
		{
			this._server = server;
			addEventListener(Event.CONNECT, onConnect);
			addEventListener(ProgressEvent.SOCKET_DATA, onData);
			super.connect(server.host, server.port);
		}
		
		private function onConnect(event:Event):void
		{
			if (nick != null) {
				register(new IRCUser(nick));
			}
		}
		
		private function onData(event:ProgressEvent):void
		{
			if (server.encoding == 'utf-8') {
				readBuffer += readUTFBytes(bytesAvailable);	
			} else {
				readBuffer += readMultiByte(bytesAvailable, server.encoding);
			}
			var idx:int = -1;
			while((idx = readBuffer.indexOf("\r\n")) != -1){
				process(readBuffer.substring(0, idx));
				readBuffer = readBuffer.substr(idx+2);
			}
		}
		
		public function register(user:IRCUser):void
		{
			write(new IRCMessage('USER', StringUtil.substitute('{0} {1} {2} :{3}@aIRC', 
				'air.irc', 'air.irc', 'air.irc', 'air.irc')));
			write(new IRCMessage('NICK', user.nick));
		}
		
		private function process(line:String):void
		{
			trace('<<< ' + line);
			if (line.indexOf('PING') == 0) {
				write(new IRCMessage('PONG', line.split(' ').pop()));
			}

			line = StringUtil.trim(line);
			
			/*
		     * From RFC 1459:
			 *  <message>  ::= [':' <prefix> <SPACE> ] <command> <params> <crlf>
			 *  <prefix>   ::= <servername> | <nick> [ '!' <user> ] [ '@' <host> ]
			 *  <command>  ::= <letter> { <letter> } | <number> <number> <number>
			 *  <SPACE>    ::= ' ' { ' ' }
			 *  <params>   ::= <SPACE> [ ':' <trailing> | <middle> <params> ]
			 *  <middle>   ::= <Any *non-empty* sequence of octets not including SPACE
			 *                 or NUL or CR or LF, the first of which may not be ':'>
			 *  <trailing> ::= <Any, possibly *empty*, sequence of octets not including
			 *                   NUL or CR or LF>
			*/
			
			if(line.charAt(0) == ':') {
				var re1:RegExp = new RegExp("[ @!]");
				var prefix:String = line.split(re1)[0].substring(1);
				line = line.substring(line.indexOf(" ") + 1);
			}
			
			//parse commande / code
			var cmd:String;
		 	cmd = line.split(" ", 1)[0];
		 	line = line.substring(line.indexOf(" ") + 1);
		 	if (cmd == "004") {
		 		dispatchEvent(new IRCEvent(IRCEvent.CONNECT));
		 	}
		 
		 	//parse params
		 	var params:Array;
			if(line.indexOf(":") > -1) {
		 		params = line.split(":")[0].split(" ")
				if(params[params.length-1] == "")
		 		params[params.length-1] = line.substring(line.indexOf(":") + 1);
		 		else params = params.concat(line.substring(line.indexOf(":") + 1));
			}
			else {
				params = line.split(" ");
			}
			dispatchEvent(new IRCEvent(IRCEvent.MESSAGE, {
				'prefix': prefix, 'cmd': cmd, 'params': params
			}));
		}
		
		public function write(message:IRCMessage):void
		{
			trace('>>> ' + message.toString());
			if (server.encoding == 'utf-8') {
				writeUTFBytes(message.toString());
			} else {
				writeMultiByte(message.toString(), server.encoding);
			}
			flush();
		}
	}
}