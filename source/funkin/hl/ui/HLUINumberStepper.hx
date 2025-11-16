package funkin.hl.ui;

// im lazy as fuck lol

class HLUINumberStepper extends HLUIBox
{
	private var _label:HLUILabel;
	private var _leftButton:HLUIButton;
	private var _numberBox:HLUIBox;
	private var _number:HLUILabel;
	private var _rightButton:HLUIButton;

	public var def:Int;
	public var min:Int;
	public var max:Int;
	public var step:Int;
	public var value:Int;

	public var onChange:Int->Void;

	public function new(text:String, _def:Int = 0, _min:Int = -1, _max:Int = 1, _step:Int = 1, valueWidth:Int = 50)
	{
		super(HORIZONTAL);
		PADDING = 0;

		def = _def;
		value = _def;
		min = _min;
		max = _max;
		step = _step;

		_label = new HLUILabel(text);
		_leftButton = new HLUIButton("<");
		_leftButton.componentOffset.x = 6;
		_numberBox = new HLUIBox(HORIZONTAL);
		_number = new HLUILabel('$def');
		_rightButton = new HLUIButton(">");

		_leftButton.onClickCallback = () -> {
			value -= step;
			if (value < min) value = min;

			_number.text = '$value';
			if (onChange != null) onChange(value);
		}

		_rightButton.onClickCallback = () -> {
			value += step;
			if (value > max) value = max;

			_number.text = '$value';
			if (onChange != null) onChange(value);
		}

		_leftButton.turbo = true;
		_rightButton.turbo = true;

		addComponent(_label);
		addComponent(_leftButton);
		addComponent(_numberBox);

		_numberBox.componentWidth = valueWidth;
		_numberBox.componentHeight = Std.int(_number.height + _numberBox.PADDING);
		_numberBox.addComponent(_number);

		addComponent(_rightButton);

		componentWidth = Std.int(
			_leftButton.componentWidth + 
			_numberBox.push.x + _numberBox.componentWidth + 
			_rightButton.push.x + _rightButton.componentWidth
		);

		componentHeight = Std.int(_numberBox.componentHeight * 1.5);
		_leftButton.componentHeight = _numberBox.componentHeight;
		_rightButton.componentHeight = _numberBox.componentHeight;

		_numberBox.buildUI({value: true});
		_leftButton.buildUI({background: true});
		_rightButton.buildUI({background: true});
	}	
}