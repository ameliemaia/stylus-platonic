###
    @author DPR http://davidpaulrosser.co.uk
###


# Dependencies

stylus = require 'stylus'
nodes  = stylus.nodes



###
*   Adds default behavior to the url function
*
*   @param  String url
*   @return Literal
###

exports.url = (url) ->
    new nodes.Literal( 'url(' + new nodes.String(url.val) + ')')


###
*   Remove the 'e' constant expression from a floating point number
*   
*   @param  Float num
*   @return Unit
###

exports.removeConstE = ( num ) ->

    str    = String num.val
    index  = str.indexOf 'e-'
    result = null

    if index != -1 then result = str.substr 0, index else result = num.val

    new nodes.Unit( parseFloat result )
