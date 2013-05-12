$ ->

    Scene = ->

        # Viewport
        $viewport = $('.platonic-viewport')
        $scene    = $viewport.find('section.scene')


        # Photon
        light      = new Photon.Light()
        faceGroups = []

        # Create Photon Facegroups
        $('div.mesh-group:not([data-light="0"]), div.mesh:not(div.mesh-group > div.mesh):not([data-light="0"])').each (index, element) =>
            faceGroup = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true)
            faceGroups.push faceGroup


        # Stats
        stats = new Stats()
        setInterval ->
            stats.begin()
            for faceGroup in faceGroups
                faceGroup.render(light, true)
            stats.end()
            
        stats.domElement.style.position = 'absolute'
        stats.domElement.style.top      = 0
        stats.domElement.style.left     = 0
        $viewport.append stats.domElement


        # Event listeners
        $(window).resize ->
            
            height = $(window).height()
            
            $viewport.css height: height + 'px'
            $scene.css    height: height + 'px'
        
        .trigger 'resize'


    scene = new Scene()


