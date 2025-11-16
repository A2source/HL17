import flixel.FlxG;
import flixel.FlxState;

class HLOptionsWindow extends HLUIWindow
{
	private static var WINDOW_WIDTH:Int = 466;
	private static var WINDOW_HEIGHT:Int = 515;

	private var _gameplayDB:Array<Dynamic> = [
		{
			label: "Downscroll",
			pointer: "downscroll",
			type: 'CHECKBOX'
		},
		{
			label: "Ghost Tapping",
			pointer: "ghostTapping",
			type: 'CHECKBOX'
		},
		{
			label: "Song Offset",
			pointer: "songOffset",
			type: 'STEPPER',
			callback: (offset) -> { Conductor.songOffset = offset; }
		},
		{
			label: "Camera Zoom On Beat",
			pointer: "camZoomOnBeat",
			type: 'CHECKBOX'
		},
	];

	private var _appearanceDB:Array<Dynamic> = [
		{
			label: "Framerate",
			pointer: "framerate",
			type: 'STEPPER',
			callback: (fps) -> {
				if(FlxG.updateFramerate < Std.int(fps))
					FlxG.drawFramerate = FlxG.updateFramerate = Std.int(fps);
				else
					FlxG.updateFramerate = FlxG.drawFramerate = Std.int(fps);
			}
		},
		{
			label: "Antialiasing",
			pointer: "antialiasing",
			type: 'CHECKBOX'
		},
		{
			label: "Gameplay Shaders",
			pointer: "gameplayShaders",
			type: 'CHECKBOX'
		},
		{
			label: "Flashing",
			pointer: "flashingMenu",
			type: 'CHECKBOX'
		},
		{
			label: "Low Memory Mode",
			pointer: "lowMemoryMode",
			type: 'CHECKBOX'
		},
		{
			label: "VRAM Only Sprites",
			pointer: "gpuOnlyBitmaps",
			type: 'CHECKBOX'
		},
		{
			label: "Auto Pause",
			pointer: "autoPause",
			type: 'CHECKBOX'
		},
	];

	private var _minMaxStepDB:Map<String, Dynamic> = [
		"Song Offset" => {
			min: -999,
			max: 999,
			step: 1
		},
		"Framerate" => {
			min: 30,
			max: 240,
			step: 5
		}
	]

	private var _x:Float;
	private var _y:Float;

	private var _settingBind:Bool = false;
	private var _isAlt:Bool = false;

	public function new(__x:Float, __y:Float)
	{
		_x = __x;
		_y = __y;

		center();

		super(x, y, WINDOW_WIDTH, WINDOW_HEIGHT);
		componentWidth = WINDOW_WIDTH;
		componentHeight = WINDOW_HEIGHT;

		_titlebar.componentWidth = WINDOW_WIDTH;
		_titlebar.componentHeight = 35;
		_titlebarClose.componentOffset.x = WINDOW_WIDTH - 132;
		_titlebarClose.componentOffset.y = 4;
	}
	
	private var _controlsTable:HLUITable;
	public function initializeAndAddToState(state:FlxState)
	{
		_controlsTable = new HLUITable(
			[
				{
					columns: ['NOTES', 'KEY/BUTTON', 'ALTERNATE'],
					rows: [
						[
							'Left', 
							getControl('NOTE_LEFT'), 
							getControl('NOTE_LEFT', true)
						],	
						[
							'Down', 
							getControl('NOTE_DOWN'), 
							getControl('NOTE_DOWN', true)
						],	
						[
							'Up', 
							getControl('NOTE_UP'), 
							getControl('NOTE_UP', true)
						],	
						[
							'Right', 
							getControl('NOTE_RIGHT'), 
							getControl('NOTE_RIGHT', true)
						]
					]
				},
				{
					columns: ['UI', 'KEY/BUTTON', 'ALTERNATE'],
					rows: [
						[
							'Left', 
							getControl('Left'), 
							getControl('Left', true)
						],	
						[
							'Down', 
							getControl('Down'), 
							getControl('Down', true)
						],	
						[
							'Up', 
							getControl('Up'), 
							getControl('Up', true)
						],	
						[
							'Right', 
							getControl('Right'), 
							getControl('Right', true)
						],
						[
							'Accept', 
							getControl('Accept'), 
							getControl('Accept', true)
						],
						[
							'Back', 
							getControl('Back'), 
							getControl('Back', true)
						],
						[
							'Reset', 
							getControl('Reset'), 
							getControl('Reset', true)
						],
						[
							'Pause', 
							getControl('Pause'), 
							getControl('Pause', true)
						],
					]
				}
			],
			[
				190, 
				130, 
				130
			]
		);

		var controls = new HLUIBox(Layout.VERTICAL);
		controls.componentOffset.x = 4;
		controls.addComponent(_controlsTable);

		var buttons = new HLUIBox(Layout.HORIZONTAL);
		buttons.componentOffset.y = 14;
		var editKey = new HLUIButton("Edit Key");
		var altKey = new HLUIButton("Edit Alternate");

		editKey.onClickCallback = () ->
		{
			if (_controlsTable.selectedRow == null) return;

			_settingBind = true;
			_isAlt = false;

			_controlsTable.selectedRow.labels[1].buildUI({darkCol: true});
		}

		altKey.onClickCallback = () ->
		{
			if (_controlsTable.selectedRow == null) return;

			_settingBind = true;
			_isAlt = true;

			_controlsTable.selectedRow.labels[2].buildUI({darkCol: true});
		}

		buttons.addComponent(editKey);
		buttons.addComponent(altKey);

		controls.addComponent(buttons);

		var gameplay = new HLUIBox(Layout.VERTICAL);
		gameplay.componentOffset.set(8, 8);
		addOptionsToTab(gameplay, _gameplayDB);

		var appearance = new HLUIBox(Layout.VERTICAL);
		appearance.componentOffset.set(8, 8);
		addOptionsToTab(appearance, _appearanceDB);

		var tabs = new HLUITabBox([
			new HLUITab("Keyboard", controls),
			new HLUITab("Gameplay", gameplay),
			new HLUITab("Appearance", appearance)
		], WINDOW_WIDTH - 8, WINDOW_HEIGHT - 77, state);
		tabs.componentOffset.x = 4;

		addComponent(tabs);

		buildUI({background: true});
		addThisAndChildComponentsToState(state);

		@:privateAccess
		{
			var tab:HLUITab = tabs._tabs[0];
			tabs._content.addComponent(tab.content);

			tab.content.addThisAndChildComponentsToState(state);
			tab.drawBottomLine();

			tabs.tabContent = tab.content;
			tab.selected = true;
		}
	}

