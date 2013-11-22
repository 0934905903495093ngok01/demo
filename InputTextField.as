/**
 * ACRONICS SYSTEMS, INC.
 * www.acronics.com
 * 1994 - 2012 Copyright
 * THIS PROGRAM IS THE PROPERTY OF ACRONICS SYSTEMS, INC. AND IS BEING PROVIDED TO 
 * YOU PURSUANT TO A LICENSE AGREEMENT THAT SETS FORTH CERTAIN TERMS AND CONDITIONS
 * FOR USE OF THIS PROGRAM. YOU MAY NOT COPY, DISTRIBUTE, USE OR OTHERWISE CREATE 
 * DERIVATIVES OF THIS SOFTWARE EXCEPT AS PROVIDED IN THE LICENSE AGREEMENT.
 * 
 * @author Mydn
 * @version 1.0.0
 */

/**
 * Create a input InputTextBox.
 * 		- Need a named symbol: "InputTextBox_InputModeSymbol" that have 3 frame indicate chosed mode: 1. normal mode 2. Upper-case mode 3. Number-only mode
 * InputTextBox(target:MovieClip, x:Number, y:Number, desc:Object)
 * 		desc.fontName			:
 * 		desc.fontSize			:
 * 		desc.color				:
 * 		desc.bold				:
 * 		desc.italic				:
 * 		desc.underline			:
 * 		desc._width				:
 * 		desc._height			:
 * 		desc.text				:
 * 		desc.selectable			:
 * 		desc.backgroundColor	:
 * 		desc.wordWrap			:
 * 		desc.mode				: 0: Normal / 1: Upper-case / 2: Number-only
 * 		desc.password			:
 * 		desc.linesNumber		:
 * 
 * Broadcast Event:
 *		{ event:"onRollOut" , value:keyCode } 
 */
import mvc.*;
class .InputTextField extends InputDevices
{
	static private var enabledInstanceID:Number = 0;
	static private var instancesCounter:Number = 0;
	
	private var thisID:Number = 0;
	private var txt:TextField;
	private var txtFormat:TextFormat;
	
	private var inputModeSymbol:MovieClip;
	private var mode:Number;
	
	private var enabledFlag:Boolean = false;
	private var broadcaster:Object;
	private var position:Object;
	
	/*****************************************
	 ******		The Public Methods		******
	 *****************************************/
	public function InputTextField(target:MovieClip, x:Number, y:Number, desc:Object, pos:Object) {
		super();
		thisID = ++instancesCounter;
		txtFormat = new TextFormat(
			(desc.fontName != undefined)?desc.fontName:"Arial",
			(desc.fontSize != undefined)?desc.fontSize:24,
			(desc.color != undefined)?desc.color:0xffffff,
			(desc.bold != undefined)?desc.bold:false,
			(desc.italic != undefined)?desc.italic:false,
			(desc.underline != undefined)?desc.underline:false,
			"", "",
			(desc.align != undefined)?desc.align:"left");	
		var text_height = txtFormat.getTextExtent(" ").textFieldHeight;
		txt = target.createTextField(
			"InputTextBox_txt_" + target.getNextHighestDepth(), target.getNextHighestDepth(), x, y,
			(desc._width != undefined)?desc._width:640,
			(desc._height != undefined)?desc._height:(desc.linesNumber != undefined)?(desc.linesNumber*text_height):text_height);	
		txt.setNewTextFormat(txtFormat);
		
		if (desc.text != undefined)
			txt.text = desc.text;
		else
			txt.text = "";
			
		if (desc.selectable != undefined)
			txt.selectable = desc.selectable;
		else
			txt.selectable = true;
			
		if (desc.backgroundColor != undefined)
		{
			txt.background = true;
			txt.backgroundColor = desc.backgroundColor;
		}
		
		if (desc.wordWrap == true || desc.linesNumber != undefined)
			txt.wordWrap = true;
		if (desc.password != undefined)
			txt.password = desc.password;
		txt.type = "input";
		txt.tabEnabled = false;
		_focusrect = false;
		//inputModeSymbol = target.attachMovie("InputTextBox_InputModeSymbol", "InputTextBox_InputModeSymbol_" + target.getNextHighestDepth(), target.getNextHighestDepth());
		inputModeSymbol = target.attachMovie("mcInputTextField", "mcInputTextField_" + target.getNextHighestDepth(), target.getNextHighestDepth());
		
		inputModeSymbol._x = txt._x + txt._width + 20;
		inputModeSymbol._y = txt._y + (txt._height - inputModeSymbol._height) / 2;
		/*var ref:Object = new Object();
		ref = this;
		onPress(this, controlHandler, inputModeSymbol, { event:"onPress", device:"Mouse", instance:ref,
									position: { row:0, column:0 } } );*/
		inputModeSymbol._visible = false;
		if (desc.mode != undefined)
			mode = desc.mode;
		else
			mode = 0;
		
		if (pos != undefined) {
			position = new Object();
			position = pos;
		}
		
		//--- Debug
		
		/*txt.border = true;
		txt.borderColor = 0xff0000;*/
		/*txt.onSetFocus = function(oldFocus:Object) {
			trace("onSetFocus");
		}
		txt.onKillFocus = function(newFocus:Object) {
			trace("onKillFocus");
		}*/
	}
	private function onPress(scope:Object, func:Function,mc:MovieClip,des:Object) {
		mc.onPress = function() {
			func.apply(scope,[des]);
		}
	}
	private function controlHandler(o:Object) {
		if (Data.g_isMouseActive == false) {
			trace("INPUTTEXTFIELD::controlHandler: --> Data.g_isMouseActive == false");
			//Data.g_isMouseActive = true;
			return;
		}
		/* run on board
		 * trace ("getInputMode " + this.getInputMode());
		var mod = this.getInputMode();
		if (mod == 2)
			mod = 0;
		else
			mod++;
		trace ("mode " + mode);
		this.inputMode = mod;*/
		
		//onKeyDown(KeyCodes.BUTTON_MENU);
	}
	public function get _enable():Boolean { return enabledFlag; }
	public function set _enable(en:Boolean)
	{
		trace("INPUT TEXTFIELD --> _enable " + en);
		trace("INPUT TEXTFIELD --> enabledInstanceID " + enabledInstanceID);
		trace("INPUT TEXTFIELD --> thisID "+thisID);
		if ((en && enabledInstanceID) || (!en && enabledInstanceID != thisID)) {
			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 0");
			return;
		}
		enabledFlag = en;
		if (enabledFlag)
		{
			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 1");
			Selection.setFocus(txt);
			Selection.setSelection(txt.text.length, txt.text.length);
			enabledInstanceID = thisID;
			this.inputMode = mode;
			inputModeSymbol._visible = true;
		}
		else 
		{
			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 2");
			Selection.setFocus(null);
			enabledInstanceID = 0;
			inputModeSymbol._visible = false;
		}
		this.enable(en);
		trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 3");
	}
	public function get text():String { return txt.text; }
	public function set text(t:String):Void { txt.text = t; }
	public function get color():Number { return txt.textColor; }
	public function set color(c:Number):Void { txt.textColor = c; }
	public function get _x():Number { return txt._x; }
	public function set _x(x:Number):Void { txt._x = x; }
	public function get _y():Number { return txt._y; }
	public function set _y(y:Number):Void { txt._y = y; }
	public function get _visible():Boolean { return txt._visible; }
	public function set _visible(visible:Boolean):Void { txt._visible = visible; }
	public function get password():Boolean { return txt.password; }
	public function set password(pw:Boolean):Void { txt.password = pw; }
	public function set inputMode(mod:Number):Void 
	{
		mode = mod;
		this.setInputMode(mod);
		inputModeSymbol.gotoAndStop(mod+1);
	}
	public function get _height():Number { return txt._height; }
	public function set _height(h:Number):Void { txt._height = h; }
	public function get _width():Number { return txt._width; }
	public function set _width(w:Number):Void { txt._width = w; }
	
