$(document).on('turbolinks:load', function() {
  editForm();
  newQuestion();
  showSettings();
  showAttachments();
  showComments();
});

var editForm = function() {
  var $editBtn = $(document).find('.question_edit-btn');
  var $editQuestionForm = $(document).find('.question_edit-form');

  $editBtn.on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.question_attr').hide();
    $('.question_title').hide();
    $('.question_edit-input, .question_submit-form, .question_cancel-editing').show();
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

var showSettings = function() {
  var $btn = $(document).find('.question_actions-btn');
  var $link = $btn.siblings('ul').find('.question_action');
  var $list = $(document).find('.question_actions-list');

  $btn.on('click', function() {
    $list.toggle()
  });

  $link.on('click', function() {
    $list.hide();
  });

  $(document).on('click', function(e) {
    $target = $(e.target);

    if (!$target.is($btn) &&
        !$target.is($link) &&
        !$target.is('path') &&
        !$target.is('svg')) {
      $list.hide();
    }
  });
}

var showAttachments = function() {
  var $showBtn = $(document).find('.question_attachments-show');
  var $attachmentsList = $(document).find('.question_attachments');

  $showBtn.on('click', function(e) {
    e.preventDefault();
    $attachmentsList.slideToggle();
    $attachmentsList.css('display', 'flex');
  });
}

var showComments = function() {
  $showCommentsBtn = $(document).find('.question-comments_show');
  $comments = $(document).find('.question-comments');

  $showCommentsBtn.on('click', function(e) {
    e.preventDefault();
    $comments.slideToggle();
  });
}

