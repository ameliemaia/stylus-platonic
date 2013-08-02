class AudioPlayer

	volume: 0
	percent: 0
	current_time: 0

	constructor: ( @id ) ->

		@on                = new Object()
		@on.timeupdate     = new signals.Signal()
		@on.loadedmetadata = new signals.Signal()

		@audio      = document.getElementById @id
		@audio.loop = true
		
		@set_volume 0.5

	
	setup: =>

		@audio.addEventListener 'timeupdate', @_on_time_update
		@audio.addEventListener 'loadedmetadata', @_on_audio_ready

	get_duration: -> @audio.duration
	get_current_time: -> @audio.currentTime
	set_volume: (@volume) -> @audio.volume = @volume

	play: => @audio.play()

	_on_audio_ready: =>
		if @on.loadedmetadata.getNumListeners() > 0
			@on.loadedmetadata.dispatch()

	_on_time_update: =>

		@current_time = @get_current_time()
		@percent = (@current_time / @get_duration()) * 100

		if @on.timeupdate.getNumListeners() > 0
			@on.timeupdate.dispatch @percent


class IndexView

	percent: 0
	current_time: 0

	constructor: ->

		# DUPLICATE PHOTON SHADERS...

		# Pause webkit animation on scene rotate

		# return off

		@timeline = {
			'0': {
				in: {
					'icosahedron': ['in']
				}
			}
			# '11':{
			# 	in: {
			# 		'dodecahedron': ['in']
			# 	}
			# }
			# '17':{
			# 	in: {
			# 		'dodecahedron': ['glitch']
			# 	}
			# }
			# '20':{
			# 	out: {
			# 		'dodecahedron': ['glitch']
			# 	}
			# }
			# '24':{
			# 	in: {
			# 		'hexahedron': ['in']
			# 	}
			# }
			# '46':{
			# 	in: {
			# 		'octahedron': ['in']
			# 	}
			# }
			# '81':{
			# 	in: {
			# 		'tetrahedron': ['in']
			# 	}
			# }
			# '94': {
			# 	out: {
			# 		'dodecahedron': ['in']
			# 	}
			# }
			# '95': {
			# 	out: {
			# 		'hexahedron'  : ['in']
			# 	}
			# }
			# '96': {
			# 	out: {
			# 		'octahedron'  : ['in']
			# 	}
			# }
			# '97': {
			# 	out: {
			# 		'tetrahedron' : ['in']
			# 	}
			# }
		}

		@gui_sound = window.gui.addFolder 'Sound'
		@gui_sound.open()

		@player = new AudioPlayer 'audio'

		@player.on.loadedmetadata.addOnce @on_audio_ready
		@player.on.loadedmetadata.add @on_time_update

		@player.setup()


	on_audio_ready: =>


		@gui_sound.add(@player, 'volume', 0, 1).onChange (e) => @player.set_volume e
			
		@gui_sound.add(@player, 'current_time', 0, @player.get_duration()).listen()
		@gui_sound.add(@player, 'percent', 0, 100).listen()

		@player.play()


	on_time_update: (@percent) => @update_animation()

	update_animation: =>

		# push animation stack 

		keyframe = Math.floor @percent

		if @timeline[keyframe] and @last_keyframe isnt keyframe
			for obj of @timeline[keyframe]
				for id of @timeline[keyframe][obj]

					el 	= document.getElementById id

					if obj is 'in'
						method = 'addClass'
					else
						method = 'removeClass'

					$(el)[method] cls for cls in @timeline[keyframe][obj][id]

			@last_keyframe = keyframe


	
$ -> new IndexView()