	private function addOptionsToTab(tab:HLUIBox, options:Array<Dynamic>)
	{
		for (option in options)
		{					
			switch(option.type)
			{
				case 'CHECKBOX':
					var box = new HLUICheckbox(option.label, Reflect.getProperty(Options, option.pointer));

					box.onChange = (selec) -> {
						Reflect.setField(Options, option.pointer, selec);
						if (option.callback != null) option.callback(selec);

						Options.save();
						Options.applySettings();
					}
					tab.addComponent(box);

				case 'STEPPER':
					var mms:Dynamic = _minMaxStepDB[option.label];

					var step = new HLUINumberStepper(option.label, Std.int(Reflect.getProperty(Options, option.pointer)), mms.min, mms.max, mms.step);
					step.onChange = (value) -> {
						Reflect.setField(Options, option.pointer, value);
						if (option.callback != null) option.callback(value);

						Options.save();
						Options.applySettings();
					}
					tab.addComponent(step);
			}
		}
	}

	public function center():Void
	{
		if (_x == null) x = Std.int((FlxG.width / 2)  - (WINDOW_WIDTH / 2));
		else x = _x;
		if (_y == null) y = Std.int((FlxG.height / 2)  - (WINDOW_HEIGHT / 2));
		else y = _y;
	}

	public function update(dt:Float):Void
	{
		super.update(dt);

		if (!visible) return;
		if (!_settingBind) return;

		var key:FlxKey = FlxG.keys.firstJustPressed();
		var keyInt:Int = key;
		if (keyInt <= 0) return;

		// ESCAPE key
		if (key == 27 && !FlxG.keys.pressed.SHIFT) 
		{
			updateKey(0);
			return;
		}

		updateKey(key);
	}

	private function getControlName(key:String):String
	{
		var value:String = key.toUpperCase();

		if (_controlsTable == null) return value;
		switch(key)
		{
			case 'Left':  if (_controlsTable.selectedRow.index <= 3) value = 'NOTE_LEFT';
			case 'Down':  if (_controlsTable.selectedRow.index <= 3) value = 'NOTE_DOWN';
			case 'Up': 	  if (_controlsTable.selectedRow.index <= 3) value = 'NOTE_UP';
			case 'Right': if (_controlsTable.selectedRow.index <= 3) value = 'NOTE_RIGHT';
		}

		return value;
	}

	private function getControl(key:String, ?alt:Bool = false):String
	{
		if (alt) CoolUtil.keyToString(Reflect.getProperty(Options, 'P2_' + getControlName(key))[0]);
		else CoolUtil.keyToString(Reflect.getProperty(Options, 'P1_' + getControlName(key))[0]);
	}

	private function updateKey(key:Int):Void
	{
		var thisKey:String = _controlsTable.selectedRow.labels[0].text;

		if (_isAlt)
		{
			Reflect.setField(Options, 'P2_' + getControlName(thisKey), [option2 = key]);
			
			var label = _controlsTable.selectedRow.labels[2];
			var widthToSet = label.componentWidth;
			
			label.text = CoolUtil.keyToString(key);
			label.componentWidth = widthToSet;
		}
		else
		{
			Reflect.setField(Options, 'P1_' + getControlName(thisKey), [option1 = key]);
			
			var label = _controlsTable.selectedRow.labels[1];
			var widthToSet = label.componentWidth;
			
			label.text = CoolUtil.keyToString(key);
			label.componentWidth = widthToSet;
		}

		_settingBind = false;

		Options.save();
		Options.applySettings();
	}
}