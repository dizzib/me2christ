global.log = console.log

Chalk  = require \chalk
_      = require \lodash
Rl     = require \readline
Shell  = require \shelljs/global
Build  = require \./build
Consts = require \./constants
Dir    = require \./constants .dir
Dist   = require \./distribute
G      = require \./growl
Inst   = require \./install
Site   = require \./site

const CHALKS = [Chalk.stripColor, Chalk.yellow, Chalk.red]
const COMMANDS =
  * cmd:'h ' level:0 desc:'help  - show commands'          fn:show-help
  * cmd:'b ' level:0 desc:'build - all'                    fn:Build.all
  * cmd:'bd' level:1 desc:'build - delete'                 fn:Build.delete
  * cmd:'id' level:1 desc:'install - delete node_modules'  fn:Inst.delete-modules
  * cmd:'ir' level:0 desc:'install - refresh node_modules' fn:Inst.refresh-modules
  * cmd:'q ' level:0 desc:'QUIT'                           fn:process.exit

config.fatal  = true # shelljs doesn't raise exceptions, so set this process to die on error
#config.silent = true # otherwise too much noise

cd Dir.BUILD # for safety, set working directory to build

for c in COMMANDS then c.display = "#{Chalk.bold CHALKS[c.level] c.cmd} #{c.desc}"

rl = Rl.createInterface input:process.stdin, output:process.stdout
  ..setPrompt "#{Consts.APPNAME} >"
  ..on \line (cmd) ->
    rl.pause!
    for c in COMMANDS when cmd is c.cmd.trim!
      try c.fn!
      catch e then log e
    rl.resume!
    rl.prompt!

Build.on \built ->
  rl.prompt!

Build.start!
Site.start!

_.delay show-help, 500ms
_.delay (-> rl.prompt!), 750ms

# helpers

function build-all
  try Build.all!
  catch e then G.err e

function show-help
  for c in COMMANDS then log c.display
