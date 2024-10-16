addEventListener("DOMContentLoaded", () => {
  const B = document.body
  const D = document.documentElement
  const L = B.querySelector('.light')
  const LI = B.querySelector('.light>img')
  const W = window

  var height_total
  var map     // array of lightburst intensity at each scroll position, 0 = dark, 1 = light
  var map_pos // map value (0 to 1) at current scroll positioin

  function burst() {
    var scroll_pos = Math.round(D.scrollTop || B.scrollTop)
    var map_pos_new = map[scroll_pos] || 0
    if (map_pos_new == map_pos) return  // only transform if necessary
    map_pos = map_pos_new

    const LI_FRACTION = Math.min(LI.naturalHeight / W.innerHeight, LI.naturalWidth / W.innerWidth)
    const SCALE_MAX = 4 / LI_FRACTION // max lightburst scale

    var lightness = Math.max(0, map_pos - 0.5) * 2 * 100 // start increasing brightness half way into ramp
    var scale = map_pos * SCALE_MAX
    B.style.background = (map_pos < 0.5) ? '#000' : '#fff' // fix ipad safari invisible scrollbar
    L.style.background = `hsl(0, 0%, ${lightness}%)`
    L.style.transform = `scale(${scale}, ${scale})`
  }

  function refresh_height() {
    const HEIGHT_WINDOW = W.innerHeight
    const HEIGHT_INTRO = B.querySelector('.intro').clientHeight
    const HEIGHT_OUTRO = B.querySelector('.outro').clientHeight
    const HEIGHT_TOTAL = (D.scrollHeight || B.scrollHeight) - HEIGHT_WINDOW

    if (HEIGHT_TOTAL == height_total) return // dedupe possible multiple reorient and resize events
    height_total = HEIGHT_TOTAL

    const LEN_MAP = HEIGHT_TOTAL // divide full height into this many units
    const LEN_RAMP = HEIGHT_WINDOW // controls light to/from dark transition speed
    const LEN_INTRO = Math.max(0, HEIGHT_INTRO - LEN_RAMP)
    const LEN_OUTRO = Math.max(0, HEIGHT_OUTRO - LEN_RAMP)
    const LEN_MAIN = LEN_MAP - LEN_INTRO - LEN_OUTRO - (LEN_RAMP * 2)
    const MAP_INTRO = Array(LEN_INTRO).fill(0)
    const MAP_UP = Array(LEN_RAMP).fill('').map((_, i) => i / LEN_RAMP)
    const MAP_MAIN = Array(LEN_MAIN).fill(1)
    const MAP_DOWN = [...MAP_UP].reverse()
    const MAP_OUTRO = Array(LEN_OUTRO).fill(0)

    map = [...MAP_INTRO, ...MAP_UP, ...MAP_MAIN, ...MAP_DOWN, ...MAP_OUTRO]
  }

  // event handlers
  window.addEventListener('orientationchange', refresh_height)
  window.addEventListener('resize', refresh_height)
  window.addEventListener('scroll', burst)

  // init
  refresh_height()
})
