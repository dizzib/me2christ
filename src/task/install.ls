Assert = require \assert
Shell  = require \shelljs/global
Dir    = require \./constants .dir

module.exports =
  delete-modules: ->
    dir = "#{Dir.BUILD}/node_modules"
    log "delete #dir/*"
    rm \-rf "#dir/*"

  refresh-modules: ->
    pushd Dir.BUILD
    try
      Assert.equal pwd!, Dir.BUILD
      exec 'npm -v'
      exec 'npm prune'
      exec 'npm install'
    finally
      popd!
