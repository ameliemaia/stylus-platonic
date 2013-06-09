
window.log = (args...) => console?.log args...

class Scene

    constructor: ->

        @$window   = $(window)

        ## Viewport
        @$viewport = $('.platonic-viewport')
        @$scene    = @$viewport.find('section.scene')

        ## Lighting
        @light       = new Photon.Light()
        @face_groups = []

        ## Define facegroups
        $('.group:not([data-light="0"]), .mesh:not(.group > .mesh):not([data-light="0"])').each (index, element) =>
            face_group = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true)
            @face_groups.push face_group

        log @face_groups

        ## Add camera
        @cam = new Camera( @$viewport )

        ## Stats
        @stats = new Stats()
        @$viewport.append @stats.domElement

        ## GUI
        @gui = new dat.GUI()

        cam_settings = @gui.addFolder 'Camera'
        cam_settings.add @cam, 'perspective', 0, 2000
        cam_settings.add @cam, 'base_rotation_x'
        cam_settings.add @cam, 'base_rotation_y'
        cam_settings.add(@cam, 'rotate_x' ).listen()
        cam_settings.add(@cam, 'rotate_y' ).listen()
        cam_settings.add @cam, 'manual_rotate'
        cam_settings.add @cam, 'gimball_radius'
        cam_settings.add @cam, 'max_rotation_x'
        cam_settings.add @cam, 'max_rotation_y'
        cam_settings.open()

        ## Events
        @$window.resize => @on_resize()
        @$window.trigger 'resize'

        @loop()


    on_resize: ->

        @win_width  = @$window.width()
        @win_height = @$window.height()
            
        @$viewport.css height: @win_height + 'px'
        @$scene.css    height: @win_height + 'px'

        @cam.resize()


    update: ->

        @stats.begin()

        ## Update cam
        @cam.update()
    
        ## Update lighting
        if @face_groups.length > 0
            for face_group in @face_groups
                face_group.render(@light, true)

        @stats.end()


    loop: =>

        @update()
        requestAnimationFrame(@loop)


$ -> scene = new Scene()