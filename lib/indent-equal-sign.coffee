#
# * indent-equal-sign
# * https://github.com/fengzilong/indent-equal-sign
# *
# * Copyright (c) 2016 fengzilong
# * Licensed under the MIT license.
#
{ CompositeDisposable } = require 'atom'

module.exports =
	activate: (state) ->
		@subscriptions = new CompositeDisposable

		@subscriptions.add atom.commands.add 'atom-workspace',
			'indent-equal-sign:indent': => @indent()

	indent: () ->
		if editor = atom.workspace.getActiveTextEditor()
			content = editor.getSelectedText()
			tabLen = editor.getTabLength()

			content = content.replace(/( *)=/g, '=')
			lines = content.split('\n')

			colNums = []
			lines.forEach(
				( line ) ->
					line = line.replace(/\t/g, ' '.repeat( tabLen ))
					colNums.push( line.indexOf('=') )
			)

			maxColNum = Math.max.apply(Math, colNums)

			lines = lines.map(
				( line, i ) ->
					if ~colNums[ i ]
						line = line.replace(/(=)/g, () ->
							return ' '.repeat(maxColNum - colNums[ i ] + 1) + '='
						)
					
					return line
			)

			editor.insertText( lines.join('\n') )

	deactivate: ->
		@subscriptions.dispose()
	serialize: -> # ...
