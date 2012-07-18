package kr.studio321.geom
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import kr.studio321.util.MathUtil;
	import kr.studio321.util.PointUtil;
	
	/**
	 * 이차 베지어 곡선을 정의합니다
	 * @author 0xABCDEF
	 */
	public class QuadBezier implements ISegment
	{
		/**
		 * 시작점입니다. 
		 * @default 
		 */
		public var s:Point;
		/**
		 * 조절점입니다.
		 * @default 
		 */
		public var c:Point;
		/**
		 * 끝점입니다.
		 * @default 
		 */
		public var e:Point;
		
		/**
		 * 이차베지어 곡선을 생성합니다. 
		 * @param sx 시작점의 x값입니다.
		 * @param sy 시작점의 y값입니다.
		 * @param cx 조절점의 x값입니다.
		 * @param cy 조절점의 y값입니다.
		 * @param ex 끝점의 x값입니다.
		 * @param ey 끝점의 y값입니다.
		 */
		public function QuadBezier( sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number )
		{
			s = new Point( sx, sy );
			c = new Point( cx, cy );
			e = new Point( ex, ey );
		}
		
		/**
		 * 모든 점들을 반환합니다.
		 * @return 선분을 이루는 점들의 집합입니다.
		 */
		public function getPoints():Vector.<Point>
		{
			return new <Point>[ s, c, e ];
		}
		
		/**
		 * 접선벡터를 반환합니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 접선벡터를 반환합니다.
		 */
		public function tangent( t:Number ):Point
		{
			return new Point( 2*( t*( s.y + e.y - 2*c.y ) - s.y + c.y ), 2*( t*( s.x + e.x - 2*c.x ) - s.x + c.x ) );
		}
		
		/**
		 * target에다가 t에 해당하는 값을 집어넣고 그 순간의 각도( 라디안 )를 반환합니다.
		 * @param target 값이 들어갈 점입니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 각도( 라디안 )입니다.
		 */
		public function process( target:Point, t:Number ):Number
		{
			var tt:Number = 1-t;
			target.x = tt*tt*s.x+2*tt*t*c.x+t*t*e.x;
			target.y = tt*tt*s.y+2*tt*t*c.y+t*t*e.y;
			return Math.atan2( 2*( t*( s.y + e.y - 2*c.y ) - s.y + c.y ), 2*( t*( s.x + e.x - 2*c.x ) - s.x + c.x ) );
		}
		
		/**
		 * 이 선분의 구간을 반환합니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 * @return 이 선분의 구간입니다.
		 */
		public function section( start:Number, end:Number ):ISegment
		{
			// 수정필요
			var s:Point = new Point;
			var e:Point = new Point;
			process( s, start );
			process( e, end );
			if( start == end ) return new Linear( s.x, s.y, e.x, e.y );
			var l:Function = MathUtil.linear;
			var l1:Linear = new Linear( l( s.x, c.x, start ), l( s.y, c.y, start ), l( c.x, e.x, start ), l( c.y, e.y, start ) );
			var l2:Linear = new Linear( l( s.x, c.x, end ), l( s.y, c.y, end ), l( c.x, e.x, end ), l( c.y, e.y, end ) );
			var c:Point = new Point;
			l1.intersection( l2, c );
			if( PointUtil.isFlat3( this.s, this.c, this.e ) )
			{
				return new Linear( s.x, s.y, e.x, e.y );
			}
			return new QuadBezier( s.x, s.y, c.x, c.y, e.x, e.y );
		}
		
		/**
		 * target에다가 t에 해당하는 그림을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param t 0~1 사이의 값입니다.
		 */
		public function processOnGraphics( target:Graphics, t:Number ):void
		{
			var cx:Number = MathUtil.linear( s.x, c.x, t );
			var cy:Number = MathUtil.linear( s.x, c.y, t );
			var ex:Number = MathUtil.bezier( [ s.x, c.x, e.x ], t );
			var ey:Number = MathUtil.bezier( [ s.y, c.y, e.y ], t );
			target.moveTo( s.x, s.y );
			target.curveTo( cx, cy, ex, ey );
		}
		
		/**
		 * 이 선분을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 */
		public function drawOnGraphics( target:Graphics ):void
		{
			target.moveTo( s.x, s.y );
			target.curveTo( c.x, c.y, e.x, e.y );
		}
		
		/**
		 * 이 선분의 구간을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 */
		public function sectionOnGraphics( target:Graphics, start:Number, end:Number ):void
		{
			// 수정필요
			if( start == end ) return;
			var l:Function = MathUtil.linear;
			var l1:Linear = new Linear( l( s.x, c.x, start ), l( s.y, c.y, start ), l( c.x, e.x, start ), l( c.y, e.y, start ) );
			var l2:Linear = new Linear( l( s.x, c.x, end ), l( s.y, c.y, end ), l( c.x, e.x, end ), l( c.y, e.y, end ) );
			var s:Point = new Point;
			var c:Point = new Point;
			l1.intersection( l2, c );
			var e:Point = new Point;
			process( s, start );
			process( e, end );
			if( PointUtil.isFlat3( this.s, this.c, this.e ) )
			{
				target.moveTo( s.x, s.y );
				target.lineTo( e.x, e.y );
				return;
			}
			target.moveTo( s.x, s.y );
			target.curveTo( c.x, c.y, e.x, e.y );
		}
		
	}
}