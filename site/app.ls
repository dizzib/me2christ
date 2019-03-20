<- document.addEventListener \DOMContentLoaded

new ScrollTrigger!

s = scrollama!
  ..setup step:\.step
  ..onStepEnter -> it.element.classList.add \visible
  ..onStepExit -> it.element.classList.remove \visible

window.addEventListener \resize s.resize

#p = document.querySelector '.flatline path'
#l = p.getTotalLength()
#console.log l
