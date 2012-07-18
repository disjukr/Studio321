package kr.studio321.geom
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * 리니어 선분을 정의합니다.
	 * @author 0xABCDEF
	 */
	public class Linear implements ISegment
	{
		/**
		 * 시작점입니다.
		 * @default 
		 */
		public var s:Point;
		/**
		 * 끝점입니다.
		 * @default 
		 */
		public var e:Point;
		
		/**
		 * 선분을 생성합니다.
		 * @param sx 시작점의 x값입니다.
		 * @param sy 시작점의 y값입니다.
		 * @param ex 끝점의 x값입니다.
		 * @param ey 끝점의 y값입니다.
		 */
		public function Linear( sx:Number, sy:Number, ex:Number, ey:Number )
		{
			s = new Point( sx, sy );
			e = new Point( ex, ey );
		}
		
		/**
		 * 두 Point 객체를 잇는 Linear 객체를 생성합니다.
		 * @param s 시작점입니다.
		 * @param e 끝점입니다.
		 * @return 두 점을 잇는 선분입니다.
		 */
		public static function bridge( s:Point, e:Point ):Linear
		{
			var result:Linear = new Linear( 0, 0, 0, 0 );
			result.s = s;
			result.e = e;
			return result;
		}
		
		/**
		 * 교점을 찾아줍니다.
		 * @param target 교차하는 선분입니다.
		 * @param result 구해진 교차점이 들어갈 Point 객체입니다.
		 * @return 교차 여부를 반환합니다. 실제로 교차하지 않았을 경우( 직선의 교차점이 구해진 경우 ) false를 반환합니다.
		 */
		public function intersection( target:Linear, result:Point ):Boolean
		{
			var a:Point = s;
			var b:Point = e;
			var c:Point = target.s;
			var d:Point = target.e;
			var t:Number = ( ( a.y-c.y ) * ( d.x-c.x )-( a.x-c.x )*( d.y-c.y ) )/( ( b.x-a.x )*( d.y-c.y )-( b.y-a.y )*( d.x-c.x ) );
			process( result, t );
			if( t<0 || 1<t ) return false;
			return true;
		}
		
		/**
		 * 이 직선(?)에서 특정한 y위치와 매칭되는 x위치를 반환합니다.
		 * @param y 원하는 위치입니다.
		 * @return 집어넣은 값과 매칭되는 x위치입니다.
		 */
		public function x( y:Number ):Number
		{
			if( s.y == e.y ) return Number.POSITIVE_INFINITY;
			if( s.x == e.x ) return s.x;
			var a:Number = ( e.x-s.x )/( e.y-s.y );
			return a*( y-s.y )+s.x;
		}
		
		/**
		 * 이 직선(?)에서 특정한 x위치와 매칭되는 y위치를 반환합니다.
		 * @param x 원하는 위치입니다.
		 * @return 집어넣은 값과 매칭되는 y위치입니다.
		 */
		public function y( x:Number ):Number
		{
			if( s.x == e.x ) return Number.POSITIVE_INFINITY;
			if( s.y == e.y ) return s.y;
			var a:Number = ( e.y-s.y )/( e.x-s.x );
			return a*( x-s.x )+s.y;
		}
		
		/**
		 * 모든 점들을 반환합니다.
		 * @return 선분을 이루는 점들의 집합입니다.
		 */
		public function getPoints():Vector.<Point>
		{
			return new <Point>[ s, e ];
		}
		
		/**
		 * 접선벡터를 반환합니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 접선벡터를 반환합니다.
		 */
		public function tangent( t:Number ):Point
		{
			return new Point( e.y-s.y, e.x-s.x );
		}
		
		/**
		 * target에다가 t에 해당하는 값을 집어넣고 그 순간의 각도( 라디안 )를 반환합니다.
		 * @param target 값이 들어갈 점입니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 각도( 라디안 )입니다.
		 */
		public function process( target:Point, t:Number ):Number
		{
			target.x = s.x + ( e.x-s.x )*t;
			target.y = s.y + ( e.y-s.y )*t;
			return Math.atan2( e.y-s.y, e.x-s.x );
		}
		
		/**
		 * 이 선분의 구간을 반환합니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 * @return 이 선분의 구간입니다.
		 */
		public function section( start:Number, end:Number ):ISegment
		{
			var s:Point = new Point;
			var e:Point = new Point;
			process( s, start );
			process( e, end );
			return new Linear( s.x, s.y, e.x, e.y );
		}
		
		/**
		 * target에다가 t에 해당하는 그림을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param t 0~1 사이의 값입니다.
		 */
		public function processOnGraphics( target:Graphics, t:Number ):void
		{
			target.moveTo( s.x, s.y );
			target.lineTo( s.x + ( e.x-s.x )*t, s.y + ( e.y-s.y )*t );
		}
		
		/**
		 * 이 선분을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 */
		public function drawOnGraphics( target:Graphics ):void
		{
			target.moveTo( s.x, s.y );
			target.lineTo( e.x, e.y );
		}
		
		/**
		 * 이 선분의 구간을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 */
		public function sectionOnGraphics( target:Graphics, start:Number, end:Number ):void
		{
			var s:Point = new Point;
			var e:Point = new Point;
			process( s, start );
			process( e, end );
			target.moveTo( s.x, s.y );
			target.lineTo( e.x, e.y );
		}
		
	}
}