global.log = console.log

WFib  = require \wait.for .launchFiber
Build = require \../build
Dir   = require \../constants .dir

cd Dir.BUILD
Build.start!
setTimeout run, 1000 # give chokidar time to build its _watched

function run
  <- WFib
  Build.all!
  Build.stop!
