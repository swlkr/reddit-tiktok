function scrollEvent(e) {
  var sections = document.querySelectorAll('section');
  var height = sections[0].clientHeight;

  if(e.target.scrollTop === height * (sections.length - 1)) {
    fetch('/next')
    .then(res => res.text())
    .then(html => {
      // append to end
      e.target.insertAdjacentHTML('beforeend', html);
    })
    .catch(err => {
      console.log('error', err);
    })
  }
}

var main = document.querySelector('main');
main.addEventListener('scroll', scrollEvent);
