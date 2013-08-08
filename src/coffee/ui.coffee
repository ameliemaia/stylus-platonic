class UserInterface

	###
	@private
	###

	###
	@public
	###

	grid	     : false
	display_axis : false
	beautify     : false

	###
	constructor
	@param {$element} el
	###

	constructor: ( @el ) ->

		@$display_axis = @el.find '.ui-component.display-axis'
		@$grid         = @el.find '.ui-component.grid'

	update: =>

		@_toggle_grid @grid
		@_toggle_display_axis @display_axis


	_toggle_grid: ( state ) =>

		if state
			@$grid.removeClass 'hide'
		else
			@$grid.addClass 'hide'


	_toggle_display_axis: ( state ) =>

		if state
			@$display_axis.removeClass 'hide'
		else
			@$display_axis.addClass 'hide'
