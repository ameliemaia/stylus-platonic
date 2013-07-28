
window.log = (args...) => console?.log args...    

class Scene

    stats : {
        groups         : 0
        meshes         : 0
        faces          : 0
        photon_shaders : 0
        ui_components  : 0 
    }

    constructor: ->

        @$window   = $(window)

        # Viewport
        @$viewport = $ '.platonic-viewport'
        @$scene    = @$viewport.find '.scene'

        # Lighting
        @light       = new Photon.Light()
        @face_groups = []

        # Define facegroups
        $('.group:not(.mesh > .group):not([data-light="0"]), .mesh:not(.group > .mesh):not([data-light="0"])').each (index, element) =>
            face_group = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true)
            @face_groups.push face_group

        # Add camera
        @cam = new Camera @$viewport

        # Stats
        @fps = new Stats()
        @$viewport.append @fps.domElement

        @stats.groups         = $('.group').length
        @stats.meshes         = $('.mesh').length
        @stats.faces          = $('.face').length
        @stats.photon_shaders = $('.photon-shader').length
        @stats.ui_components  = $('.ui-component').length

        # GUI
        @gui = new dat.GUI()

        scene_stats = @gui.addFolder 'Scene'
        scene_stats.add(@stats, 'groups').listen()
        scene_stats.add(@stats, 'meshes').listen()
        scene_stats.add(@stats, 'faces').listen()
        scene_stats.add(@stats, 'photon_shaders').listen()
        scene_stats.add(@stats, 'ui_components').listen()
        # scene_stats.open()

        cam_settings = @gui.addFolder 'Camera'
        cam_settings.add @cam, 'perspective', 0, 2000
        cam_settings.add(@cam, 'rotation_x').listen()
        cam_settings.add(@cam, 'rotation_y').listen()
        cam_settings.add(@cam, 'reset')
        # cam_settings.open()

        # Events
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

        @fps.begin()

        # Update cam
        @cam.update()
    
        # Update lighting
        if @face_groups.length > 0
            for face_group in @face_groups
                face_group.render(@light, true)

        @fps.end()


    loop: =>

        @update()
        requestAnimationFrame(@loop)

$ -> scene = new Scene()