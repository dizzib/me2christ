Fs   = require \fs
Path = require \path
R    = require \@resvg/resvg-js

module.exports = (ipath, opath) ->
  try
    svg = Fs.readFileSync ipath
  catch err then return log err

  const OPTS = fitTo: {mode: \width, value: 250}
  resvg = new R.Resvg(svg, OPTS)
  pngData = resvg.render!
  pngBuf = pngData.asPng!

  console.info('Original SVG Size:', "#{resvg.width} x #{resvg.height}")
  console.info('Output PNG Size  :', "#{pngData.width} x #{pngData.height}")

  try
    Fs.writeFileSync(opath, pngBuf)
    log "Wrote #{pngBuf.length} bytes to #opath"
  catch err then return log err
