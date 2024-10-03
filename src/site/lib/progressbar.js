addEventListener("DOMContentLoaded", () => {
  b = document.body
  d = document.documentElement
  p = b.querySelector('.progressbar')

  var total_height

  function progress() {
    scrollpos = Math.round(d.scrollTop || b.scrollTop)
    percent = scrollpos / total_height * 100
    p.style.width = percent + '%'
  }

  function refresh_height() {
    total_height = (d.scrollHeight || b.scrollHeight) - d.clientHeight - 50
  }

  // event handlers
  window.addEventListener('onresize', refresh_height)
  window.addEventListener('scroll', progress)

  // init
  refresh_height()
})
