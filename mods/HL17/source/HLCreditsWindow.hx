class HLCreditsWindow extends HLUIWindow
{
	private static var WINDOW_WIDTH:Int = 636;
	private static var WINDOW_HEIGHT:Int = 196;

	private var _x:Float;
	private var _y:Float;

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
		_titlebarLabel.text = 'Credits';
		_titlebarClose.componentOffset.x = WINDOW_WIDTH - 132;
		_titlebarClose.componentOffset.y = 4;
	}

	private var _hl17Team:HLUITable;
	private var _extraCredits:HLUITable;
	private var _specialThanks:HLUITable;

	// quite girthy
	private var MEMBER_WIDTH:Int = 220;
	private var ROLE_WIDTH:Int = 400;

	private var _namesToLinks:Map<String, String> = [
		'[A2]' => 'https://youtube.com/@A2music',
		'DaPootisBird' => 'https://youtube.com/@DaPootisBird',
		'Tayied' => 'https://twitter.com/Tayied1',
		'Jule Games' => 'https://www.roblox.com/communities/17127111/Jule-Games-x-Euphoric-Bros#!/about',
		'LSPLASH' => 'https://www.roblox.com/communities/3049798/LSPLASH#!/about',
		'Ray Koefoed' => 'https://www.youtube.com/watch?v=M9J6DKJXoKk',
		'Valve' => 'https://steampowered.com'
	];

	public function initializeAndAddToState(state:FlxState)
	{
		_hl17Team = new HLUITable(
			[
				{
					columns: ['MEMBER', 'ROLES'],
					rows: [
						[
							'[A2]', 
							'Soundtrack, Programming, Charting'
						],	
						[
							'DaPootisBird', 
							'Animation, Programming, Charting'
						],	
					]
				},
			],
			[
				MEMBER_WIDTH,
				ROLE_WIDTH
			]
		);

		_extraCredits = new HLUITable(
			[
				{
					columns: ['CREDIT', 'ROLES'],
					rows: [
						[
							'RoxTrafford', 
							'Happy Huggy Head'
						],	
						[
							'Jule Games', 
							'Jumbo Josh, Banban, & Stinger Flynn Head'
						],	
						[
							'LSPLASH', 
							'Seek\'s Eye, Seek\'s New Whip'
						]
					]
				},
			],
			[
				MEMBER_WIDTH,
				ROLE_WIDTH
			]
		);

		_specialThanks = new HLUITable(
			[
				{
					columns: ['THANK', 'YOU!'],
					rows: [
						[
							'Tayied', 
							'Various Huggy Assets'
						],	
						[
							'Ray Koefoed', 
							'In The Virtual End'
						],	
						[
							'Valve',
							'Half-Life Franchise'
						]
					]
				},
			],
			[
				MEMBER_WIDTH,
				ROLE_WIDTH
			]
		);

		_hl17Team.componentOffset.x = 4;
		_extraCredits.componentOffset.x = 4;
		_specialThanks.componentOffset.x = 4;

		for (row in _hl17Team._rows)
		{
			row.onRelease = () -> {
				openBrowser(_hl17Team.selectedRow.labels[0].text);
			}
		}

		for (row in _extraCredits._rows)
		{
			row.onRelease = () -> {
				openBrowser(_extraCredits.selectedRow.labels[0].text);
			}
		}

		for (row in _specialThanks._rows)
		{
			row.onRelease = () -> {
				openBrowser(_specialThanks.selectedRow.labels[0].text);
			}
		}

		var tabs = new HLUITabBox([
			new HLUITab("HL17 Team", _hl17Team),
			new HLUITab("Extra Credits", _extraCredits),
			new HLUITab("Special Thanks", _specialThanks)
		], WINDOW_WIDTH - 8, WINDOW_HEIGHT - 77, state);
		tabs.componentOffset.set(4, -2);

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

	public function center():Void
	{
		if (_x == null) x = Std.int((FlxG.width / 2)  - (WINDOW_WIDTH / 2));
		else x = _x;
		if (_y == null) y = Std.int((FlxG.height / 2)  - (WINDOW_HEIGHT / 2));
		else y = _y;
	}

	private function openBrowser(name:String)
	{
		var link:String = _namesToLinks.get(name);
		if (link == null) return;

		CoolUtil.openURL(link);
		trace(name);
	}
}