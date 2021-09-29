global.log = console.log

Build = require \../build
Dir   = require \../constants .dir

cd Dir.BUILD
Build.start!
setTimeout run, 1000 # give chokidar time to build its _watched

function run
  Build.all!
  Build.stop!
