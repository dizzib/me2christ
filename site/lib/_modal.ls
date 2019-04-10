<- document.addEventListener \DOMContentLoaded

b = document.body

io = new IntersectionObserver -> for o in it
  b.classList.toggle \modal-open o.intersectionRatio
for o in b.getElementsByClassName \modal then io.observe o

for o in b.getElementsByClassName \modal-close
  o.removeAttribute \href
  o.addEventListener \click -> window.history.back!

for o in b.getElementsByClassName \modal-dialog
  o.addEventListener \click -> it.stopPropagation!
