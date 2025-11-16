package funkin.hl.ui;

import flixel.system.FlxAssets;

class HLUIButton extends HLUIBox
{
	public var onClickCallback:Void->Void;
	public var turbo:Bool = false;

	private var _image:HLUIComponent;
	private var _label:HLUILabel;

	public var useImage(default, set):Bool = false;
	public function set_useImage(value:Bool):Bool
	{
		useImage = value;
		resetComponents();
		return value;
	}

	public var useLabel(default, set):Bool = false;
	public function set_useLabel(value:Bool):Bool
	{
		useLabel = value;
		resetComponents();
		return value;
	}

	public function new(text:String = "")
	{
		super(HORIZONTAL);
		PADDING = 1;

		name = 'Button';

		_image = new HLUIComponent();
		_label = new HLUILabel(text);

		if (text != "") setText(text);

		resetComponents();

		onClick = () -> {
			buildUI({pressed: true});
		}
		onRelease = (hovering) -> {
			buildUI({background: true});
			_turboTimer = 0;
			
			if (hovering && onClickCallback != null && !_hitTurbo) onClickCallback();
			_hitTurbo = false;
		}
	}

	public function setText(text:String):Void
	{
		_label.text = text;
		useLabel = true;

		name = 'Button ("$text")';

		resetComponents();
	}

	public function setGraphic(_graphic:FlxGraphicAsset):Void
	{
		_image.loadGraphic(_graphic);
		_image.updateHitbox();
		useImage = true;

		name = 'Button ("$graphic")';

		resetComponents();
	}

	private var _turboTimer:Float = 0;
	private var _hitTurbo:Bool = false;
	public static var TURBO_THRESHOLD:Float = 0.3;
	public static var TURBO_REPEAT:Float = 0.05;
	public override function update(dt:Float):Void
	{
		super.update(dt);
		updateTurbo(dt);
	}

	private function updateTurbo(dt:Float):Void
	{
		if (!turbo || onClickCallback == null) return;

		if (_didClick && FlxG.mouse.pressed)
		{
			_turboTimer += dt;

			if (_turboTimer > TURBO_THRESHOLD) _hitTurbo = true;
			if (_hitTurbo && _turboTimer > TURBO_REPEAT)
			{
				_turboTimer = 0;
				onClickCallback();
			}
		}
	}

	private function resetComponents():Void
	{
		_components.resize(0);

		var maxWidth:Int = 0;
		var maxHeight:Int = 0;

		if (useImage) 
		{
			addComponent(_image);

			maxWidth += Std.int(_image.width + _image.push.x + _image.componentOffset.x + PADDING);
			maxHeight += Std.int(_image.width + _image.push.y + _image.componentOffset.y + PADDING);
		}
		if (useLabel) 
		{
			addComponent(_label);

			maxWidth += Std.int(_label.width + _label.push.x + _label.componentOffset.x + PADDING);
			maxHeight += Std.int(_label.height + _label.push.y + _label.componentOffset.y + PADDING);
		}

		componentWidth = Std.int(maxWidth);
		componentHeight = Std.int(maxHeight);

		buildUI({background: true});
	}
}