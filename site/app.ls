<- document.addEventListener \DOMContentLoaded

new ScrollTrigger!

b = document.body
l = (b.getElementsByClassName \light).0

s = scrollama!
  ..setup offset:0 progress:true step:\.scrollama
  ..onStepProgress ->
    #console.log l, it
    l.style.transform = "scale(#{sc = it.progress * 5}, #sc)"

window.addEventListener \resize s.resize
