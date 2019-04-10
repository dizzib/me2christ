<- document.addEventListener \DOMContentLoaded

b = document.body

io = new IntersectionObserver -> for o in it
  b.classList.toggle \modal-open o.intersectionRatio

for m in b.getElementsByClassName \modal then io.observe m
