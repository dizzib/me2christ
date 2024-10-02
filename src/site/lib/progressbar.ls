<- document.addEventListener \DOMContentLoaded

b = document.body
d = document.documentElement
p = b.querySelector \.progressbar

var total-height

function progress
  scrollpos = Math.round(d.scrollTop||b.scrollTop)
  percent = scrollpos / total-height * 100
  p.style.width = percent + \%

function refresh-height
  total-height := (d.scrollHeight||b.scrollHeight) - d.clientHeight - 50

# event handlers
window.addEventListener \onresize refresh-height
window.addEventListener \scroll progress

# init
refresh-height!
