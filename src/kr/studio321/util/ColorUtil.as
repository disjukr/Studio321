package kr.studio321.util
{
	/**
	 * 색상 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class ColorUtil
	{
		/**
		 * 두 색을 선형보간합니다.
		 * @param a 섞을 색상입니다. w값이 0이면 a가 반환됩니다.
		 * @param b 섞을 색상입니다. w값이 1이면 b가 반환됩니다.
		 * @param w 가중치입니다.
		 * @return 선형보간된 색을 반환합니다.
		 */
		public static function interpolate( a:uint, b:uint, w:Number ):uint
		{
			var ca:uint = MathUtil.linear( a>>24&0xFF, b>>24&0xFF, w )<<24;
			var cr:uint = MathUtil.linear( a>>16&0xFF, b>>16&0xFF, w )<<16;
			var cg:uint = MathUtil.linear( a>>8&0xFF, b>>8&0xFF, w )<<8;
			var cb:uint = MathUtil.linear( a&0xFF, b&0xFF, w );
			return ca|cr|cg|cb;
		}
		
		/**
		 * RGB 색상공간의 보색을 구합니다.
		 * @param rgb 보색을 구할 색입니다.
		 * @return 가산혼합의 보색을 구합니다.
		 */
		public static function rgbComplementary( rgb:uint ):uint
		{
			return 0xFFFFFF-rgb;
		}
		
	}
}