package;

import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;
import zero.flxutil.sprites.Stack;
import zero.flxutil.sprites.CheckerBoard;

using Math;
using zero.ext.FloatExt;

class PlayState extends FlxState
{

	var info_text:FlxText;
	var options:StackOptions;
	var stack:Stack;
	var ui_cam:FlxCamera;

	public function new(options:StackOptions)
	{
		this.options = options;
		super();
	}

	override public function create():Void
	{
		ui_cam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		ui_cam.bgColor = 0x00FFFFFF;
		FlxG.cameras.add(ui_cam);

		options.camera = FlxG.camera;

		new StackManager();
		StackManager.i.init_camera(FlxG.camera, 1024);

		var checkerboard = new CheckerBoard(FlxG.camera.width, FlxG.camera.height, 0xFF606060, 0xFF808080, 16, 16);
		checkerboard.setPosition(FlxG.camera.x, FlxG.camera.y);
		checkerboard.cameras = [FlxG.camera];
		add(checkerboard);

		stack = new Stack(options);

		add(StackManager.i.object_group);

		info_text = new FlxText(0, FlxG.height - 16, FlxG.width);
		info_text.setFormat(null, 8, 0xFFFFFF, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		info_text.camera = ui_cam;
		add(info_text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//StackManager.i.sort_objects();
		StackManager.i.adjust_tilt(FlxG.keys.pressed.DOWN ? -0.01 : FlxG.keys.pressed.UP ? 0.01 : 0);
		FlxG.camera.angle += FlxG.keys.pressed.LEFT ? -1 : FlxG.keys.pressed.RIGHT ? 1 : 0;
		FlxG.camera.zoom = (FlxG.camera.zoom + (FlxG.mouse.wheel / 10)).max(1).min(10);
		if (FlxG.keys.justPressed.BACKSPACE) FlxG.switchState(new MenuState());

		info_text.text = '[ z offset : ${stack.z_offset} ] [ angle : ${FlxG.camera.angle.floor().get_relative_degree()} ] [ zoom : ${FlxG.camera.zoom} ]';
	}
}
