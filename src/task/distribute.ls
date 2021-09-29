C     = require \./constants
Dir   = require \./constants .dir
Shell = require \shelljs/global
Smg   = require \sitemap-generator

module.exports =
  publish-local: ->
    const DEST = \app
    log "publish to #DEST"
    rm \-rf "#DEST/*"
    for dir in <[ src task ]> then cp \-r "#{Dir.BUILD}/#dir" DEST
    cp "#{Dir.BUILD}/package.json*" DEST

    # generate sitemap
    const PATH = "#{Dir.build.SITE}/sitemap.xml"
    const URL = "http://localhost:#{C.PORT}"
    const URL-PROD = \https://www.me2christ.com
    const RX = new RegExp URL, \g

    g = Smg URL, filepath:PATH
    g.on \done -> sed '-i', RX, URL-PROD, PATH
    g.start!
