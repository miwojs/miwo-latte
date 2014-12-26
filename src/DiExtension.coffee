LatteFactory = require './LatteFactory'
LatteCompiler = require './LatteCompiler'


class LatteExtension extends Miwo.di.InjectorExtension


	init: ->
		@setConfig
			macros:
				core: require './CoreMacroSet'
				component: require './ComponentMacroSet'
		return


	build: (injector) ->
		injector.define 'latteFactory', LatteFactory, (service)=>
			return

		injector.define 'latteCompiler', LatteCompiler, (service)=>
			for name,macroSetClass of @config.macros
				macroSet = new macroSetClass()
				macroSet.install(service)
			return

		# service is need for module templates
		injector.define 'templateRendererFactory', LatteFactory
			.setFactory => injector.get('latteFactory')
		return



module.exports = LatteExtension