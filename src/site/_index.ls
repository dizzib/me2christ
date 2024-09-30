<- document.addEventListener \DOMContentLoaded

const LIGHT     = [5] * 650
const RAMP_DOWN = [x / 60 for x from 300 to 1]
const DARK      = [0] * 150
const SCALES    = LIGHT ++ RAMP_DOWN ++ DARK

b = document.body
h = document.documentElement
l = b.querySelector \.light
m = b.querySelector \.main
o = b.querySelector \.outro

var height # for efficiency, only calculated on height change

function burst
  scrollpos = Math.round (h.scrollTop||b.scrollTop) / height * 1000
  scale = SCALES[scrollpos]
  l.style.transform = "scale(#scale, #scale)"
  m.style.opacity = scale

function refresh-height
  height := (h.scrollHeight||b.scrollHeight) - h.clientHeight
  alert height
  burst!

# event handlers
window.onresize = refresh-height
window.onscroll = burst
for el in b.getElementsByTagName \details then el.ontoggle = refresh-height

# init
refresh-height!
