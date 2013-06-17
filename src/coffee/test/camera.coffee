
class Camera

    ###
    @private
    ###

    _$objects : Array
    _mouse    : {x:0, y:0, lx:0, ly:0}
    _dragging : false

    ###
    @public
    ###
    config :
        perspective    : 0
        rotation_x     : -30
        rotation_y     : -45
        max_rotation_x : 360
        max_rotation_y : 360

    el                 : null
    width              : 0
    height             : 0    
    perspective        : 0
    rotation_x         : 0
    rotation_y         : 0
    gimball_radius     : 100


    ###
    constructor
    @param {$element} el
    ###

    constructor: ( @el ) ->

        # Get perspective
        @config.perspective = parseFloat @el.css 'perspective'
        @perspective = @config.perspective

        # Get all transformable objects
        @_$objects = $('[data-camera-transform="1"]')
        
        # Events
        @el.mousemove ( event ) => @_on_mouse_move event
        @el.mouseup ( event ) => @_on_mouse_up event
        @el.mousedown ( event ) => @_on_mouse_down event

        @_update_viewport @config.rotation_x, @config.rotation_y


    ###
    Update the camera
    ###

    update: ->

        # Update perspective 
        @el.css 'perspective', @perspective + 'px'

        # Update rotation from user drag
        if @_dragging

            dist_x = @_mouse.x  - @_mouse.lx
            dist_y = @_mouse.ly - @_mouse.y

            pct_x = (dist_x / @gimball_radius)
            pct_y = (dist_y / @gimball_radius)

            pct_x *= 0.01
            pct_y *= 0.01

            rx = @rotation_x + (@config.max_rotation_x * pct_y)
            ry = @rotation_y + (@config.max_rotation_y * pct_x)

            if ry > 360
                ry -= 360
            else if ry < -360
                ry += 360

            if rx > 360
                rx -= 360
            else if rx < -360
                rx += 360

            @_update_viewport rx, ry


    ###
    Resize the viewport
    ###

    resize: ->

        @width  = @el.width()
        @height = @el.height()

    ###
    Reset the viewport rotation
    ###

    reset: => 

        @_update_viewport @config.rotation_x, @config.rotation_y 


    ###
    Update the viewport
    @param {Number} rotation_x
    @param {Number} rotation_y
    ###

    _update_viewport: ( @rotation_x, @rotation_y ) =>

        for object in @_$objects

            transform = "rotateX(#{@rotation_x}deg) rotateY(#{@rotation_y}deg)"    

            $(object).css
                '-webkit-transform' : transform  
                'transform'         : transform  

        return off

    ###
    Viewport mouse move handler
    @param {Object} event
    ### 

    _on_mouse_move: ( event ) ->

        @_mouse.x = event.pageX
        @_mouse.y = event.pageY


    ###
    Viewport mouse down handler
    @param {Object} event
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
    ###

    _on_mouse_up: ( event ) ->

        @_dragging = false

        @el.css 'cursor', 'inherit'