Assert = require \assert
Path   = require \path
Shell  = require \shelljs/global

const DIRNAME =
  BUILD: \build
  SITE : \site
  SRC  : \src
  TASK : \task
  TEST : \test

root = process.env.PWD

dir =
  BUILD: Path.resolve root, DIRNAME.BUILD
  build:
    SITE: Path.resolve root, DIRNAME.BUILD, DIRNAME.SITE
  ROOT : root
  SRC  : Path.resolve root, DIRNAME.SRC

module.exports =
  APPNAME: \me2christ
  dirname: DIRNAME
  dir    : dir
  PORT   : 7777

Assert test \-e dir.BUILD
Assert test \-e dir.SRC
