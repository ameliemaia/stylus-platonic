gulp 			= require 'gulp'
stylus      	= require 'gulp-stylus'
jade        	= require 'gulp-jade'
nib 	    	= require 'nib'
prefix      	= require 'gulp-autoprefixer'
connect 		= require 'gulp-connect'
coffee 			= require 'gulp-coffee'
gulpif 			= require 'gulp-if'
browserSync 	= require 'browser-sync'
gutil 			= require 'gulp-util'
newer 			= require 'gulp-newer' 

handleError = ( (err) ->
	gutil.log err
	gutil.beep()
	this.emit 'end'
)

paths = {
	platonic:
		watch: './src/stylus/**/*.styl'
	scripts:
		source: './src/coffee/examples/**/*.coffee'
		watch: './src/coffee/examples/**/*.coffee'
		destination: './examples/public/js/'
		filename: 'app.js'
	styles:
		source: './examples/src/stylus/**/*.styl'
		watch: './examples/src/stylus/**/*.styl'
		destination: './examples/public/css'
	templates:
		source: './examples/src/jade/*.jade'
		watch: './examples/src/jade/**/*.jade'
		destination: './examples/public/'
}

###
Styles
###

gulp.task( 'styles', ->
	gulp
		.src( paths.styles.source )
		.pipe(stylus({
			use: [ nib(), require('./')() ]
			linenos: true
		}))
		.on( 'error', handleError )
		.pipe( newer( paths.styles.destination ) )
		.pipe( gulp.dest paths.styles.destination )
		.pipe( prefix 'last 2 versions' )
		.pipe( browserSync.stream() )
)

###
Templates
###

gulp.task( 'templates', ->

	gulp.src( paths.templates.source )
		.pipe( jade( pretty: true ) )
		.on( 'error', handleError )
		.pipe( newer( paths.templates.destination ) )
		.pipe( gulp.dest paths.templates.destination )
		.pipe( browserSync.stream() )
)

###
Scripts
###

gulp.task( 'scripts', ->

	gulp.src( paths.scripts.source )

		.pipe( coffee( bare: true ) )
		.on('error', handleError )
		.pipe( gulp.dest paths.scripts.destination )
		.pipe( browserSync.stream() )
)


###
Server
###

gulp.task( 'server', ->
	
	connect.server({
		root: __dirname + '/examples/public'
		port: 3000
	})
)

###
Browsersync
###

gulp.task( 'browser-sync', ->

	browserSync({
		proxy: 'localhost:3000'
		notify: off
		reloadDelay: 0
		logLevel: "info"
	})
)

###
Watch
###

gulp.task( "watch", ->

	gulp.watch( paths.templates.watch, [ 'templates' ] )
	gulp.watch( paths.platonic.watch, [ 'styles' ] )
	gulp.watch( paths.styles.watch, [ 'styles' ] )
	gulp.watch( paths.scripts.watch, [ 'scripts' ] )
)

gulp.task "build", ['styles', 'templates', 'scripts']
gulp.task "default", ['build', 'server', 'browser-sync', 'watch']