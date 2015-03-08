MacroSet = require './MacroSet'


class CoreMacroSet extends MacroSet


	install: (compiler) ->
		super(compiler)
		@addMacro("if", @macroIf, @macroEnd)
		@addMacro("elseif", @macroElseIf)
		@addMacro("else", @macroElse)
		@addMacro("ifset", @macroIfSet)
		@addMacro("elseifset", @macroElseIfSet)
		@addMacro("for", @macroFor, @macroEnd)
		@addMacro("js", @macroJs)
		@addMacro("log", @macroLog)
		@addMacro("=", @macroWrite)
		@addMacro("_", @macroTranslate)
		return


	macroEnd: (content) ->
		return "}"


	macroIf: (content) ->
		return "if(" + content + ") {"


	macroElseIf: (content) ->
		return "} else if(" + content + ") {"


	macroElse: (content) ->
		return "} else {"


	macroIfSet: (content) ->
		return @macroIf "(" + content + ") !== undefined && (" + content + ") !== null)"


	macroElseIfSet: (content) ->
		return @macroElseIf "(" + content + ") !== undefined && (" + content + ") !== null)"


	macroFor: (content) ->
		# for item in array
		if (matches = content.match(/([\S]+)\s+in\s+([\S]+)/))
			name = matches[1]
			property = matches[2]
			return "_items = " + property + "; for(var _i=0,_l=_items.length; _i<_l; _i++) { var " + name + " = _items[_i];"

		# for item,index in array
		else if (matches = content.match(/([\S]+),\s*([\S]+)\s+in\s+([\S]+)/))
			name = matches[1]
			index = matches[2]
			property = matches[3]
			return "_items = " + property + "; for(var "+index+"=0,"+index+"_l=_items.length; "+index+"<"+index+"_l; "+index+"++) { var " + name + " = _items["+index+"];"

		# for name,value of object
		else if (matches = content.match(/([\S]+),\s*([\S]+)\s+of\s+([\S]+)/))
			name = matches[1]
			value = matches[2]
			property = matches[3]
			return "_items = " + property + "; for(var " + name + " in _items) { var " + value + " = _items[" + name + "];"

		# someting else...
		else
			return "for(" + content + ") {"


	macroWrite: (content) ->
		return "string:" + content


	macroJs: (content) ->
		return content + ";"


	macroLog: (content) ->
		return 'console.log('+content+');';


	macroTranslate: (content) ->
		matches = content.match(/([\S]+)(\s+(.*))?/)
		out = ""
		return out  unless matches
		if matches[1].charAt(0) is "\""
			out = "string:miwo.tr(" + matches[1] + ")"
		else
			out = "string:miwo.tr(\"" + matches[1] + "\")"
		out += ".substitute({" + matches[3].replace("\\", "").replace("\\", "") + "})"  if matches[3]
		return out



module.exports = CoreMacroSet