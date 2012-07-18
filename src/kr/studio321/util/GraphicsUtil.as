package kr.studio321.util
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * 그림 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class GraphicsUtil
	{	
		/**
		 * 베지어 곡선을 그려줍니다.
		 * @param graphics 그려질 대상입니다.
		 * @param points 베지어 곡선 조절점들이 들어있는 배열입니다.
		 * @param precision 얼마나 정교하게 그릴지를 결정합니다. 0~1 사이의 값이 들어갑니다. 0에 가까울 수록 정교하게 그려지며, 0일 경우에는 선의 길이에 따라 적당히 조절해서 그려주게 됩니다.
		 */
		public static function bezierCurve( graphics:Graphics, points:Array, precision:Number = 0 ):void
		{
			if( points.length < 2 ) return;
			var step:Number;
			var i:int;
			var limit:int;
			if( precision<=1 && precision>0 )
			{
				step = precision;
			} else {
				var lengths:Number = 0;
				limit = points.length-1;
				for( i = 0; i<limit; ++i )
				{
					var xx:Number = points[ i+1 ].x - points[ i ].x;
					var yy:Number = points[ i+1 ].y - points[ i ].y;
					lengths += Math.sqrt( xx*xx + yy*yy );
				}
				step = 5/lengths;
			}
			graphics.moveTo( points[ 0 ].x, points[ 0 ].y );
			limit = points.length;
			var xs:Array = new Array;
			var ys:Array = new Array;
			for( i = 0; i < limit; ++i )
			{
				xs.push( points[ i ].x );
				ys.push( points[ i ].y );
			}
			for( var j:Number = 0; j<=1; j+=step )
			{
				graphics.lineTo( MathUtil.bezier( xs, j ), MathUtil.bezier( ys, j ) );
			}
			graphics.lineTo( MathUtil.bezier( xs, 1 ), MathUtil.bezier( ys, 1 ) );
		}
		
		/**
		 * 달을 그려줍니다.
		 * @param graphics 그려질 대상입니다.
		 * @param x 달의 x위치입니다.
		 * @param y 달의 y위치입니다.
		 * @param radius 달의 반경입니다.
		 * @param progress 달의 모양을 결정합니다. 0.5에 가까울 수록 보름달이 됩니다. 0~1 사이의 값을 집어넣으면 됩니다.
		 * @param rotation 달의 회전값입니다.
		 */
		public static function drawMoon( graphics:Graphics, x:Number, y:Number, radius:Number, progress:Number=0.5, rotation:Number=0 ):void
		{
			var i:int;
			var r:Number = radius;
			progress = Math.max( Math.min( progress, 1 ), 0 );
			var up:Point = new Point( 0, -r );
			var down:Point = new Point( 0, r );
			var rights:Array = [
				new Point( Math.tan( Math.PI/8 )*r, -r ),
				new Point( Math.sin( Math.PI/4 )*r, -Math.sin( Math.PI/4 )*r ),
				new Point( r, -Math.tan( Math.PI/8 )*r ),
				new Point( r, 0 ),
				new Point( r, Math.tan( Math.PI/8 )*r ),
				new Point( Math.sin( Math.PI/4 )*r, Math.sin( Math.PI/4 )*r ),
				new Point( Math.tan( Math.PI/8 )*r, r )
			];
			var lefts:Array = [
				new Point( -Math.tan( Math.PI/8 )*r, -r ),
				new Point( -Math.sin( Math.PI/4 )*r, -Math.sin( Math.PI/4 )*r ),
				new Point( -r, -Math.tan( Math.PI/8 )*r ),
				new Point( -r, 0 ),
				new Point( -r, Math.tan( Math.PI/8 )*r ),
				new Point( -Math.sin( Math.PI/4 )*r, Math.sin( Math.PI/4 )*r ),
				new Point( -Math.tan( Math.PI/8 )*r, r )
			];
			PointUtil.rotate( up, rotation );
			PointUtil.rotate( down, rotation );
			if( progress < 0.5 )
			{
				for( i=0; i<7; ++i )
				{
					lefts[ i ].x = MathUtil.linear( rights[ i ].x, lefts[ i ].x, progress*2 );
				}
			}
			if( progress > 0.5 )
			{
				for( i=0; i<7; ++i )
				{
					rights[ i ].x = MathUtil.linear( rights[ i ].x, lefts[ i ].x, ( progress-0.5 )*2 );
				}
			}
			for( i=0; i<7; ++i )
			{
				PointUtil.rotate( rights[ i ], rotation );
				PointUtil.rotate( lefts[ i ], rotation );
			}
			graphics.moveTo( up.x + x, up.y + y );
			graphics.curveTo( rights[ 0 ].x + x, rights[ 0 ].y + y, rights[ 1 ].x + x, rights[ 1 ].y + y );
			graphics.curveTo( rights[ 2 ].x + x, rights[ 2 ].y + y, rights[ 3 ].x + x, rights[ 3 ].y + y );
			graphics.curveTo( rights[ 4 ].x + x, rights[ 4 ].y + y, rights[ 5 ].x + x, rights[ 5 ].y + y );
			graphics.curveTo( rights[ 6 ].x + x, rights[ 6 ].y + y, down.x + x, down.y + y );
			graphics.curveTo( lefts[ 6 ].x + x, lefts[ 6 ].y + y, lefts[ 5 ].x + x, lefts[ 5 ].y + y );
			graphics.curveTo( lefts[ 4 ].x + x, lefts[ 4 ].y + y, lefts[ 3 ].x + x, lefts[ 3 ].y + y );
			graphics.curveTo( lefts[ 2 ].x + x, lefts[ 2 ].y + y, lefts[ 1 ].x + x, lefts[ 1 ].y + y );
			graphics.curveTo( lefts[ 0 ].x + x, lefts[ 0 ].y + y, up.x + x, up.y + y );
		}
	}
}