Assert  = require \assert
Chalk   = require \chalk
Choki   = require \chokidar
Cp      = require \child_process
Emitter = require \events .EventEmitter
Fs      = require \fs
_       = require \lodash
Path    = require \path
Shell   = require \shelljs/global
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
G       = require \./growl

const CFG = "#{Dir.SRC}/task/lint"
const MOD = "#{Dir.BUILD}/node_modules"

tasks =
  livescript:
    bin : \ls-lint
    cfg : \ls-lint.lson
    glob: true
    ixt : \ls
    opts: ''
  pug:
    bin : \pug-lint
    cfg : \.pug-lintrc.js
    glob: false
    ixt : \pug
    opts: ''
  sass:
    bin : \stylelint
    cfg : \.stylelintrc.js
    glob: true
    ixt : \sass
    opts: "--config-basedir #MOD --custom-syntax #MOD/postcss-sass"

module.exports = me = (new Emitter!) with
  all: ->
    for tid of tasks then
      t = tasks[tid]
      if t.glob then lint-glob t else lint-batch t

  start: ->
    log Chalk.green 'start lint'
    try
      pushd Dir.SRC
      for tid of tasks then start-watching tid
    finally
      popd!

  stop: ->
    log Chalk.red 'stop lint'
    for , t of tasks then t.watcher?close!

## helpers

function get-cmd t, ipath
  "#MOD/.bin/#{t.bin} --config #CFG/#{t.cfg} #{t.opts} '#{ipath}'"  # must quote for glob

function lint t, ipath
  cmd = get-cmd t, ipath
  log Chalk.gray cmd
  try Cp.execSync cmd, stdio:\inherit catch err

function lint-batch t
  w = t.watcher.getWatched!
  files = [f for path, names of w for name in names
    when test \-f f = Path.resolve Dir.SRC, path, name]
  info = "#{files.length} #{t.ixt} files"
  G.say "linting #info..."
  for f in files then lint t, f
  G.ok "...done #info!"

function lint-glob t
  cmd = get-cmd t, "#{Dir.SRC}/**/*.#{t.ixt}"
  log Chalk.gray cmd
  try Cp.execSync cmd, stdio:\inherit catch err

function start-watching tid
  log "start watching #tid"
  Assert.equal pwd!, Dir.SRC
  pat = (t = tasks[tid]).pat or "*.#{t.ixt}"
  dirs = "#{Dirname.SITE},#{Dirname.TASK}"
  w = t.watcher = Choki.watch ["{#dirs}/**/#pat" pat],
    cwd:Dir.SRC
    ignoreInitial:true
    ignored:t.ignore
    persistent: false
  # workaround chokidar issue #1084 by using 'raw' rather than 'add'
  w.on \raw _.debounce process, 50ms, leading:false trailing:true

  function process act, fname, details
    return unless _.endsWith fname, ".#{t.ixt}"
    ipath = Path.resolve(details.watchedPath, fname)
    # log Chalk.yellow(\lint), act, tid, ipath
    switch act
    | \add \change
      try lint t, ipath
      catch e then return G.err ipath
      G.ok
