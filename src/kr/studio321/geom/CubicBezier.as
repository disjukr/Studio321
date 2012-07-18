package kr.studio321.geom
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import kr.studio321.util.GraphicsUtil;
	import kr.studio321.util.MathUtil;
	import kr.studio321.util.PointUtil;
	
	/**
	 * 큐빅베지어 곡선을 정의합니다.
	 * @author 0xABCDEF
	 */
	public class CubicBezier implements ISegment
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
		public var c1:Point;
		/**
		 * 조절점입니다.
		 * @default 
		 */
		public var c2:Point;
		/**
		 * 끝점입니다.
		 * @default 
		 */
		public var e:Point;
		
		/**
		 * 큐빅베지어 곡선을 생성합니다.
		 * @param sx 시작점의 x값입니다.
		 * @param sy 시작점의 y값입니다.
		 * @param c1x 조절점의 x값입니다.
		 * @param c1y 조절점의 y값입니다.
		 * @param c2x 조절점의 x값입니다.
		 * @param c2y 조절점의 y값입니다.
		 * @param ex 끝점의 x값입니다.
		 * @param ey 끝점의 y값입니다.
		 */
		public function CubicBezier( sx:Number, sy:Number, c1x:Number, c1y:Number, c2x:Number, c2y:Number, ex:Number, ey:Number )
		{
			s = new Point( sx, sy );
			c1 = new Point( c1x, c1y );
			c2 = new Point( c2x, c2y );
			e = new Point( ex, ey );
		}
		
		/**
		 * 모든 점들을 반환합니다.
		 * @return 큐빅베지어 곡선을 이루는 점들의 집합입니다.
		 */
		public function getPoints():Vector.<Point>
		{
			return new <Point>[ s, c1, c2, e ];
		}
		
		/**
		 * 접선벡터를 반환합니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 접선벡터를 반환합니다.
		 */
		public function tangent( t:Number ):Point
		{
			return new Point( 3*( e.x-s.x-3*c2.x+3*c1.x )*t*t + 6*( s.x+c2.x-2*c1.x )*t - 3*s.x+3*c1.x, 3*( e.y-s.y-3*c2.y+3*c1.y )*t*t + 6*( s.y+c2.y-2*c1.y )*t - 3*s.y+3*c1.y );
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
			target.x = tt*tt*tt*s.x+3*tt*tt*t*c1.x+3*tt*t*t*c2.x+t*t*t*e.x;
			target.y = tt*tt*tt*s.y+3*tt*tt*t*c1.y+3*tt*t*t*c2.y+t*t*t*e.y;
			return Math.atan2( 3*( e.y-s.y-3*c2.y+3*c1.y )*t*t + 6*( s.y+c2.y-2*c1.y )*t - 3*s.y+3*c1.y, 3*( e.x-s.x-3*c2.x+3*c1.x )*t*t + 6*( s.x+c2.x-2*c1.x )*t - 3*s.x+3*c1.x );
		}
		
		/**
		 * 이 선분의 구간을 반환합니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 * @return 이 선분의 구간입니다.
		 */
		public function section( start:Number, end:Number ):ISegment
		{
			// written by codeonwort ( http://codeonwort.tistory.com/ )
			var s:Point = new Point
			var e:Point = new Point
			process(s, start)
			process(e, end)
			
			var temp1:Point = new Point
			var temp2:Point = new Point
			process(temp1, (start + end) * .5)
			process(temp2, .75 * start + .25 * end)
			
			var B1:Point = new Point(
				32/3 * temp2.x - 4 * temp1.x - 4 * s.x + 1/3 * e.x,
				32/3 * temp2.y - 4 * temp1.y - 4 * s.y + 1/3 * e.y)
			
			var B2:Point = new Point(
				8 * temp1.x - s.x - e.x - B1.x,
				8 * temp1.y - s.y - e.y - B1.y)
			
			B1.x /= 3, B1.y /= 3
			B2.x /= 3, B2.y /= 3
			return new CubicBezier( s.x, s.y, B1.x, B1.y, B2.x, B2.y, e.x, e.y );
		}
		
		/**
		 * target에다가 t에 해당하는 그림을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param t 0~1 사이의 값입니다.
		 */
		public function processOnGraphics( target:Graphics, t:Number ):void
		{
			var c1x:Number = MathUtil.linear( s.x, c1.x, t );
			var c1y:Number = MathUtil.linear( s.y, c1.y, t );
			var cx:Number = MathUtil.linear( c1.x, c2.x, t );
			var cy:Number = MathUtil.linear( c1.y, c2.y, t );
			var c2x:Number = MathUtil.linear( c1x, cx, t );
			var c2y:Number = MathUtil.linear( c1y, cy, t );
			var ex:Number = MathUtil.bezier( [ s.x, c1.x, c2.x, e.x ], t );
			var ey:Number = MathUtil.bezier( [ s.y, c1.y, c2.y, e.y ], t );
			GraphicsUtil.bezierCurve( target, [ s, { x:c1x, y:c1y }, { x:c2x, y:c2y }, { x:ex, y:ey } ], 0 );
		}
		
		/**
		 * 이 선분을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 */
		public function drawOnGraphics( target:Graphics ):void
		{
			GraphicsUtil.bezierCurve( target, [ s, c1, c2, e ], 0 );
		}
		
		/**
		 * 이 선분의 구간을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 */
		public function sectionOnGraphics( target:Graphics, start:Number, end:Number ):void
		{
			// written by codeonwort ( http://codeonwort.tistory.com/ )
			var s:Point = new Point
			var e:Point = new Point
			process(s, start)
			process(e, end)
			
			var temp1:Point = new Point
			var temp2:Point = new Point
			process(temp1, (start + end) * .5)
			process(temp2, .75 * start + .25 * end)
			
			var B1:Point = new Point(
				32/3 * temp2.x - 4 * temp1.x - 4 * s.x + 1/3 * e.x,
				32/3 * temp2.y - 4 * temp1.y - 4 * s.y + 1/3 * e.y)
			
			var B2:Point = new Point(
				8 * temp1.x - s.x - e.x - B1.x,
				8 * temp1.y - s.y - e.y - B1.y)
			
			B1.x /= 3, B1.y /= 3
			B2.x /= 3, B2.y /= 3
			GraphicsUtil.bezierCurve( target, [ s, B1, B2, e ], 0 );
		}
		
	}
}