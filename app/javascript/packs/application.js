// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
// require("turbolinks").start()
require("@rails/activestorage").start();
require("channels");

import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";

// uncomment this
// import "../../assets/stylesheets/custom"

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

require("trix");
require("@rails/actiontext");

//

hljs.initHighlightingOnLoad();

window.onpopstate = function (e) {
  if (e.state === "ajax") {
    $.get(document.location.href);
  } else {
    window.location = document.location.href;
  }
};

window.addEventListener("load", () => {
  document.body.addEventListener("ajax:before", (event) => {
    if (event.target.href) {
      history.pushState("ajax", "", event.target.href);
    }
  });
  document.body.addEventListener("ajax:complete", (event) => {
    document.querySelectorAll("pre > code").forEach((block) => {
      hljs.highlightBlock(block);
    });
  });
});

window.addEventListener("trix-file-accept", function (event) {
  var acceptTypes = ["image/jpeg", "image/png", "image/gif"];
  var maxFileSize = 2 * 1024 * 1024;
  if (!acceptTypes.includes(event.file.type) || event.file.size > maxFileSize) {
    event.preventDefault();
    alert("添付可能なファイルは、2MB以下の画像(jpeg/png/gif)のみです。");
  }
});
