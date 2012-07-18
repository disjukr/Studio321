package kr.studio321.util
{
	import flash.text.TextField;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	 * 텍스트필드 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class TextFieldUtil
	{
		/**
		 * 텍스트필드를 문자 단위로 분해시킵니다.
		 * @param tf 대상 텍스트필드입니다.
		 * @param splitSpace 공백도 뜯어낼지를 결정합니다. 근데 공백은 어차피 시각적으로 쓸모가 없으니까 false가 기본값입니다.
		 * @return 분해시킨 텍스트필드들이 담겨있는 배열이 반환됩니다. 원본은 수정되지 않습니다.
		 */
		public static function splitByChar( tf:TextField, splitSpace:Boolean = false ):Array {
			var returnArray:Array = new Array;
			var currentTextRect:Rectangle = tf.getCharBoundaries( 0 );
			var currentChar:String;
			var currentLength:int;
			var adjustValue:Point = new Point;
			adjustValue.x = tf.x - currentTextRect.x;
			adjustValue.y = tf.y - currentTextRect.y;
			for( var i:int; i<tf.length; ++i ) {
				currentChar = tf.text.charAt( i );
				if( currentChar == "\r" || ( splitSpace && ( currentChar == " " || currentChar == "\t" ) ) ) {
					continue;
				}
				returnArray.push( new TextField );
				currentLength = returnArray.length - 1;
				currentTextRect = tf.getCharBoundaries( i );
				returnArray[ currentLength ].x = currentTextRect.x + adjustValue.x;
				returnArray[ currentLength ].y = currentTextRect.y + adjustValue.y;
				returnArray[ currentLength ].text = currentChar;
				returnArray[ currentLength ].autoSize = "left";
				returnArray[ currentLength ].multiline = false;
				returnArray[ currentLength ].mouseWheelEnabled = false;
				returnArray[ currentLength ].type = tf.type;
				returnArray[ currentLength ].selectable = tf.selectable;
				returnArray[ currentLength ].antiAliasType = tf.antiAliasType;
				returnArray[ currentLength ].background = tf.background;
				returnArray[ currentLength ].backgroundColor = tf.backgroundColor;
				returnArray[ currentLength ].border = tf.border;
				returnArray[ currentLength ].borderColor = tf.borderColor;
				returnArray[ currentLength ].defaultTextFormat = tf.defaultTextFormat;
				returnArray[ currentLength ].displayAsPassword = tf.displayAsPassword;
				returnArray[ currentLength ].embedFonts = tf.embedFonts;
				returnArray[ currentLength ].gridFitType = tf.gridFitType;
				returnArray[ currentLength ].restrict = tf.restrict;
				returnArray[ currentLength ].sharpness = tf.sharpness;
				returnArray[ currentLength ].textColor = tf.textColor;
				returnArray[ currentLength ].thickness = tf.thickness;
				returnArray[ currentLength ].setTextFormat( tf.getTextFormat( i, i+1 ) );
			}
			return returnArray;
		}
	}
}