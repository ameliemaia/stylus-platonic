
delay = (ms, func) -> setTimeout func, ms

class AudioPlayer

	volume: 0
	percent: 0
	current_time: 0

	constructor: ( @id ) ->

		@on                = new Object()
		@on.timeupdate     = new signals.Signal()
		@on.loadedmetadata = new signals.Signal()
		@on.ended          = new signals.Signal()

		@audio = document.getElementById @id
		
	
	setup: =>

		@audio.addEventListener 'timeupdate', @_on_time_update
		@audio.addEventListener 'loadedmetadata', @_on_audio_ready
		@audio.addEventListener 'ended', @_on_audio_ended

	get_duration: -> @audio.duration
	get_current_time: -> @audio.currentTime
	set_volume: (@volume) -> @audio.volume = @volume

	play: => @audio.play()

	_on_audio_ready: =>
		if @on.loadedmetadata.getNumListeners() > 0
			@on.loadedmetadata.dispatch()

	_on_audio_ended: =>
		if @on.ended.getNumListeners() > 0
			@on.ended.dispatch()

	_on_time_update: =>

		@current_time = @get_current_time()
		@percent = (@current_time / @get_duration()) * 100

		if @on.timeupdate.getNumListeners() > 0
			@on.timeupdate.dispatch @percent


class IndexView

	percent: 0
	current_time: 0

	song: {
		credits: 'therall toge © hems'
	}

	constructor: ->

		@timeline = {
			# Icosahedron animates in
			'0': {
				in: {
					'icosahedron' : ['in-1']
				}
			}
			# Dodecahedron animaties / glitches in
			# Icosahedron glitches in
			'17':{
				in: {
					'dodecahedron' : ['in-1', 'glitch-1']
					'icosahedron'  : ['glitch-1']
				}
			}
			# Icosahedron / Dodecahedron animates out
			# Hexahedron animations in
			'31': {
				in: {
					'icosahedron' : ['out-1']
					'dodecahedron': ['out-1']
					'hexahedron'  : ['in-1']
				}
			}
			# Octahedron animations in
			# Clear animation classes
			'47':{
				in: {
					'octahedron' : ['in-1']
				}
				out: {
					'icosahedron'  : ['in-1', 'glitch-1', 'out-1']
					'dodecahedron' : ['in-1', 'glitch-1', 'out-1']
				}
			}
			'66':{
				in: {
					'tetrahedron' : ['in-1']
					'octahedron'  : ['out-1']
					'hexahedron'  : ['out-1']
				}
			}
			'77':{
				in: {
					'tetrahedron' : ['glitch-1']
				}
			}
			'90':{
				in: {
					'icosahedron' : ['in-2', 'glitch-2']
				}
			}
			'91':{
				in: {
					'dodecahedron' : ['in-2', 'glitch-2']
				}
			}
			'92':{
				in: {
					'octahedron' : ['in-2', 'glitch-2']
				}
			}
			'93':{
				in: {
					'hexahedron' : ['in-2', 'glitch-2']
				}
			}
			'98':{
				out: {
					'icosahedron'  : ['in-2', 'glitch-2']
					'dodecahedron' : ['in-2', 'glitch-2']
					'hexahedron'   : ['in-1', 'out-1', 'in-2', 'glitch-2']
					'octahedron'   : ['in-1', 'out-1', 'in-2', 'glitch-2']
					'tetrahedron'  : ['in-1', 'glitch-1']
				}
			}
		}

		@gui_sound = window.gui.addFolder 'Sound'

		@player = new AudioPlayer 'audio'

		@player.on.loadedmetadata.addOnce @on_audio_ready
		@player.on.timeupdate.add @on_time_update
		@player.on.ended.add @on_audio_ended
		@player.set_volume 0.5
		@player.setup()


	on_audio_ready: =>

		@gui_sound.add(@player, 'volume', 0, 1).onChange (e) => @player.set_volume e
		@gui_sound.add(@song, 'credits')
		@gui_sound.open()
			
		# @gui_sound.add(@player, 'current_time', 0, @player.get_duration()).listen()
		# @gui_sound.add(@player, 'percent', 0, 100).listen()

		@player.play()

	on_audio_ended: => 

		delay 2000, => @player.play()

	on_time_update: (@percent) => @update_animation()

	update_animation: =>

		# Updated animation stack 

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