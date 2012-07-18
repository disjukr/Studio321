package kr.studio321.util
{
	/**
	 * Boolean부울 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class BooleanUtil
	{
		/**
		 * nor 연산은 수행한 결과를 반환합니다.
		 * @param x Boolean 객체입니다.
		 * @return 연산을 수행한 결과입니다.
		 */
		public static function not( x:Boolean ):Boolean
		{
			return !x;
		}
		
		/**
		 * and 연산을 수행한 결과를 반환합니다.
		 * @param a Boolean 객체입니다.
		 * @param b Boolean 객체입니다.
		 * @return 연산을 수행한 결과입니다.
		 */
		public static function and( a:Boolean, b:Boolean ):Boolean
		{
			return a&&b;
		}
		
		/**
		 * or 연산을 수행한 결과를 반환합니다.
		 * @param a Boolean 객체입니다.
		 * @param b Boolean 객체입니다.
		 * @return 연산을 수행한 결과입니다.
		 */
		public static function or( a:Boolean, b:Boolean ):Boolean
		{
			return a||b;
		}
		
		/**
		 * nand 연산을 수행한 결과를 반환합니다.
		 * @param a Boolean 객체입니다.
		 * @param b Boolean 객체입니다.
		 * @return 연산을 수행한 결과입니다.
		 */
		public static function nand( a:Boolean, b:Boolean ):Boolean
		{
			return !( a&&b );
		}
		
		/**
		 * nor 연산을 수행한 결과를 반환합니다.
		 * @param a Boolean 객체입니다.
		 * @param b Boolean 객체입니다.
		 * @return 연산을 수행한 결과입니다.
		 */
		public static function nor( a:Boolean, b:Boolean ):Boolean
		{
			return !( a||b );
		}
		
		/**
		 * xand 연산을 수행한 결과를 반환합니다.
		 * @param a Boolean 객체입니다.
		 * @param b Boolean 객체입니다.
		 * @return 연산을 수행한 결과입니다.
		 */
		public static function xand( a:Boolean, b:Boolean ):Boolean
		{
			return a==b;
		}
		
		/**
		 * xor 연산을 수행한 결과를 반환합니다.
		 * @param a Boolean 객체입니다.
		 * @param b Boolean 객체입니다.
		 * @return 연산을 수행한 결과입니다.
		 */
		public static function xor( a:Boolean, b:Boolean ):Boolean
		{
			return a!=b;
		}
		
	}
}