var fs = require('fs');


function listFiles(path, ext){
    return fs.readdirSync(path).filter(function(file){
        return ~file.indexOf(ext);
    }).map(function(file){
        return file.replace(ext, '');
    });
}

var files = {stylus: {}, jade: {}};
var styl  = listFiles(__dirname + '/cases/styl', '.styl');
var jade  = listFiles(__dirname + '/cases/jade', '.jade');

var file, src, dest, i;

for(i in styl){
    file = styl[i];
    src  = __dirname + '/cases/styl/'      + file + '.styl';
    dest = __dirname + '/public/css/' + file + '.css';
    files.stylus[dest] = src;
}

for(i in jade){
    file = jade[i];
    src  = __dirname + '/cases/jade/'  + file + '.jade';
    dest = __dirname + '/public/' + file + '.html';
    files.jade[dest] = src;
}


module.exports = files;