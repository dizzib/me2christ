Http = require \http
Ns   = require \node-static
Dir  = require \./constants .dir

const PORT = 7777

module.exports =
  start: ->
    ns = new Ns.Server Dir.build.SITE
    s = Http.createServer (req, resp) ->
      l = req.addListener \end -> ns.serve req, resp
      l.resume!
    s.listen PORT, ->
      log "Express server http listening on port #PORT"
