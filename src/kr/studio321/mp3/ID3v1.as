package kr.studio321.mp3
{
	import flash.utils.ByteArray;

	/**
	 * ID3v1 태그를 정의합니다.
	 * @author 0xABCDEF
	 */
	public class ID3v1
	{
		private const header:String = "TAG";
		
		/**
		 * 곡의 제목입니다.( 30바이트로 제한됩니다 )
		 * @default 
		 */
		public var title:String;
		/**
		 * 작곡가입니다.( 30바이트로 제한됩니다 )
		 * @default 
		 */
		public var artist:String;
		/**
		 * 앨범입니다.( 30바이트로 제한됩니다 )
		 * @default 
		 */
		public var album:String;
		/**
		 * 곡이 만들어진 년도입니다.( 4바이트로 제한됩니다 )
		 * @default 
		 */
		public var year:String;
		/**
		 * 주석입니다.( 28바이트로 제한됩니다 )
		 * @default 
		 */
		public var comment:String;
		/**
		 * 트랙넘버입니다.( 1바이트로 제한됩니다 )
		 * @default 
		 */
		public var track:int;
		/**
		 * 장르입니다.( 1바이트로 제한됩니다 )
		 * @default 
		 */
		public var genre:int;
		
		/**
		 * ID3v1 객체를 생성합니다.
		 */
		public function ID3v1()
		{
		}
		
		/**
		 * mp3 파일로부터 ID3v1 태그를 읽은 내용을 반환합니다.
		 * @param mp3 대상 mp3 객체입니다.
		 * @param charSet 문자열 인코딩을 정의합니다.
		 * @return ID3v1 태그입니다.
		 */
		public static function read( mp3:ByteArray, charSet:String = "EUC-KR" ):ID3v1
		{
			var id3v1:ID3v1 = new ID3v1;
			mp3.position = mp3.length-128;
			if( mp3.readUTFBytes( 3 ).match( /tag/i ) )
			{
				id3v1.title = mp3.readMultiByte( 30, charSet );
				id3v1.artist = mp3.readMultiByte( 30, charSet );
				id3v1.album = mp3.readMultiByte( 30, charSet );
				id3v1.year = mp3.readMultiByte( 4, charSet );
				id3v1.comment = mp3.readMultiByte( 28, charSet );
				if( mp3.readByte() )
				{
					--mp3.position;
					id3v1.comment += mp3.readMultiByte( 2, charSet );
				} else {
					id3v1.track = mp3.readByte();
				}
				id3v1.genre = mp3.readByte();
			}
			return id3v1;
		}
		
		/**
		 * ID3v1 태그를 작성합니다. 리턴되는 값( id3 tag )을 mp3( ByteArray )의 끝부분에다 붙이면 됩니다.
		 * @param charSet 문자열 인코딩을 정의합니다.
		 */
		public function write( charSet:String = "EUC-KR" ):ByteArray
		{
			var restrictor:ByteArray = new ByteArray;
			var id3v1:ByteArray = new ByteArray;
			
			restrictor.writeMultiByte( title, charSet );
			restrictor.length = 30;
			id3v1.writeBytes( restrictor, 0, 30 );
			restrictor.position = restrictor.length = 0;
			
			restrictor.writeMultiByte( artist, charSet );
			restrictor.length = 30;
			id3v1.writeBytes( restrictor, 0, 30 );
			restrictor.position = restrictor.length = 0;
			
			restrictor.writeMultiByte( album, charSet );
			restrictor.length = 30;
			id3v1.writeBytes( restrictor, 0, 30 );
			restrictor.position = restrictor.length = 0;
			
			restrictor.writeMultiByte( year, charSet );
			restrictor.length = 4;
			id3v1.writeBytes( restrictor, 0, 4 );
			restrictor.position = restrictor.length = 0;
			
			restrictor.writeMultiByte( comment, charSet );
			restrictor.length = 28;
			id3v1.writeBytes( restrictor, 0, 28 );
			restrictor.position = restrictor.length = 0;
			
			id3v1.writeByte( track );
			id3v1.writeByte( genre );
			
			return id3v1;
		}
		
	}
}