<- document.addEventListener \DOMContentLoaded

b = document.body
l = b.querySelector \.light
m = b.querySelector \.main

# intro/outro light burst
function burst
  r = it.0.intersectionRatio
  if r < 0 then r = 0 else if r > 1 then r = 1 else r = 1 - r
  l.style.transform = "scale(#{sc = r * 5.5}, #sc)"
  m.style.opacity = r * 5

const GRAINS = 25
const OPTS = margin:\20vmin threshold:[x / GRAINS for x to GRAINS]
o = new IntersectionObserver burst, OPTS
for el in b.querySelectorAll '.intro, .outro' then o.observe el
