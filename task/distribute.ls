C     = require \./constants
Shell = require \shelljs/global
Smg   = require \sitemap-generator

module.exports = ->
  if /package.json/.test it or not it
    if test \-e pjson = "#{C.dir.BUILD}/package.json"
      cp \-f pjson, C.dir.ROOT

  # generate sitemap locally
  const PATH = "#{C.dir.SITE}/sitemap.xml"
  const URL = "http://localhost:#{C.PORT}"
  const URL-PROD = \https://www.me2christ.com
  const RX = new RegExp URL, \g

  g = Smg URL, filepath:PATH
  g.on \done -> sed '-i', RX, URL-PROD, PATH
  g.start!
