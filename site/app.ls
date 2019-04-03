<- document.addEventListener \DOMContentLoaded

(b = document.body).classList.remove \noscript

# modals
mio = new IntersectionObserver -> for x in it
  b.classList.toggle \modal-open x.intersectionRatio
for m in b.getElementsByClassName \modal then mio.observe m
