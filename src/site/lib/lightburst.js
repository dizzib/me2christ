addEventListener("DOMContentLoaded", () => {
  const B = document.body
  const D = document.documentElement
  const L = B.querySelector('.light')
  const I = B.querySelector('.intro')
  const O = B.querySelector('.outro')

  var height_total
  var map_all

  function burst() {
    const SCALE_MAX = 5 // max lightburst scale
    var scrollpos = Math.round(D.scrollTop || B.scrollTop)
    var scale = map_all[scrollpos] * SCALE_MAX
    L.style.transform = 'scale(' + scale + ',' + scale + ')'
  }

  function refresh_height() {
    const HEIGHT_INTRO = I.clientHeight
    const HEIGHT_OUTRO = O.clientHeight
    const HEIGHT_TOTAL = (D.scrollHeight || B.scrollHeight) - window.innerHeight

    if (HEIGHT_TOTAL == height_total) return // dedupe possible multiple reorient and resize events
    height_total = HEIGHT_TOTAL

    const LEN_MAP = HEIGHT_TOTAL // divide full height into this many units
    const LEN_RAMP = 800 // controls light to/from dark transition speed
    const LEN_INTRO = Math.max(0, HEIGHT_INTRO - LEN_RAMP)
    const LEN_OUTRO = Math.max(0, HEIGHT_OUTRO - LEN_RAMP)
    const LEN_MAIN = LEN_MAP - LEN_INTRO - LEN_OUTRO - (LEN_RAMP * 2)
    const MAP_INTRO = Array(LEN_INTRO).fill(0)
    const MAP_UP = Array(LEN_RAMP).fill('').map((_, i) => i / LEN_RAMP)
    const MAP_MAIN = Array(LEN_MAIN).fill(1)
    const MAP_DOWN = [...MAP_UP].reverse()
    const MAP_OUTRO = Array(LEN_OUTRO).fill(0)

    // array of lightburst intensity at each scroll position, 0 = dark, 1 = light
    map_all = [...MAP_INTRO, ...MAP_UP, ...MAP_MAIN, ...MAP_DOWN, ...MAP_OUTRO]
  }

  // event handlers
  window.addEventListener('orientationchange', refresh_height)
  window.addEventListener('resize', refresh_height)
  window.addEventListener('scroll', burst)

  // init
  refresh_height()
})
