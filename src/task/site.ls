C    = require \./constants
Http = require \http
L    = require \livereload
Ns   = require \node-static

module.exports =
  start: ->
    ns = new Ns.Server C.dir.build.SITE
    s = Http.createServer (req, resp) ->
      l = req.addListener \end -> ns.serve req, resp
      l.resume!
    s.listen C.PORT, -> log "Http server listening on port #{C.PORT}"
    L.createServer!watch C.dir.build.SITE
