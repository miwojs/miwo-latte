Latte = require './Latte'


class LatteFactory extends Miwo.Object

	latteCompiler: @inject('latteCompiler')


	create: ->
		return new Latte(@latteCompiler)


module.exports = LatteFactory