$(document).on('turbolinks:load', function() {
  var $editBtn = $(document).find('.question_edit-btn');
  var $editQuestionForm = $(document).find('.question_edit-form');

  $editBtn.on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.question_attr').hide();
    $('.question_edit-input, .question_submit-form').show();
  });
});
