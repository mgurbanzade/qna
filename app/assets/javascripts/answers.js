$(document).on('turbolinks:load', function() {
  $editBtn = $(document).find('.answer_edit-btn');

  $editBtn.on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.answer_body').hide();
    answerId = $(this).data('answerId');
    $("form#edit-answer-" + answerId).show();
  });
});
