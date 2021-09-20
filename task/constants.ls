Assert = require \assert
Shell  = require \shelljs/global

const DIRNAME =
  BUILD: \build
  SITE : \site
  SRC  : \src
  TASK : \task
  TEST : \test

dir =
  BUILD: "/#{DIRNAME.BUILD}"
  build:
    SITE: "/#{DIRNAME.BUILD}/#{DIRNAME.SITE}"
  SRC  : "/#{DIRNAME.SRC}"

module.exports =
  APPNAME: \me2christ
  dirname: DIRNAME
  dir    : dir
  PORT   : 7777

Assert test \-e dir.BUILD
Assert test \-e dir.SRC
