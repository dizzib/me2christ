<- document.addEventListener \DOMContentLoaded

const DARK    = [0] * 5
const RAMP-UP = [x / 6 for x to 30]
const LIGHT   = [5] * 15
const INTRO   = DARK ++ RAMP-UP ++ LIGHT
const OUTRO   = INTRO.slice!reverse!
const SCALES  = INTRO ++ OUTRO

b = document.body
h = document.documentElement
l = b.querySelector \.light
m = b.querySelector \.main

var height # for efficiency, only calculated on height change

function burst
  percent = Math.round (h.scrollTop||b.scrollTop) / height * 100
  scale = SCALES[percent]
  l.style.transform = "scale(#scale, #scale)"
  m.style.opacity = scale

function refresh-height
  height := (h.scrollHeight||b.scrollHeight) - h.clientHeight
  burst!

# event handlers
window.onresize = refresh-height
window.onscroll = burst
for el in b.getElementsByTagName \details then el.ontoggle = refresh-height

# init
refresh-height!
