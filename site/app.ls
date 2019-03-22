<- document.addEventListener \DOMContentLoaded

b = document.body
l = (b.getElementsByClassName \light).0
burst = ->
  r = 0 if (r = it) < 0
  r = 1 if r > 1
  l.style.transform = "scale(#{sc = r * 5}, #sc)"

# intro
s = scrollama!setup offset:0 progress:true step:\.intro
s.onStepProgress -> burst it.progress - 0.1
window.addEventListener \resize s.resize

# outro
cb = (entries) ->
  r = 0.9 - entries.0.intersectionRatio
  burst r
io = new IntersectionObserver cb, threshold:[x for x to 1 by 0.02]
io.observe (b.getElementsByClassName \outro).0
