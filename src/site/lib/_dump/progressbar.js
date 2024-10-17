addEventListener("DOMContentLoaded", () => {
  const B = document.body
  const D = document.documentElement
  const P = B.querySelector('.progressbar')

  var total_height

  function progress() {
    const SCROLLPOS = Math.round(D.scrollTop || B.scrollTop)
    var percent = SCROLLPOS / total_height * 100
    P.style.width = percent + '%'
  }

  function refresh_height() {
    total_height = (D.scrollHeight || B.scrollHeight) - window.innerHeight - 50
  }

  // event handlers
  window.addEventListener('orientationchange', refresh_height)
  window.addEventListener('resize', refresh_height)
  window.addEventListener('scroll', progress)

  // init
  refresh_height()
})
