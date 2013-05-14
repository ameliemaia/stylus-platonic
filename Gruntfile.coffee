
module.exports = ( grunt ) ->
    
    files    = require './test/files'

    grunt.initConfig

        jade:
            compile:
                options: 
                    pretty: true
                
                files: files.jade
            
        
        stylus: 
            compile: 
                options: 
                    compress: false,
                    use: [
                        require 'nib'
                        require './'
                    ]
                
                files: files.stylus
            
        watch: 
            all: 
                files: [
                    './src/**/*.styl',
                    './test/cases/styl/**/*.styl',
                    './test/cases/jade/**/*.jade'
                ],
                tasks: [
                    'stylus',
                    'jade'
                ]
            
            css: 
                files: [
                    './src/**/*.styl',
                    './test/cases/styl/**/*.styl'
                ],
                tasks: [
                    'stylus'
                ]
            
            html: 
                files: [
                    './test/cases/jade/**/*.jade'
                ]
                tasks: [
                    'jade'
                ]
            

    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-stylus'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'default', [ 'watch:all' ]
    # grunt.registerTask 'css',     'watch:css'
    # grunt.registerTask 'html',    'watch:html'
