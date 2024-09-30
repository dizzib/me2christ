<- document.addEventListener \DOMContentLoaded

const LIGHT     = [5] * 65
const RAMP_DOWN = [x / 6 for x from 30 to 1]
const DARK      = [0] * 15
const SCALES    = LIGHT ++ RAMP_DOWN ++ DARK

b = document.body
h = document.documentElement
l = b.querySelector \.light
m = b.querySelector \.main
o = b.querySelector \.outro

var height # for efficiency, only calculated on height change

function burst
  percent = Math.round (h.scrollTop||b.scrollTop) / height * 100
  scale = SCALES[percent]
  l.style.transform = "scale(#scale, #scale)"
  m.style.opacity = scale

function refresh-height
  height := (h.scrollHeight||b.scrollHeight) - h.clientHeight
  # houtro := o.clientHeight
  burst!

# event handlers
window.onresize = refresh-height
window.onscroll = burst
for el in b.getElementsByTagName \details then el.ontoggle = refresh-height

# init
refresh-height!