	public function get txtEnable():Boolean { return txt.selectable}
	public function set txtEnable(b:Boolean):Void { txt.selectable = b; }
	
	public function addEventFunction(parent:Object,func:Function):Boolean {
		broadcaster = new Object();
		broadcaster._parent = parent;
		broadcaster._function = func;
		
		var ref:Object = this;
		
		txt.onSetFocus = function(oldFocus:Object) {
			var o:Object = ref;
			trace("InputTextField onSetFocus ");
			trace("InputTextField onSetFocus "+o.thisID);
			if (o.enabledFlag) {// && o.enabledInstanceID) || (!o.enabledFlag && o.enabledInstanceID != o.thisID)){
				trace("InputTextField onSetFocus: don't broadcaster");
				return;
			}else {
				trace("InputTextField onSetFocus: broadcaster");
				//Selection.setFocus(null);
				//o._enable = true;
				if (o.broadcaster != undefined)
					o.broadcaster._function.call(o.broadcaster._parent, { scope:o.broadcaster._parent,event:"onSetFocus", position:o.position} );	
			}
		}
		/*txt.onKillFocus = function(newFocus:Object) {
			var o:Object = ref;
			trace("InputTextField onKillFocus ");
			trace("InputTextField onKillFocus " + o.enabledFlag);
			trace("InputTextField onKillFocus "+o.thisID);
			if (!o.enabledFlag) {// && o.enabledInstanceID) || (!o.enabledFlag && o.enabledInstanceID != o.thisID)){
				trace("InputTextField onKillFocus: don't broadcaster");
				return;
			}else {
				trace("InputTextField onKillFocus: broadcaster");
				//o._enable = false;
				if (o.broadcaster != undefined)
					o.broadcaster._function.call(o.broadcaster._parent, { scope:o.broadcaster._parent,event:"onKillFocus", position:o.position} );
			}
		}*/
		
		return true;
	}
	public function removeEventFunction():Boolean {
		delete txt.onSetFocus;
		txt.onSetFocus = null;
		delete txt.onKillFocus;
		txt.onKillFocus = null;
		return (delete broadcaster);
	}
	public function destroy()
	{
		this._enable = false;
		removeEventFunction();
		txt.removeListener(this);
		txt.removeTextField();
		inputModeSymbol.removeMovieClip();
		delete inputModeSymbol;
		delete broadcaster;
		delete txt;
		delete txtFormat;
		delete this;
	}
	/*****************************************
	 ******		The Private Methods		******
	 *****************************************/
	//private function onKeyPressed(keyCode:Number)	// mydn
	private function onKeyDown(keyCode:Number)	// vupn
	{
		trace("InputTextField::onKeyPressed(" + keyCode + ")");
		switch(keyCode)
		{
			case KeyCodes.BUTTON_LEFT:
			case KeyCodes.BUTTON_RIGHT:
			case KeyCodes.BUTTON_UP:
			case KeyCodes.BUTTON_DOWN:
			case KeyCodes.BUTTON_ENTER:
				if (broadcaster != undefined)	
					broadcaster._function.call(broadcaster._parent, { scope:broadcaster._parent, event:"onKillFocus", position:position } );
				//broadcaster._function.call(broadcaster._parent, { event:"onRollOut", value:keyCode } );
				break;
			case KeyCodes.BUTTON_MENU:
				var mod = this.getInputMode();
				if (mod == 2)
					mod = 0;
				else
					mod++;
				this.inputMode = mod;
				inputModeSymbol._visible = true;
				break;
		}
	}
}