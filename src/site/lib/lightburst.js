addEventListener("DOMContentLoaded", () => {
  var b = document.body
  var d = document.documentElement
  var l = b.querySelector('.light')
  var i = b.querySelector('.intro')
  var o = b.querySelector('.outro')

  var MAP_ALL // array of lightburst intensity at each scroll position, 0 = dark, 1 = light

  function burst() {
    const SCALE_MAX = 5 // max lightburst scale
    var scrollpos = Math.round(d.scrollTop || b.scrollTop)
    var scale = MAP_ALL[scrollpos] * SCALE_MAX
    l.style.transform = 'scale(' + scale + ',' + scale + ')'
  }

  function refresh_height() {
    var intro_height = i.clientHeight
    var outro_height = o.clientHeight
    var total_height = (d.scrollHeight || b.scrollHeight) - d.clientHeight

    const LEN_MAP = total_height // divide full height into this many units
    const LEN_RAMP = 400 // controls light to/from dark transition speed
    const LEN_INTRO = intro_height - LEN_RAMP
    const LEN_OUTRO = outro_height - LEN_RAMP
    const LEN_MAIN = LEN_MAP - LEN_INTRO - LEN_OUTRO - (LEN_RAMP * 2)
    const MAP_INTRO = Array(LEN_INTRO).fill(0)
    const MAP_UP = Array(LEN_RAMP).fill('').map((_, i) => i / LEN_RAMP)
    const MAP_MAIN = Array(LEN_MAIN).fill(1)
    const MAP_DOWN = [...MAP_UP].reverse()
    const MAP_OUTRO = Array(LEN_OUTRO).fill(0)

    MAP_ALL = [...MAP_INTRO, ...MAP_UP, ...MAP_MAIN, ...MAP_DOWN, ...MAP_OUTRO]
  }

  // event handlers
  window.addEventListener('onresize', refresh_height)
  window.addEventListener('scroll', burst)

  // init
  refresh_height()
});
