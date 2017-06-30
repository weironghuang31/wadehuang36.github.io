document.addEventListener("DOMContentLoaded", function () {
  var tabs = document.querySelectorAll(".tab a");
  var tabContents = document.querySelectorAll(".tab-content");

  function tabHandler(event) {
    var selectedTab = this.hash.substr(1);

    for (var i = 0; i < tabs.length; i++) {
      var tab = tabs[i];
      var content = tabContents[i];

      if (tab.hash === this.hash) {
        tab.parentNode.classList.add("active");
      } else {
        tab.parentNode.classList.remove("active");
      }

      if (content.id === selectedTab) {
        content.classList.add("active");
      } else {
        content.classList.remove("active");
      }
    }

    event.preventDefault();
    event.returnValue = false;
  }

  for (var i = 0; i < tabs.length; i++) {
    var tab = tabs[i];

    tab.addEventListener("click", tabHandler);
  }
});
