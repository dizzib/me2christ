<- document.addEventListener \DOMContentLoaded

b = document.body

function burst
  const l = b.querySelector \.light
  const m = b.querySelector \.main
  r = 0 if (r = it) < 0
  r = 1 if r > 1
  l.style.transform = "scale(#{sc = r * 5.5}, #sc)"
  m.style.opacity = r * 5

# intro
s = scrollama!setup offset:0 progress:true step:\.intro
s.onStepProgress -> burst it.progress - 0.1
window.addEventListener \resize s.resize

# outro
cb = -> burst 0.9 - it.0.intersectionRatio
oio = new IntersectionObserver cb, threshold:[x for x to 1 by 0.02]
oio.observe (b.getElementsByClassName \outro).0

# modals
mio = new IntersectionObserver -> for x in it
  b.className = if x.intersectionRatio > 0 then \modal-open else ''
for m in b.getElementsByClassName \modal then mio.observe m
