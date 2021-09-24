Assert = require \assert
Shell  = require \shelljs/global
Dir    = require \./constants .dir

module.exports =
  delete-modules: ->
    dir = "/node_modules"
    log "delete #dir/*"
    rm \-rf "#dir/*"

  refresh-modules: ->
    pushd Dir.ROOT
    try
      Assert.equal pwd!, Dir.ROOT
      exec 'npm -v'
      exec 'npm prune'
      exec 'npm install'
    finally
      popd!
