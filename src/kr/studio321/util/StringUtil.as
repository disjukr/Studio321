package kr.studio321.util
{
	/**
	 * 문자열 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class StringUtil
	{
		/**
		 * 후치사의 형태를 알려줍니다.
		 * @param noun 명사입니다.
		 * @return "케로로"를 집어넣으면 true를 반환하고 "건담"을 집어넣으면 false를 반환합니다. true가 반환되었을 때 후치사는 가, 를의 형태가 되고 false가 반환되었을 때 후치사는 이가, 을의 형태가 됩니다.
		 */
		public static function postpositionType( noun:String ):Boolean
		{
			var token:uint = noun.charCodeAt( noun.length-1 )-44032;
			if( token%28 == 0 ) return true;
			return false;
		}
		
		/**
		 * 문자열의 공백을 제거합니다.
		 * @param text 공백을 제거할 문자열입니다.
		 * @return 공백이 제거된 문자열입니다.
		 */
		public static function removeWhiteSpace( text:String ):String
		{
			var result:String = text;
			result = result.split( " " ).join( "" );
			result = result.split( "\t" ).join( "" );
			result = result.split( "\n" ).join( "" );
			result = result.split( "\r" ).join( "" );
			return result;
		}
		
	}
}