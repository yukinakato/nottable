$("#note_mode_markdown").on("change", function () {
  $(".markdown-field").show();
  $(".markdown-field > textarea").prop("name", "note[content]")  
  $(".richtext-field").hide();
  $(".richtext-field > input").prop("name", "")  
});

$("#note_mode_richtext").on("change", function () {
  $(".markdown-field").hide();
  $(".markdown-field > textarea").prop("name", "")  
  $(".richtext-field").show();
  $(".richtext-field > input").prop("name", "note[content]")  
});

$(".help-pop-private").hover(
  function(){
    $(".description-private").show();
  },
  function(){
    $(".description-private").hide();
  }
);
