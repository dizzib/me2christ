addEventListener("DOMContentLoaded", () => {
  b = document.body
  d = document.documentElement
  l = b.querySelector('.light')
  i = b.querySelector('.intro')
  o = b.querySelector('.outro')

  function burst() {
    SCALE_MAX = 5 // max lightburst scale
    scrollpos = Math.round(d.scrollTop || b.scrollTop)
    scale = MAP_ALL[scrollpos] * SCALE_MAX
    l.style.transform = 'scale(' + scale + ',' + scale + ')'
  }

  function refresh_height() {
    intro_height = i.clientHeight
    outro_height = o.clientHeight
    total_height = (d.scrollHeight || b.scrollHeight) - d.clientHeight

    LEN_MAP = total_height // divide full height into this many units
    LEN_RAMP = 400 // controls light to/from dark transition speed
    LEN_INTRO = intro_height - LEN_RAMP
    LEN_OUTRO = outro_height - LEN_RAMP
    LEN_MAIN = LEN_MAP - LEN_INTRO - LEN_OUTRO - (LEN_RAMP * 2)
    MAP_INTRO = Array(LEN_INTRO).fill(0)
    MAP_UP = Array(LEN_RAMP).fill('').map((_, i) => i / LEN_RAMP)
    MAP_MAIN = Array(LEN_MAIN).fill(1)
    MAP_DOWN = [...MAP_UP].reverse()
    MAP_OUTRO = Array(LEN_OUTRO).fill(0)
    MAP_ALL = [...MAP_INTRO, ...MAP_UP, ...MAP_MAIN, ...MAP_DOWN, ...MAP_OUTRO] // array of lightburst intensity at each scroll position, 0 = dark, 1 = light
  }

  // event handlers
  window.addEventListener('onresize', refresh_height)
  window.addEventListener('scroll', burst)

  // init
  refresh_height()
})
