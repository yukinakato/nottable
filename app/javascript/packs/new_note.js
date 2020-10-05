$("#note_mode_markdown").on("change", function () {
  $(".md_field").show();
  $(".md_field > textarea").prop("name", "note[content]")  
  $(".rich_field").hide();
  $(".rich_field > input").prop("name", "")  
});

$("#note_mode_richtext").on("change", function () {
  $(".md_field").hide();
  $(".md_field > textarea").prop("name", "")  
  $(".rich_field").show();
  $(".rich_field > input").prop("name", "note[content]")  
});
