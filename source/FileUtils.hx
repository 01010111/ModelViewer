import systools.Dialogs;
import openfl.display.BitmapData;
import haxe.Json;

class FileUtils
{

	public static function load_image():Null<ImageWithData>
	{
		var result:Array<String> = Dialogs.openFile(
			"Select a file please!",
			"Please select one or more files, so we can see if this method works",
			{
				count: 2,
				descriptions: ["PNG files", "JPEG files"],
				extensions: ["*.png","*.jpg;*.jpeg"]
			}
		);

		if (result != null && result.length > 0)
		{
			var split_path = result[0].split('/');
			var name = split_path[split_path.length - 1];
			var img = BitmapData.fromFile(result[0]);
			if (img != null) return {
				img:img,
				name:name
			};
		}

		return null;
	}

	public static function save_json(filename:String, data:Dynamic)
	{
		var json = Json.stringify(data);
		var destination = systools.Dialogs.saveFile( "", "Select a destination", "../../../");
		if (destination != null) 
		{
			var file = sys.io.File.write(destination,false);
			try 
			{ 
				file.write(haxe.io.Bytes.ofString(json)); 
				file.flush(); 
			}
			catch(err:Dynamic) trace('saveText', err, true);
			file.close();
		}
	}

}

typedef ImageWithData =
{
	name:String,
	img:BitmapData
}