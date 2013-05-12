
fs       = require 'fs'
fsu      = require 'fs-util'
glob     = require 'glob'
util     = require 'util'
stylus   = require 'stylus'
platonic = require './'
jade     = require 'jade'
nib      = require 'nib'
{exec}   = require 'child_process' 


lib_src =
    styl   : 'src/stylus/stylus-platonic'
    coffee : 'src/coffee/lib'

lib_out =
    coffee : 'lib'

test_src = 
    styl   : 'test/cases/styl' 
    jade   : 'test/cases/jade'
    coffee : 'src/coffee/test'

test_out = 
    styl   : 'test/public/css' 
    jade   : 'test/public'
    coffee : 'test/public/js'


watch_dirs = [ lib_src, test_src ]


clean = (callback) ->

    util.log 'Cleaning...'

    exec "rm -rf #{'./' + lib_out.coffee}"
    exec "rm -rf #{'./' + test_out.styl}/*.css"
    exec "rm -rf #{'./' + test_out.jade}/*.html"
    exec "rm #{'./' + test_out.coffee}/*.js"

    util.log 'Clean complete'

    callback?()


build = (callback) ->

    util.log "Building..."

    exec "coffee --bare --compile --output #{'./' + lib_out.coffee}/ #{'./' + lib_src.coffee}/", ( err, stdout, stderr ) ->
        util.log err if err

    exec "coffee --bare --compile --output #{'./' + test_out.coffee}/ #{'./' + test_src.coffee}/", ( err, stdout, stderr ) ->
        util.log err if err

    glob test_src.styl + '/**/*.styl', { sync:true }, ( err, matches ) ->
        if matches.length > 0
            for file in matches

                content = fs.readFileSync( file ).toString()

                dest    = file.replace test_src.styl, test_out.styl
                dest    = dest.replace /.styl/, '.css'

                stylus(content)
                    .set('filename', dest)
                    .use(do nib)
                    .use(do platonic)
                    .render (err, css) =>
                        throw err if err?
                        fs.writeFileSync dest, css


    glob test_src.jade + '/*.jade', { sync:true }, (err, matches) ->
        if matches.length > 0
            for file in matches

                    content = fs.readFileSync( file ).toString()

                    dest    = file.replace test_src.jade, test_out.jade
                    dest    = dest.replace /.jade/, '.html'

                    buff    = jade.compile content, { filename:file, pretty:true }
                    html    = buff { title:'async-flow' }

                    fs.writeFileSync dest, html



    util.log "Build complete"

    callback?()
    

publish = (callback) ->

    util.log "Publishing to npm..."

    callback?()


watch = (callback) ->

    util.log "Watching for changes..."

    for dir in watch_dirs
        for group of dir

            ext     = group
            path    = dir[ group ]
            file    = __dirname + '/' + path

            watcher = fsu.watch file, ///.#{ext}$///m, true

            watcher.on 'change', ( f ) ->

                watcher.close()
                callback?()




task 'clean', 'Clean the output directories for the lib and test files', => 
    clean()

task 'build', 'Compile the library source and prepare for publish', => 
    clean -> build()

task 'publish', 'Publish to npm', => 
    publish()

task 'watch', 'Watch source files and build changes', => 
    watch -> build -> invoke 'watch'
    



    