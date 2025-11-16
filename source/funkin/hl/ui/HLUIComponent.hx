package funkin.hl.ui;

import flixel.FlxCamera;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;

typedef HLUIComponentDrawStyle =
{
	@:optional var background:Bool;
	@:optional var pressed:Bool;
	@:optional var value:Bool;

	@:optional var table:Bool;
	@:optional var tableSelected:Bool;

	@:optional var mainCol:Bool;
	@:optional var altCol:Bool;
	@:optional var lightCol:Bool;
	@:optional var darkCol:Bool;
}

class HLUIComponent extends FlxSprite
{
	private var _components:Array<HLUIComponent> = [];

	public var parent:HLUIComponent;

	public var onHover:Void->Void;
	public var whileHovered:Void->Void;
	public var onExit:Void->Void;

	public var onClick:Void->Void;
	public var onRelease:Bool->Void;

	private var _hovered:Bool = false;
	private var _didClick:Bool = false;

	public var componentOffset:FlxPoint = FlxPoint.weak();
	public var push:FlxPoint = FlxPoint.weak();
	public var componentWidth:Int = 1;
	public var componentHeight:Int = 1;

	public var name:String = '';

	public function new(_componentOffsetX:Float = 0, _componentOffsetY:Float = 0)
	{ 
		super();

		makeGraphic(componentWidth, componentHeight, 0x00000000);

		componentOffset.x = _componentOffsetX;
		componentOffset.y = _componentOffsetY;
	}

	override public function set_visible(value:Bool):Bool
	{
		super.set_visible(value);
		forEachComponent((component) -> {
			component.visible = value;
		});
		return value;
	}

	override public function set_cameras(value:Array<FlxCamera>):Array<FlxCamera>
	{
		super.set_cameras(value);
		forEachComponent((component) -> {
			component.cameras = value;
		});
		return value;
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);

		// made my own offset because `.offset` is visual & i dont wanna mess with that stuff
		if (parent != null) setPosition(parent.x + push.x + componentOffset.x, parent.y + push.y + componentOffset.y);
		else setPosition(x + push.x + componentOffset.x, y + push.y + componentOffset.y);

		// not visible = non-existant, for simplicity
		if (!visible) return;

		var mpos = FlxG.mouse.getWorldPosition(cameras[0]);
		if (mpos.x > x && mpos.x < x + componentWidth &&
			mpos.y > y && mpos.y < y + componentHeight) 
		{
			if (!_hovered)
			{
				if (onHover != null) onHover();
				_hovered = true;
			}

			if (whileHovered != null) whileHovered();
			if (FlxG.mouse.justPressed) 
			{
				if (onClick != null) onClick();
				_didClick = true;
			}
		}
		else
		{
			if (_hovered)
			{
				if (onExit != null) onExit();
				_hovered = false;
			}
		}

		if (FlxG.mouse.justReleased && _didClick)
		{
			if (onRelease != null) onRelease(_hovered);
			_didClick = false;
		}
	}

	public static var MAIN_COL:Int = 0xFF4C5844;
	public static var ALT_COL:Int = 0xFF3E4637;
	public static var LIGHT_COL:Int = 0xFF889180;
	public static var DARK_COL:Int = 0xFF282E22;
	public static var TRANSPARENT:Int = 0x00000000;

	public function buildUI(drawStyle:HLUIComponentDrawStyle):Void 
	{
		if (drawStyle == null) return;

		if (drawStyle.background) drawBackground(MAIN_COL, LIGHT_COL, LIGHT_COL, DARK_COL, DARK_COL);
		if (drawStyle.pressed) drawBackground(MAIN_COL, DARK_COL, DARK_COL, LIGHT_COL, LIGHT_COL);
		if (drawStyle.value) drawBackground(ALT_COL, LIGHT_COL, LIGHT_COL, DARK_COL, DARK_COL);

		if (drawStyle.table) drawBackground(ALT_COL, ALT_COL, DARK_COL, ALT_COL, ALT_COL);
		if (drawStyle.tableSelected) drawBackground(HLUITable.HIGHLIGHT_COL, TRANSPARENT, TRANSPARENT, TRANSPARENT, TRANSPARENT);

		if (drawStyle.mainCol) drawBackground(MAIN_COL, MAIN_COL, MAIN_COL, MAIN_COL, MAIN_COL);
		if (drawStyle.altCol) drawBackground(ALT_COL, ALT_COL, ALT_COL, ALT_COL, ALT_COL);
		if (drawStyle.lightCol) drawBackground(LIGHT_COL, LIGHT_COL, LIGHT_COL, LIGHT_COL, LIGHT_COL);
		if (drawStyle.darkCol) drawBackground(DARK_COL, DARK_COL, DARK_COL, DARK_COL, DARK_COL);
	}

	private function drawBackground(mainCol:Int, leftCol:Int, topCol:Int, rightCol:Int, bottomCol:Int):Void
	{
		makeGraphic(componentWidth, componentHeight, mainCol, true);

		// draw light borders
		FlxSpriteUtil.drawLine(this, 0, componentHeight, 0, 1, {thickness: 1, color: leftCol});
		FlxSpriteUtil.drawLine(this, 1, 0, componentWidth, 0, {thickness: 1, color: topCol});

		// draw dark borders
		FlxSpriteUtil.drawLine(this, componentWidth, 0, componentWidth, componentHeight, {thickness: 1, color: rightCol});
		FlxSpriteUtil.drawLine(this, 0, componentHeight, componentWidth, componentHeight, {thickness: 1, color: bottomCol});
	}

	public function addComponent(component:HLUIComponent, ?drawStyle:HLUIComponentDrawStyle):Void
	{
		_components.push(component);

		component.parent = this;
		component.buildUI(drawStyle);
	}

	override public function loadGraphic(graphic:FlxGraphicAsset, animated:Bool = false, frameWidth:Int = 0, frameHeight:Int = 0, unique:Bool = false,
		?key:String)
	{
		super.loadGraphic(graphic, animated, frameWidth, frameHeight, unique, key);
		updateHitbox();

		componentWidth = Std.int(width);
		componentHeight = Std.int(height);

		return this;
	}

	public function addThisAndChildComponentsToState(stateInstance:FlxState):Void
	{
		stateInstance.add(this);

		forEachComponent((component) ->  { 
			component.addThisAndChildComponentsToState(stateInstance);
		});
	}

	public function removeThisAndChildComponentsFromState(stateInstance:FlxState):Void
	{
		stateInstance.remove(this);

		forEachComponent((component) ->  { 
			component.removeThisAndChildComponentsFromState(stateInstance);
		});
	}

	override public function destroy():Void
	{
		super.destroy();

		forEachComponent((component) -> {
			component.destroy();
		});
	}

	public function forEachComponent(onClickCallback:HLUIComponent->Void):Void for (component in _components) onClickCallback(component); 
	override public function toString():String return 'HLUIComponent("$name")';
}