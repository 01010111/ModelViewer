import flixel.text.FlxText;
import flixel.math.FlxPoint;
import zero.flxutil.sprites.Stack.StackOptions;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.display.BitmapData;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxButtonPlus;

using Math;
using zero.ext.FloatExt;

class MenuState extends FlxState
{

	var options:StackOptions;

	override public function create()
	{
		super.create();

		FlxG.autoPause = false;

		options = {
			z_offset: 0.5,
			slices: 1,
			position: FlxPoint.get(FlxG.width * 0.5 - 8, FlxG.height * 0.5 - 8),
			graphic: new BitmapData(16, 16, false, 0xFF000000),
			frame_width: 16,
			frame_height: 16,
		}

		var start_btn:FlxButtonPlus = new FlxButtonPlus(0, 0, () -> FlxG.switchState(new PlayState(options)), "View Model", FlxG.width - 32);
		start_btn.setPosition(FlxG.width - start_btn.width - 16, FlxG.height - start_btn.height - 16);
		start_btn.active = false;
		start_btn.alpha = 0.25;
		add(start_btn);

		var bitmap_text:FlxText = new FlxText(16, start_btn.y - 24, FlxG.width - 32);
		bitmap_text.setFormat(null, 8, 0xFFFFFF, FlxTextAlign.CENTER);
		add(bitmap_text);

		var load_btn:FlxButtonPlus = new FlxButtonPlus(16, 16, () -> {
			var g = FileUtils.load_image();
			if (g == null) return 0.0;
			options.graphic = g.img;
			bitmap_text.text = g.name;
			start_btn.active = true;
			start_btn.alpha = 1;
		}, 'Load Sprite Sheet', FlxG.width - 32);
		add(load_btn);

		var slices = make_ticker(112, 'Slices', 1, (amt:Float, text:FlxText, string:String) -> {
			options.slices += amt.floor();
			text.text = '$string: ${options.slices}';
		}, 1);

		make_ticker(48, 'Width', 16, (amt:Float, text:FlxText, string:String) -> {
			options.frame_width += amt.floor();
			text.text = '$string: ${options.frame_width}';
			options.position.x -= amt.half();
			if (options.graphic != null) update_slices(options.graphic, options.frame_width, options.frame_height, slices);
		}, 1);

		make_ticker(80, 'Height', 16, (amt:Float, text:FlxText, string:String) -> {
			options.frame_height += amt.floor();
			text.text = '$string: ${options.frame_height}';
			options.position.y -= amt.half();
			if (options.graphic != null) update_slices(options.graphic, options.frame_width, options.frame_height, slices);
		}, 1);
	}

	function update_slices(bitmap:BitmapData, width:Int, height:Int, text:FlxText)
	{
		options.slices = (bitmap.width / width).floor() * (bitmap.height / height).floor();
		text.text = 'Slices: ${options.slices}';
	}

	function make_ticker(y:Float, text:String, init_value:Float, callback:Float -> FlxText -> String -> Void, amt:Float)
	{
		var bg = new FlxSprite(16, y);
		bg.makeGraphic(FlxG.width - 32, 20, 0xFF404040);
		var display_text:FlxText = new FlxText(0, y + 2, FlxG.width, '$text: $init_value');
		display_text.setFormat(null, 8, 0xFFFFFF, FlxTextAlign.CENTER);
		var btn_down:FlxButtonPlus = new FlxButtonPlus(16 + 20, y, () -> callback(-amt, display_text, text), '<', 20);
		var btn_down_down:FlxButtonPlus = new FlxButtonPlus(16, y, () -> callback(-amt * 10, display_text, text), '<<', 20);
		var btn_up:FlxButtonPlus = new FlxButtonPlus(0, y, () -> callback(amt, display_text, text), '>', 20);
		var btn_up_up:FlxButtonPlus = new FlxButtonPlus(0, y, () -> callback(amt * 10, display_text, text), '>>', 20);
		btn_up.x = FlxG.width - btn_up.width - 16 - 20;
		btn_up_up.x = FlxG.width - btn_up.width - 16;

		add(bg);
		add(display_text);
		add(btn_down);
		add(btn_up);
		add(btn_down_down);
		add(btn_up_up);

		return display_text;
	}

	override public function update(dt:Float)
	{
		super.update(dt);
	}

}