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
  json_ls:
    cmd: "#BIN/lsc --output $OUT $IN"
    ixt: \json.ls
    oxt: \json
  ls:
    cmd: "#BIN/lsc --output $OUT $IN"
    ixt: \ls
    oxt: \js
  site_pug:
    dir: Dirname.SITE
    cmd: "#BIN/pug3 -O \"{version:'#{process.env.npm_package_version}'}\" --out $OUT $IN"
    pat: \index.pug
    oxt: \html
  site_pug_includes:
    dir: Dirname.SITE
    ign: '**/index.pug'
    ixt: '{js,md,pug,scss}'
    tid: \site_pug # task id to run
  static:
    cmd: "cp --target-directory $OUT $IN"
    ixt: '{json,lson,png}'

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
  return unless t.cmd or t.run
  Assert.equal pwd!, Dir.BUILD
  mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  if t.cmd
    cmd = t.cmd.replace(\$IN ipath).replace(\$OUT odir).replace(\$OPATH opath)
    log Chalk.blue cmd
    stdout = Cp.execSync cmd
    log stdout.toString!
  if t.run
    mod = "../#{t.dir}/#{t.run}"
    log Chalk.blue 'run module:' mod
    delete require.cache[require.resolve(mod)]; # invalidate cache
    (require mod)(ipath, opath)
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
  ipath.replace(rx, '').replace t.ixt, t.oxt

function start-watching tid
  Assert.equal pwd!, Dir.SRC
  t = tasks[tid]; pat = ''
  pat += "#{t.dir}/" if t.dir
  pat += "**/"
  pat += t.pat or "*.#{t.ixt}"
  log "start watching #tid: #pat"
  w = t.watcher = Choki.watch pat,
    cwd:Dir.SRC
    ignoreInitial:true
    ignored:t.ign
  w.on \all (act, path) ->
    log path, t.ixt
    # Assert _.endsWith path, ".#{t.ixt}"
    ipath = Path.join(Dir.SRC, path)
    log Chalk.yellow(\build), act, tid, ipath
    if t?tid
      try
        compile-batch t.tid
        me.emit \built
      catch e then G.err e
    else if act in [\add \change]
      try opath = compile t, ipath
      catch e then return G.err e
      G.ok opath
      me.emit \built
