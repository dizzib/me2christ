Assert  = require \assert
Chalk   = require \chalk
Choki   = require \chokidar
Cp      = require \child_process
Cron    = require \cron
Emitter = require \events .EventEmitter
Fs      = require \fs
_       = require \lodash
Path    = require \path
Shell   = require \shelljs/global
Dirname = require \./constants .dirname
Dir     = require \./constants .dir
G       = require \./growl

const BIN = "#{Dir.BUILD}/node_modules/.bin"

pruner = new Cron.CronJob cronTime:'*/10 * * * *' onTick:prune-empty-dirs
tasks  =
  livescript:
    cmd : "#BIN/lsc --output $OUT $IN"
    ixt : \ls
    oxt : \js
    xsub: 'json.js->json'
    mixn: \_
  pug:
    cmd : "#BIN/pug -O '{\"livereload\":#{env.M2C_LIVE_RELOAD}}' --out $OUT $IN"
    ixt : \pug
    oxt : \html
    mixn: \_
  static:
    cmd : 'cp --target-directory $OUT $IN'
    ixt : '{css,eot,gif,html,jpg,js,mak,otf,pem,png,svg,ttf,txt,woff,woff2,xml}'
  stylus:
    cmd : "#BIN/stylus --out $OUT $IN"
    ixt : \styl
    oxt : \css
    mixn: \_

module.exports = me = (new Emitter!) with
  all: ->
    for tid of tasks then compile-batch tid
    me.emit \built

  delete: ->
    try
      pushd Dir.BUILD
      rm \-rf Dirname.SITE, Dirname.TASK
    finally
      popd!

  start: ->
    log Chalk.green 'start build'
    try
      pushd Dir.SRC
      for tid of tasks then start-watching tid
    finally
      popd!
    pruner.start!

  stop: ->
    log Chalk.red 'stop build'
    pruner.stop!
    for , t of tasks then t.watcher?close!

## helpers

function compile t, ipath
  Assert.equal pwd!, Dir.BUILD
  ipath-abs = Path.resolve Dir.SRC, ipath
  mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  cmd = t.cmd.replace(\$IN "'#ipath-abs'").replace \$OUT "'#odir'"
  log Chalk.blue cmd
  Cp.execSync cmd
  opath

function compile-batch tid
  t = tasks[tid]
  w = t.watcher.getWatched!
  files = [f for path, names of w for name in names
    when test \-f f = Path.resolve Dir.SRC, path, name]
  files = _.filter files, -> (Path.basename it).0 isnt t?mixn
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then compile t, Path.relative Dir.SRC, f
  G.ok "...done #info!"

function get-opath t, ipath
  rx = new RegExp("^#{Dir.SRC}/")
  p = ipath.replace(rx, '').replace t.ixt, t.oxt
  return p unless (xsub = t.xsub?split '->')?
  p.replace xsub.0, xsub.1

function prune-empty-dirs
  return unless pwd! is Dir.BUILD
  Assert.equal pwd!, Dir.BUILD
  code, out <- exec "find . -type d -empty -delete"
  G.err "prune failed: #code #out" if code

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
    usePolling: true  # see github chokidar issue 884
  w.on \all _.debounce process, 500ms, leading:true trailing:false

  function process act, ipath
    # log act, tid, ipath
    if (Path.basename ipath).0 is t?mixn
      try
        compile-batch \pug  # mixin must be included by top level pug
        me.emit \built
      catch e then G.err e
    else switch act
    | \add \change
      try opath = compile t, ipath
      catch e then return G.err ipath
      G.ok opath
      me.emit \built
    | \unlink
      Assert.equal pwd!, Dir.BUILD
      try Fs.unlink opath = get-opath t, ipath
      catch e then throw e unless e.code is \ENOENT # not found i.e. already deleted
      G.ok "Delete #opath"
      me.emit \built
