package kr.studio321.svg
{
	import flash.geom.Point;
	
	import kr.studio321.geom.CubicBezier;
	import kr.studio321.geom.Linear;
	import kr.studio321.geom.Path;
	import kr.studio321.geom.QuadBezier;
	import kr.studio321.util.ArrayUtil;
	import kr.studio321.util.PointUtil;

	/**
	 * SVG 파일의 외곽선을 추려내어줍니다.
	 * @author 0xABCDEF
	 */
	public class SVGTracer
	{
		/**
		 * 생성자 만들지 마세요.
		 * @throws ArgumentError 만들지 말라니깐.
		 */
		public function SVGTracer()
		{
			throw new ArgumentError( "SVGTracer 클래스는 인스턴스화할 수 없습니다." );
		}
		
		/**
		 * 외곽선을 추립니다. 하지만,
		 * <li>행렬변환을 정의하는 transform 어트리뷰트</li>
		 * <li>원과 타원을 정의하는 circle, elipce 엘리먼트</li>
		 * <li>객체 재사용을 정의하는 defs, use 엘리먼트</li>
		 * <li>rect 엘리먼트의 둥근 모서리를 위한 rx, ry 어트리뷰트</li>
		 * <p>등등을 지원하지 않습니다. ( SVG Tiny 1.2 기준 )</p>
		 * @param 대상 svg객체입니다. 문자열의 형태로 받습니다.
		 * @return 외곽선을 추려낸 결과물입니다.
		 */
		public static function tracePath( svg:String ):Path
		{
			var result:Path = new Path;
			svg = svg.split( /\n|\r|\t/g ).join( "" );
			var xml:XML = new XML( svg );
			e_g( result, xml );
			return result;
		}
		
		private static function e_g( path:Path, node:XML ):void
		{
			var nodeName:String;
			for each( var element:XML in node.children() )
			{
				nodeName = element.localName();
				if( nodeName )
				{
					switch( nodeName )
					{
						case "g" :
							e_g( path, element );
							break;
						case "path" :
							e_path( path, element );
							break;
						case "rect" :
							e_rect( path, element );
							break;
						case "line" :
							e_line( path, element );
							break;
						case "polyline" :
							e_polyline( path, element );
							break;
						case "polygon" :
							e_polygon( path, element );
							break;
						default : break;
					}
				}
			}
		}
		
		private static const M:int = 2;
		private static const Z:int = 0;
		private static const L:int = 2;
		private static const C:int = 6;
		private static const S:int = 4;
		private static const Q:int = 4;
		private static const T:int = 2;
		private static const H:int = 1;
		private static const V:int = 1;
		
		private static function e_path( path:Path, node:XML ):void
		{
			var d:String = node.@d.toString();
			if( d )
			{
				d = d.split( "," ).join( " " );
				d = d.split( "-" ).join( " -" );
				d = d.split( "M" ).join( " M " );
				d = d.split( "m" ).join( " m " );
				d = d.split( "C" ).join( " C " );
				d = d.split( "c" ).join( " c " );
				d = d.split( "S" ).join( " S " );
				d = d.split( "s" ).join( " s " );
				d = d.split( "Q" ).join( " Q " );
				d = d.split( "q" ).join( " q " );
				d = d.split( "T" ).join( " T " );
				d = d.split( "t" ).join( " t " );
				d = d.split( "L" ).join( " L " );
				d = d.split( "l" ).join( " l " );
				d = d.split( "H" ).join( " H " );
				d = d.split( "h" ).join( " h " );
				d = d.split( "V" ).join( " V " );
				d = d.split( "v" ).join( " v " );
				d = d.split( "A" ).join( " A " );
				d = d.split( "a" ).join( " a " );
				d = d.split( /z/gi ).join( " Z " );
				var commandList:Array = d.split( / (?=[MmCcSsQqTtLlHhVvAaZ])/g );
				var command:String;
				var subList:Array;
				var dummyList:Array;
				var pencil:Point = new Point;
				var startPoint:Point = new Point;
				var controlPoint:Point;
				var values:Array;
				var p:Point;
				var p2:Point;
				var p3:Point;
				for( var i:int=0; i<commandList.length; ++i )
				{
					if( commandList[ i ] )
					{
						subList = commandList[ i ].split( " " );
						command = subList[ 0 ];
						dummyList = [];
						for( var j:int=1; j<subList.length; ++j )
						{
							if( subList[ j ] )
							{
								dummyList.push( subList[ j ] );
							}
						}
						values = [];
						p = new Point;
						p2 = new Point;
						p3 = new Point;
						switch( command )
						{
							case "M" :
								values = ArrayUtil.divide( dummyList, M );
								for( j=0; j<values.length; ++j )
								{
									pencil.x = Number( values[ j ][ 0 ] );
									pencil.y = Number( values[ j ][ 1 ] );
									startPoint.x = pencil.x;
									startPoint.y = pencil.y;
								}
								break;
							case "m" :
								values = ArrayUtil.divide( dummyList, M );
								for( j=0; j<values.length; ++j )
								{
									pencil.x = pencil.x + Number( values[ j ][ 0 ] );
									pencil.y = pencil.y + Number( values[ j ][ 1 ] );
									startPoint.x = pencil.x;
									startPoint.y = pencil.y;
								}
								break;
							case "C" :
								values = ArrayUtil.divide( dummyList, C );
								for( j=0; j<values.length; ++j )
								{
									p.x = Number( values[ j ][ 0 ] );
									p.y = Number( values[ j ][ 1 ] );
									p2.x = Number( values[ j ][ 2 ] );
									p2.y = Number( values[ j ][ 3 ] );
									p3.x = Number( values[ j ][ 4 ] );
									p3.y = Number( values[ j ][ 5 ] );
									path.addSegment( new CubicBezier( pencil.x, pencil.y, p.x, p.y, p2.x, p2.y, p3.x, p3.y ) );
									controlPoint = PointUtil.reverse( p2, p3.x, p3.y );
									pencil.x = p3.x;
									pencil.y = p3.y;
								}
								break;
							case "c" :
								values = ArrayUtil.divide( dummyList, C );
								for( j=0; j<values.length; ++j )
								{
									p.x = pencil.x + Number( values[ j ][ 0 ] );
									p.y = pencil.y + Number( values[ j ][ 1 ] );
									p2.x = pencil.x + Number( values[ j ][ 2 ] );
									p2.y = pencil.y + Number( values[ j ][ 3 ] );
									p3.x = pencil.x + Number( values[ j ][ 4 ] );
									p3.y = pencil.y + Number( values[ j ][ 5 ] );
									path.addSegment( new CubicBezier( pencil.x, pencil.y, p.x, p.y, p2.x, p2.y, p3.x, p3.y ) );
									controlPoint = PointUtil.reverse( p2, p3.x, p3.y );
									pencil.x = p3.x;
									pencil.y = p3.y;
								}
								break;
							case "S" :
								values = ArrayUtil.divide( dummyList, S );
								for( j=0; j<values.length; ++j )
								{
									p.x = Number( values[ j ][ 0 ] );
									p.y = Number( values[ j ][ 1 ] );
									p2.x = Number( values[ j ][ 2 ] );
									p2.y = Number( values[ j ][ 3 ] );
									path.addSegment( new CubicBezier( pencil.x, pencil.y, controlPoint.x, controlPoint.y, p.x, p.y, p2.x, p2.y ) );
									controlPoint = PointUtil.reverse( p, p2.x, p2.y );
									pencil.x = p2.x;
									pencil.y = p2.y;
								}
								break;
							case "s" :
								values = ArrayUtil.divide( dummyList, S );
								for( j=0; j<values.length; ++j )
								{
									p.x = pencil.x + Number( values[ j ][ 0 ] );
									p.y = pencil.y + Number( values[ j ][ 1 ] );
									p2.x = pencil.x + Number( values[ j ][ 2 ] );
									p2.y = pencil.y + Number( values[ j ][ 3 ] );
									path.addSegment( new CubicBezier( pencil.x, pencil.y, controlPoint.x, controlPoint.y, p.x, p.y, p2.x, p2.y ) );
									controlPoint = PointUtil.reverse( p, p2.x, p2.y );
									pencil.x = p2.x;
									pencil.y = p2.y;
								}
								break;
							case "Q" :
								values = ArrayUtil.divide( dummyList, Q );
								for( j=0; j<values.length; ++j )
								{
									p.x = Number( values[ j ][ 0 ] );
									p.y = Number( values[ j ][ 1 ] );
									p2.x = Number( values[ j ][ 2 ] );
									p2.y = Number( values[ j ][ 3 ] );
									path.addSegment( new QuadBezier( pencil.x, pencil.y, p.x, p.y, p2.x, p2.y ) );
									controlPoint = PointUtil.reverse( p, p2.x, p2.y );
									pencil.x = p2.x;
									pencil.y = p2.y;
								}
								break;
							case "q" :
								values = ArrayUtil.divide( dummyList, Q );
								for( j=0; j<values.length; ++j )
								{
									p.x = pencil.x + Number( values[ j ][ 0 ] );
									p.y = pencil.y + Number( values[ j ][ 1 ] );
									p2.x = pencil.x + Number( values[ j ][ 2 ] );
									p2.y = pencil.y + Number( values[ j ][ 3 ] );
									path.addSegment( new QuadBezier( pencil.x, pencil.y, p.x, p.y, p2.x, p2.y ) );
									controlPoint = PointUtil.reverse( p, p2.x, p2.y );
									pencil.x = p2.x;
									pencil.y = p2.y;
								}
								break;
							case "T" :
								values = ArrayUtil.divide( dummyList, T );
								for( j=0; j<values.length; ++j )
								{
									p.x = Number( values[ j ][ 0 ] );
									p.y = Number( values[ j ][ 1 ] );
									path.addSegment( new QuadBezier( pencil.x, pencil.y, controlPoint.x, controlPoint.y, p.x, p.y ) );
									controlPoint = PointUtil.reverse( controlPoint, p.x, p.y );
									pencil.x = p.x;
									pencil.y = p.y;
								}
								break;
							case "t" :
								values = ArrayUtil.divide( dummyList, T );
								for( j=0; j<values.length; ++j )
								{
									p.x = pencil.x + Number( values[ j ][ 0 ] );
									p.y = pencil.y + Number( values[ j ][ 1 ] );
									path.addSegment( new QuadBezier( pencil.x, pencil.y, controlPoint.x, controlPoint.y, p.x, p.y ) );
									controlPoint = PointUtil.reverse( controlPoint, p.x, p.y );
									pencil.x = p.x;
									pencil.y = p.y;
								}
								break;
							case "L" :
								values = ArrayUtil.divide( dummyList, L );
								for( j=0; j<values.length; ++j )
								{
									p.x = Number( values[ j ][ 0 ] );
									p.y = Number( values[ j ][ 1 ] );
									path.addSegment( new Linear( pencil.x, pencil.y, p.x, p.y ) );
									pencil.x = p.x;
									pencil.y = p.y;
								}
								break;
							case "l" :
								values = ArrayUtil.divide( dummyList, L );
								for( j=0; j<values.length; ++j )
								{
									p.x = pencil.x + Number( values[ j ][ 0 ] );
									p.y = pencil.y + Number( values[ j ][ 1 ] );
									path.addSegment( new Linear( pencil.x, pencil.y, p.x, p.y ) );
									pencil.x = p.x;
									pencil.y = p.y;
								}
								break;
							case "H" :
								values = ArrayUtil.divide( dummyList, H );
								for( j=0; j<values.length; ++j )
								{
									p.x = Number( values[ j ][ 0 ] );
									path.addSegment( new Linear( pencil.x, pencil.y, p.x, pencil.y ) );
									pencil.x = p.x;
								}
								break;
							case "h" :
								values = ArrayUtil.divide( dummyList, H );
								for( j=0; j<values.length; ++j )
								{
									p.x = pencil.x + Number( values[ j ][ 0 ] );
									path.addSegment( new Linear( pencil.x, pencil.y, p.x, pencil.y ) );
									pencil.x = p.x;
								}
								break;
							case "V" :
								values = ArrayUtil.divide( dummyList, V );
								for( j=0; j<values.length; ++j )
								{
									p.y = Number( values[ j ][ 0 ] );
									path.addSegment( new Linear( pencil.x, pencil.y, pencil.x, p.y ) );
									pencil.y = p.y;
								}
								break;
							case "v" :
								values = ArrayUtil.divide( dummyList, V );
								for( j=0; j<values.length; ++j )
								{
									p.y = pencil.y + Number( values[ j ][ 0 ] );
									path.addSegment( new Linear( pencil.x, pencil.y, pencil.x, p.y ) );
									pencil.y = p.y;
								}
								break;
							case "Z" :
								path.addSegment( new Linear( pencil.x, pencil.y, startPoint.x, startPoint.y ) );
								pencil.x = startPoint.x;
								pencil.y = startPoint.y;
								break;
							default : break;
						}
					}
				}
			}
		}
		
		private static function e_rect( path:Path, node:XML ):void
		{
			var x:Number = Number( node.@x.toString() );
			var y:Number = Number( node.@y.toString() );
			var width:Number = Number( node.@width.toString() );
			var height:Number = Number( node.@height.toString() );
			var xwidth:Number = x+width;
			var yheight:Number = y+height;
			path.addSegment( new Linear( x, y, xwidth, y ) );
			path.addSegment( new Linear( xwidth, y, xwidth, yheight ) );
			path.addSegment( new Linear( xwidth, yheight, x, yheight ) );
			path.addSegment( new Linear( x, yheight, x, y ) );
		}
		
		private static function e_line( path:Path, node:XML ):void
		{
			var x1:Number = Number( node.@x1.toString() );
			var y1:Number = Number( node.@y1.toString() );
			var x2:Number = Number( node.@x2.toString() );
			var y2:Number = Number( node.@y2.toString() );
			path.addSegment( new Linear( x1, y1, x2, y2 ) );
		}
		
		private static function e_polyline( path:Path, node:XML ):void
		{
			var points:Array = node.@points.toString().split( " " );
			var point:Array = points[ 0 ].split( "," );
			var x:Number;
			var y:Number;
			var startX:Number;
			var startY:Number;
			var oldX:Number;
			var oldY:Number;
			if( point.length == 2 )
			{
				oldX = startX = point[ 0 ];
				oldY = startY = point[ 1 ];
			}
			for( var i:int=1; i<points.length; ++i )
			{
				point = points[ i ].split( "," );
				if( point.length == 2 )
				{
					x = Number( point[ 0 ] );
					y = Number( point[ 1 ] );
					path.addSegment( new Linear( oldX, oldY, x, y ) );
					oldX = x;
					oldY = y;
				}
			}
		}
		
		private static function e_polygon( path:Path, node:XML ):void
		{
			var points:Array = node.@points.toString().split( " " );
			var point:Array = points[ 0 ].split( "," );
			var x:Number;
			var y:Number;
			var startX:Number;
			var startY:Number;
			var oldX:Number;
			var oldY:Number;
			if( point.length == 2 )
			{
				oldX = startX = point[ 0 ];
				oldY = startY = point[ 1 ];
			}
			for( var i:int=1; i<points.length; ++i )
			{
				point = points[ i ].split( "," );
				if( point.length == 2 )
				{
					x = Number( point[ 0 ] );
					y = Number( point[ 1 ] );
					path.addSegment( new Linear( oldX, oldY, x, y ) );
					oldX = x;
					oldY = y;
				}
			}
			path.addSegment( new Linear( oldX, oldY, startX, startY ) );
		}
	}
}