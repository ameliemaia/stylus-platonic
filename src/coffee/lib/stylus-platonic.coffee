###
    @author DPR http://davidpaulrosser.co.uk
###


# Dependencies

stylus = require 'stylus'
nodes  = stylus.nodes


# Plugin

plugin = ->
    return ( stylus ) ->
        stylus.define 'url', utils.url
        stylus.define 'remove-const-e', utils.removeConstE
        stylus.include __dirname + '/../src/stylus/'
        return off


# Lib nodes

utils = require './nodes/utils'


# Expose plugin

exports = module.exports = plugin


# Version

exports.version = '0.0.1'


# Path

exports.path = __dirname