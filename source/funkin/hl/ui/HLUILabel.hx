package funkin.hl.ui;

import flixel.text.FlxText;

class HLUILabel extends HLUIComponent
{
	public static var TEXT_COL:Int = 0xFFD8DED3;

	public var textCol(default, set):Int = TEXT_COL;
	public function set_textCol(value:Int):Int
	{
		textCol = value;
		drawText();
		return value;
	}

	public var size(default, set):Int = 16;
	public function set_size(value:Int):Int
	{
		size = value;
		drawText();
		return value;
	}

	public var text(default, set):String;
	public function set_text(value:String):String
	{
		text = value;
		name = 'Label ("$value")';
		drawText();
		return value;
	}

	public function new(_text:String)
	{
		super();

		text = _text;
	}

	private function drawText()
	{
		var t:FlxText = new FlxText(0, 0, -1, text);

		t.setFormat("assets/fonts/verdana.ttf", size, textCol);
		t.antialiasing = false;
		t.updateHitbox();
		t.drawFrame(true);

		loadGraphic(t.pixels, false, 0, 0, true);
		updateHitbox();
		antialiasing = false;

		componentWidth = Std.int(width);
		componentHeight = Std.int(height);
	}
}