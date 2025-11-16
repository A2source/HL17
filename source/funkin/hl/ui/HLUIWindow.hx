package funkin.hl.ui;

import flixel.FlxG;
import funkin.hl.ui.HLUIComponent.HLUIComponentDrawStyle;
import flixel.sound.FlxSound;

class HLUIWindow extends HLUIBox
{
	private var _titlebar:HLUIBox;
	private var _titlebarIcon:HLUIComponent;
	private var _titlebarLabel:HLUILabel;
	private var _titlebarClose:HLUIButton;

	private var _dragging:Bool = false;

	public var volume(default, set):Float = 1;
	public function set_volume(value:Float):Float
	{
		openSound.volume = value;	
		closeSound.volume = value;	

		volume = value;
		return value;
	}

	public var openSound:FlxSound = FlxG.sound.load("assets/sounds/hl/menuOpen.ogg");
	public var closeSound:FlxSound = FlxG.sound.load("assets/sounds/hl/menuClose.ogg");

	override public function set_visible(value:Bool):Bool
	{
		super.set_visible(value);
		
		if (value) openSound.play();
		else closeSound.play();
			
		return value;
	}

	public function new(_x:Float, _y:Float, _width:Int, _height:Int, closeButtonOffset:Float = 0)
	{
		super(VERTICAL);
		name = 'Window';

		openSound.volume = 0;
		openSound.play();
		openSound.volume = volume;

		_titlebar = new HLUIBox(HORIZONTAL);
		_titlebar.onClick = () -> {
			_dragging = true;
		}
		_titlebar.onRelease = (hovered) -> {
			_dragging = false;
		}

		_titlebarIcon = new HLUIComponent();
		_titlebarIcon.loadGraphic("assets/images/steam.png");

		_titlebarLabel = new HLUILabel("Options");
		_titlebarLabel.componentOffset.y = 7;

		_titlebarClose = new HLUIButton();
		_titlebarClose.setGraphic("assets/images/close.png");
		_titlebarClose.onClickCallback = () -> {
			visible = false;
		}

		@:privateAccess
		{
			_titlebarClose._label.componentWidth = 0;
			_titlebarClose._label.componentHeight = 0;
			_titlebarClose._label.componentOffset.x = 0;
			_titlebarClose._label.componentOffset.y = 0;
		}

		_titlebar.componentWidth = _width;
		_titlebar.componentHeight = 35;
		_titlebar.addComponent(_titlebarIcon);
		_titlebar.addComponent(_titlebarLabel);
		_titlebar.addComponent(_titlebarClose);
		_titlebar.name = 'Titlebar';

		addComponent(_titlebar, {background: false});

		setPosition(_x, _y);
		componentWidth = _width;
		componentHeight = _height;

		PADDING = 8;

		_titlebarClose.componentOffset.x += closeButtonOffset;
	}

	override public function update(dt:Float)
	{
		super.update(dt);

		if (_dragging) 
		{
			x += FlxG.mouse.deltaX; 
			y += FlxG.mouse.deltaY;
		}
	}
}