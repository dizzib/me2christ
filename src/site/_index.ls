<- document.addEventListener \DOMContentLoaded

b = document.body
h = document.documentElement
l = b.querySelector \.light
m = b.querySelector \.main
o = b.querySelector \.outro

var height # for efficiency, only calculated on height change
var MAP_ALL

function burst
  scrollpos = Math.round (h.scrollTop||b.scrollTop)
  scale = MAP_ALL[scrollpos]
  l.style.transform = "scale(#scale, #scale)"
  m.style.opacity = scale

function refresh-height
  height := (h.scrollHeight||b.scrollHeight) - h.clientHeight

  const LIGHT_MAX = 5 # full light scale (0=dark)
  const LEN_MAP   = height # divide full height into this many units
  const LEN_RAMP  = 800 # controls light to/from dark transition speed
  const LEN_INTRO = 100
  const LEN_OUTRO = 600
  const LEN_MAIN  = LEN_MAP - LEN_INTRO - LEN_OUTRO - (LEN_RAMP * 2)
  const MAP_INTRO = [0] * LEN_INTRO
  const MAP_UP    = [x * LIGHT_MAX / LEN_RAMP for x to LEN_RAMP]
  const MAP_MAIN  = [LIGHT_MAX] * LEN_MAIN
  const MAP_DOWN  = MAP_UP.slice!reverse!
  const MAP_OUTRO = [0] * LEN_OUTRO

  MAP_ALL := MAP_INTRO ++ MAP_UP ++ MAP_MAIN ++ MAP_DOWN ++ MAP_OUTRO

# event handlers
window.onresize = refresh-height
window.onscroll = burst
for el in b.getElementsByTagName \details then el.ontoggle = refresh-height

# init
refresh-height!
