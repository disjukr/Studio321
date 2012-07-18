package kr.studio321.util
{
	import flash.geom.Point;

	/**
	 * 점 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class PointUtil
	{
		/**
		 * 점을 회전시켜줍니다.
		 * @param target 회전시킬 점입니다.
		 * @param angle 회전할 각도( 라디안 )입니다.
		 * @param centerX 회전할 중심점의 x값입니다.
		 * @param centerY 회전할 중심점의 y값입니다.
		 */
		public static function rotate( target:Point, angle:Number, centerX:Number = 0, centerY:Number = 0 ):void
		{
			var zeroX:Number = ( target.x-centerX );
			var zeroY:Number = ( target.y-centerY );
			target.x = zeroX*Math.cos( angle ) + zeroY*-Math.sin( angle ) + centerX;
			target.y = zeroX*Math.sin( angle ) + zeroY*Math.cos( angle ) + centerY;
		}
		
		/**
		 * 점을 뒤집어(?)줍니다.
		 * @param target 대상 점입니다.
		 * @param centerX 회전할 중심점의 x값입니다.
		 * @param centerY 회전할 중심점의 y값입니다.
		 * @return 대상 점을 중심점을 기준으로 180도 회전시킨 점을 반환합니다. 원본은 수정되지 않습니다.
		 */
		public static function reverse( target:Point, centerX:Number = 0, centerY:Number = 0 ):Point
		{
			return new Point( centerX-target.x+centerX, centerY-target.y+centerY );
		}
		
		/**
		 * 세 점이 한 직선에 포함되는지 여부를 반환합니다.
		 * @param a Point 객체입니다.
		 * @param b Point 객체입니다.
		 * @param c Point 객체입니다.
		 * @return 편평하면 true, 굽어있으면 false.
		 */
		public static function isFlat3( a:Point, b:Point, c:Point ):Boolean
		{
			var fx:Number = b.x-a.x;
			var fy:Number = b.y-a.y;
			var gx:Number = c.x-b.x;
			var gy:Number = c.y-b.y;
			var i:Number = fy*fx;
			var j:Number = gy*gx;
			if( !i )if( !j ) return ( fx==gx )||( fy==gy );
			return i == j;
		}
		
		/**
		 * 네 점이 한 직선에 포함되는지 여부를 반환합니다.
		 * @param a Point 객체입니다.
		 * @param b Point 객체입니다.
		 * @param c Point 객체입니다.
		 * @param d Point 객체입니다.
		 * @return 편평하면 true, 굽어있으면 false.
		 */
		public static function isFlat4( a:Point, b:Point, c:Point, d:Point ):Boolean
		{
			return isFlat3( a, b, c ) && isFlat3( b, c, d );
		}
		
	}
}