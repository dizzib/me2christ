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

const BIN = "#{Dir.BUILD}/node_modules/.bin"

tasks  =
  livescript:
    dirs: Dirname.TASK
    cmd : "#BIN/lsc --output $OUT $IN"
    ixt : \ls
    oxt : \js
    xsub: 'json.js->json'
  pug:
    dirs: Dirname.SITE
    cmd : "#BIN/pug3 -O \"{version:'#{process.env.npm_package_version}'}\" --out $OUT $IN"
    pat : \index.pug
    oxt : \html
  pug-includes:
    dirs: Dirname.SITE
    ixt : '{ls,md,pug,scss}'
    ctid: \pug # compile task id
    excl: '**/index.pug'
  sass:
    dirs: Dirname.SITE
    cmd : "#BIN/sass --no-source-map $IN $OPATH"
    pat : \index.sass
    ixt : \sass
    oxt : \css
  sass-includes:
    dirs: Dirname.SITE
    ixt : \sass
    ctid: \sass
    excl: '**/index.sass'
  static:
    dirs: "{#{Dirname.SITE},#{Dirname.TASK}}"
    cmd : "cp --target-directory $OUT $IN"
    ixt : '{js,png}'

module.exports = me = (new Emitter!) with
  all: ->
    for tid of tasks then compile-batch tid
    me.emit \built

  start: ->
    log Chalk.green 'start build'
    try
      pushd Dir.SRC
      for tid of tasks then start-watching tid
    finally
      popd!

  stop: ->
    log Chalk.red 'stop build'
    for , t of tasks then t.watcher?close!

## helpers

function compile t, ipath
  return unless t.cmd
  Assert.equal pwd!, Dir.BUILD
  mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
  log Chalk.blue cmd
  Cp.execSync cmd
  opath

function compile-batch tid
  t = tasks[tid]
  w = t.watcher.getWatched!
  files = [f for path, names of w for name in names
    when test \-f f = Path.resolve Dir.SRC, path, name]
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then compile t, f
  G.ok "...done #info!"

function get-opath t, ipath
  rx = new RegExp("^#{Dir.SRC}/")
  p = ipath.replace(rx, '').replace t.ixt, t.oxt
  return p unless (xsub = t.xsub?split '->')?
  p.replace xsub.0, xsub.1

function start-watching tid
  log "start watching #tid"
  Assert.equal pwd!, Dir.SRC
  pat = (t = tasks[tid]).pat or "*.#{t.ixt}"
  w = t.watcher = Choki.watch ["#{t.dirs}/**/#pat" pat],
    cwd:Dir.SRC
    ignoreInitial:true
    ignored:t.excl
  w.on \all (act, path) ->
    log path, t.ixt
    # Assert _.endsWith path, ".#{t.ixt}"
    ipath = Path.join(Dir.SRC, path)
    log Chalk.yellow(\build), act, tid, ipath
    if t?ctid
      try
        compile-batch t.ctid
        me.emit \built
      catch e then G.err e
    else if act in [\add \change]
      try opath = compile t, ipath
      catch e then return G.err ipath
      G.ok opath
      me.emit \built
