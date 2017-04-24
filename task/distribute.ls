Shell = require \shelljs/global
Dir   = require \./constants .dir

module.exports = ->
  if /package.json/.test it or not it
    if test \-e pjson = "#{Dir.BUILD}/package.json"
      cp \-f pjson, Dir.ROOT
