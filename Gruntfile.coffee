fs = require 'fs'

list_files = (path, ext) =>
    fs.readdirSync(path).filter (file) =>
        ~file.indexOf ext
    .map (file) =>
        file.replace ext, ''

module.exports = ( grunt ) ->

    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-stylus'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-connect'

    test_src = 
        styl   : 'src/stylus'
        jade   : 'src/jade'
        coffee : 'src/coffee'

    test_out = 
        styl   : 'public/css'
        jade   : 'public'
        coffee : 'public/js'

    files = 
        jade   : {}
        styl   : {}
        coffee : {}

    styl   = list_files test_src.styl, '.styl'
    jade   = list_files test_src.jade, '.jade'
    coffee = list_files test_src.coffee, '.coffee'

    for file in styl
        src  = test_src.styl + '/' + file + '.styl'
        dest = test_out.styl + '/' + file + '.css'
        files.styl[dest] = src

    for file in jade
        src  = test_src.jade + '/' + file + '.jade'
        dest = test_out.jade + '/' + file + '.html'
        files.jade[dest] = src

    for file in coffee
        src  = test_src.coffee + '/' + file + '.coffee'
        dest = test_out.coffee + '/' + file + '.js'
        files.coffee[dest] = src

    grunt.initConfig

        connect:
            server:
                options:
                    port: 9056
                    base: test_out.jade

        jade:
            compile:
                options: 
                    pretty: true
                files: files.jade
            
        stylus: 
            compile: 
                options: 
                    compress: false
                    use: [
                        require 'nib'
                        require 'stylus-platonic'
                    ]
                files: files.styl

        coffee:
            compile:
                options:
                    bare: true
                files: files.coffee
            
        watch: 
            all: 
                files: [
                     "#{test_src.styl}/**/*.styl"
                     "#{test_src.jade}/**/*.jade"
                     "#{test_src.coffee}/**/*.coffee"
                ]
                tasks: [
                    'stylus'
                    'jade'
                    'coffee'
                ]

    grunt.registerTask 'default', [ 'connect', 'jade:compile', 'stylus:compile', 'coffee:compile', 'watch:all'  ]
