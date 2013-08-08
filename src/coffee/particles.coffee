class ParticlesView

	particles: 0

	constructor: ->

		@particles = $('.particle').length

		window.scene_stats.add @, 'particles'

		window.PLATONIC_SCENE.add_ui_controls()

$ -> new ParticlesView()