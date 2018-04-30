$(document).on('turbolinks:load', function() {
  editForm();
  newQuestion();
});

var editForm = function() {
  var $editBtn = $(document).find('.question_edit-btn');
  var $editQuestionForm = $(document).find('.question_edit-form');

  $editBtn.on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.question_attr').hide();
    $('.question_edit-input, .question_submit-form').show();
  });
};

var newQuestion = function() {
  var $askQuestion = $(document).find('.ask_question');
  var $newQuestionContainer = $(document).find('.new-question');

  $askQuestion.on('click', function(e) {
    if ($(this).attr('href') === '#') {
      e.preventDefault();
      $newQuestionContainer.slideToggle();
    }
  });
}
