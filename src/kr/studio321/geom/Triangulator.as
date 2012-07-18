package kr.studio321.geom
{
	import flash.geom.Point;

	/**
	 * 삼각화를 처리하는 클래스입니다.
	 * http://www.flipcode.com/archives/triangulate.cpp 이 코드를 AS3으로 포팅하였습니다.
	 * @author 0xABCDEF
	 */
	public class Triangulator
	{
		private static const EPSILON:Number = 0.0000000001;
		private var _contour:Vector.<Point>;
		private var _triangles:Vector.<Triangle>;
		
		/**
		 * 삼각화 객체를 생성합니다.
		 * @param contour 삼각화 하고자 하는 도형( 윤곽선 )입니다.
		 */
		public function Triangulator( contour:Vector.<Point> = null )
		{
			this.contour = contour;
		}
		
		/**
		 * @return 삼각화를 처리하고자 하는 도형입니다.
		 */
		public function get contour():Vector.<Point>
		{
			return _contour;
		}
		
		/**
		 * @param value 처음에 들어오는 점과 끝에 들어오는 점이 같을 필요는 없습니다.
		 */
		public function set contour( value:Vector.<Point> ):void
		{
			_contour = value;
			if( value ) process();
		}
		
		/**
		 * 삼각화가 처리된 결과입니다.
		 * @return 삼각형들이 들어있습니다. 입력값이 적절하지 않을 경우 null을 반환합니다.
		 */
		public function get triangles():Vector.<Triangle>
		{
			return _triangles;
		}
		
		private function area():Number
		{
			var n:int = _contour.length;
			var A:Number = 0;
			for( var p:int=n-1, q:int=0; q<n; p=q++ )
			{
				A += _contour[ p ].x*_contour[ q ].y - _contour[ q ].x*_contour[ p ].y;
			}
			return A*0.5;
		}
		
		private function snip( u:int, v:int, w:int, n:int, V:Vector.<int> ):Boolean
		{
			var Ax:Number = _contour[ V[ u ] ].x;
			var Ay:Number = _contour[ V[ u ] ].y;
			var Bx:Number = _contour[ V[ v ] ].x;
			var By:Number = _contour[ V[ v ] ].y;
			var Cx:Number = _contour[ V[ w ] ].x;
			var Cy:Number = _contour[ V[ w ] ].y;
			if( EPSILON > (((Bx-Ax)*(Cy-Ay))-((By-Ay)*(Cx-Ax))) ) return false;
			var P:Point;
			var T:Triangle;
			for( var p:int=0; p<n; ++p )
			{
				if( (p==u)||(p==v)||(p==w) ) continue;
				P = new Point( _contour[ V[ p ] ].x, _contour[ V[ p ] ].y );
				T = new Triangle( Ax, Ay, Bx, By, Cx, Cy );
				if( T.haveCW( P ) ) return false;
			}
			return true;
		}
		
		private function process():void
		{
			_triangles = new Vector.<Triangle>;
			
			var n:int = _contour.length;
			if( n<3 )
			{
				_triangles = null;
				return;
			}
			var V:Vector.<int> = new Vector.<int>( n, true );
			var v:int;
			if( 0<area() ) for( v=0; v<n; ++v ) V[ v ] = v;
			else for( v=0; v<n; ++v ) V[ v ] = ( n-1 )-v;
			var nv:int = n;
			var count:int = 2*nv;
			v = nv-1;
			var u:int, w:int;
			var a:Point, b:Point, c:Point;
			var s:int, t:int;
			while( nv>2 )
			{
				if( count-- <= 0 )
				{
					_triangles = null;
					return;
				}
				u = v; if( nv<=u ) u=0;
				v = u+1; if( nv<=v ) v=0;
				w = v+1; if( nv<=w ) w=0;
				if( snip( u, v, w, nv, V ) )
				{
					a = _contour[ V[ u ] ];
					b = _contour[ V[ v ] ];
					c = _contour[ V[ w ] ];
					_triangles.push( new Triangle( a.x, a.y, b.x, b.y, c.x, c.y ) );
					for( s=v, t=v+1; t<nv; V[ s++ ] = V[ t++ ] ) continue;
					--nv;
					count = 2*nv;
				}
			}
			V = null;
		}
		
	}
}