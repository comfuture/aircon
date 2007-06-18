package maroo.net.irc
{
	public class IRCUser
	{
		private var rawnick:String;

		public function IRCUser(nick:String)
		{
			rawnick = nick;
		}
		
		public function get nick():String
		{
			return rawnick;
		}
		
		public function get op():Boolean
		{
			return rawnick.indexOf('@') > -1;
		}
		
		public function set op(value:Boolean):void
		{
			
		}
		
		public function get voice():Boolean
		{
			return rawnick.indexOf('+') > -1;
		}
	}
}