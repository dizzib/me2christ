name       : \me2christ
version    : \2.0.0
description: 'me2christ.com source code'
private    : true
homepage   : \https://github.com/dizzib/me2christ
bugs       : \https://github.com/dizzib/me2christ/issues
license:   : \MIT
author     : \andrew
repository:
  type: \git
  url : \https://github.com/dizzib/me2christ
scripts:
  build: 'cd .. && node build/task/yarn/build.js'
  start: 'cd .. && node --watch-path=build/task build/task/repl.js'
engines:
  node: '20'
  yarn: '1.22'
devDependencies:
  chalk                       : \~0.4.0
  chokidar                    : \~3.2.2
  growly                      : \~1.3.0
  'jstransformer-markdown-it' : \~3.0.0
  'jstransformer-scss'        : \~2.0.0
  livereload                  : \~0.9.3
  livescript                  : \~1.6.0
  lodash                      : \~4.17.21
  'node-static'               : \~0.7.11
  '@anduh/pug-cli'            : \~1.0.0-alpha8
  '@resvg/resvg-js'           : \~2.6.2 # svg to png
  shelljs                     : \~0.8.5
  '@svgdotjs/svg.js'          : \~3.2.4 # js to svg
# lint
  'ls-lint'                   : \~0.1.2
  'postcss-scss'              : \~4.0.9
  'pug-lint'                  : \~2.6.0
  stylelint                   : \~14.12.1
  'stylelint-order'           : \~5.0.0
  'stylelint-scss'            : \~5.0.0
