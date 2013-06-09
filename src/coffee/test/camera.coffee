
class Camera

    ###
    @private
    ###

    _$objects : Array
    _mouse    : 
        x  : 0
        y  : 0
        lx : 0
        ly : 0
    _dragging : false

    ###
    @public
    ###

    el                 : null
    width              : 0
    height             : 0
    perspective        : null
    base_rotation_x    : -30
    base_rotation_y    : 0
    rotate_x           : -30
    rotate_y           : -45
    manual_rotate      : true
    gimball_radius     : 400
    max_rotation_x     : 360
    max_rotation_y     : 360


    ###
    constructor
    @param {$element} el
    @api    private
    ###

    constructor: ( @el ) ->

        # Get perspective
        @perspective = parseFloat @el.css 'perspective'

        # Get all transformable objects
        @_$objects = $('[data-camera-transform]')
        
        # Events
        @el.mousemove ( event ) => @_on_mouse_move( event )
        @el.mouseup ( event ) => @_on_mouse_up( event )
        @el.mousedown ( event ) => @_on_mouse_down( event )


    ###
    Update the camera
    @api public
    ###

    update: ->

        # Update perspective 
        @el.css 'perspective', @perspective + 'px'

        # Update rotation from user click / drag
        # or update from mouse x / y

        if @manual_rotate

            if @_dragging

                dist_x = @_mouse.x  - @_mouse.lx
                dist_y = @_mouse.ly - @_mouse.y

                pct_x = dist_x / @gimball_radius
                pct_y = dist_y / @gimball_radius

                @rotate_x = @base_rotation_x + (@max_rotation_x * pct_y)
                @rotate_y = @base_rotation_y + (@max_rotation_y * pct_x)

        else
            
            pct_x = (@_mouse.x - @width  / 2) / @width
            pct_y = (@height / 2 - @_mouse.y) / @height

            @rotate_x = @base_rotation_x + (@max_rotation_x * pct_y)
            @rotate_y = @base_rotation_y + (@max_rotation_y * pct_x)

        for object in @_$objects

            transform = "rotateX(#{@rotate_x}deg) rotateY(#{@rotate_y}deg)"    

            $(object).css
                '-webkit-transform' : transform  
                'transform'         : transform   

    ###
    Resize the viewport
    @api public
    ###

    resize: ->

        @width  = @el.width()
        @height = @el.height()


    ###
    Viewport mouse move handler
    @param {Object} event
    @api    private
    ###

    _on_mouse_move: ( event ) ->

        @_mouse.x = event.pageX
        @_mouse.y = event.pageY


    ###
    Viewport mouse down handler
    @param {Object} event
    @api    private
    ###

    _on_mouse_down: ( event ) ->

        @_dragging = true
        @_mouse.lx = event.pageX
        @_mouse.ly = event.pageY

        @el.css 'cursor', '-webkit-grabbing'

        event.preventDefault()

    ###
    Viewport mouse up handler
    @param {Object} event
    @api    private
    ###

    _on_mouse_up: ( event ) ->

        @_dragging = false

        @el.css 'cursor', 'inherit'



