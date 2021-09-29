Assert = require \assert
Shell  = require \shelljs/global

const DIRNAME =
  BUILD: \build
  SITE : \site
  SRC  : \src
  TASK : \task
  TEST : \test

root = process.env.PWD

dir =
  BUILD: "#root/#{DIRNAME.BUILD}"
  build:
    SITE: "#root/#{DIRNAME.BUILD}/#{DIRNAME.SITE}"
  ROOT : root
  SRC  : "#root/#{DIRNAME.SRC}"

module.exports =
  APPNAME: \me2christ
  dirname: DIRNAME
  dir    : dir
  PORT   : 7777

Assert test \-e dir.BUILD
Assert test \-e dir.SRC
