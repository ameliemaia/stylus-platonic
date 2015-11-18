
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
        min_scale      : 1
        max_scale      : 10

    el                 : null
    width              : 0
    height             : 0    
    perspective        : 0
    rotation_x         : 0
    rotation_y         : 0
    rotation_lock_x    : 0
    rotation_lock_y    : 0
    gimball_radius     : 100

    scale: 1
    pivot_x: 0
    pivot_y: 0
    pivot_z: 0

    ###
    constructor
    @param {$element} el
    ###

    constructor: ( @el, gui ) ->

        # return

        # Get perspective
        @config.perspective = parseFloat @el.css 'perspective'
        @perspective = @config.perspective

        # Get all transformable objects
        @_$objects = $('[data-camera-transform="1"]')
        
        # Events
        @el.mousemove ( event ) => @_on_mouse_move event
        @el.mouseup ( event ) => @_on_mouse_up event
        @el.mousedown ( event ) => @_on_mouse_down event
        @el.on 'mousewheel', @_on_mouse_wheel
        @el.on 'MozMousePixelScroll', @_on_mouse_wheel

        cam_settings = gui.addFolder 'Camera'
        cam_settings.add @, 'perspective', 0, 2000
        cam_settings.open()

        cam_settings.add(@, 'scale', 1, 10).name('zoom').listen().onChange => @_update_viewport @config.rotation_x, @config.rotation_y

        range = 1000

        cam_settings.add(@, 'pivot_x', -range, range).onChange => @_update_viewport @config.rotation_x, @config.rotation_y
        cam_settings.add(@, 'pivot_y', -range, range).onChange => @_update_viewport @config.rotation_x, @config.rotation_y
        cam_settings.add(@, 'pivot_z', -range, range).onChange => @_update_viewport @config.rotation_x, @config.rotation_y
        cam_settings.add(@, 'rotation_x').listen()
        cam_settings.add(@, 'rotation_y').listen()
        cam_settings.add(@, 'reset')

        @_update_viewport @config.rotation_x, @config.rotation_y


    ###
    Update the camera
    ###

    update: ->

        # Update perspective 
        @el.css 'perspective' : @perspective + 'px'

        # Update rotation from user drag
        if @_dragging

            dist_x = @_mouse.x  - @_mouse.lx
            dist_y = @_mouse.ly - @_mouse.y

            pct_x = (dist_x / @gimball_radius)
            pct_y = (dist_y / @gimball_radius)

            pct_x *= 0.1
            pct_y *= 0.1

            rx = @_rotation_lock_x + (@config.max_rotation_x * pct_y)
            ry = @_rotation_lock_y + (@config.max_rotation_y * pct_x)

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

            transform = [
                "rotateX(#{@rotation_x}deg) rotateY(#{@rotation_y}deg)" 
                "scale3d(#{@scale},#{@scale},#{@scale})"
                "translateX(#{@pivot_x}px) translateY(#{@pivot_y}px) translateZ(#{@pivot_z}px)"
            ].join(' ')

            $(object).css
                '-webkit-transform' : transform  
                '-moz-transform'    : transform  
                '-ms-transform'     : transform  
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

        @_rotation_lock_x = @rotation_x
        @_rotation_lock_y = @rotation_y

        @el.css 'cursor', '-webkit-grabbing'

        event.preventDefault()

    _on_mouse_wheel: ( event ) =>

        @scale += event.originalEvent.wheelDelta * 0.001

        @scale = Math.max( @scale, @config.min_scale )
        @scale = Math.min( @scale, @config.max_scale )

        @_update_viewport @rotation_x, @rotation_y 
        # console.log @scale

        

    ###
    Viewport mouse up handler
    @param {Object} event
    ###

    _on_mouse_up: ( event ) ->

        @_dragging = false

        @el.css 'cursor', 'inherit'
