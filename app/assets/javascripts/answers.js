$(document).on('turbolinks:load', function() {
  $editBtn = $(document).find('.answer_edit-btn');

  $editBtn.on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.answer_body').hide();
    answerId = $(this).data('answerId');
    $("form#edit-answer-" + answerId).show();
  });

  showAnswerSettings();
  showAnswerAttachments();
  showAnswerComments();
});

var showAnswerSettings = function() {
  var $btn = $(document).find('.answer_actions-btn');
  var $link = $btn.siblings('ul').find('.answer_action');
  var $list = $(document).find('.answer_actions-list');

  $btn.on('click', function() {
    $list = $(this).closest('.answer_actions').find('.answer_actions-list');
    $list.toggle();
  });

  $link.on('click', function() {
    $(this).siblings('.answer_actions-list').hide();
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

var showAnswerAttachments = function() {
  var $showBtn = $(document).find('.answer_attachments-show');

  $showBtn.on('click', function(e) {
    e.preventDefault();
    var $attachmentsList = $(this).closest('.answer').find('.answer_attachments');

    $attachmentsList.slideToggle();
    $attachmentsList.css('display', 'flex');
  });
}

var showAnswerComments = function() {
  $showCommentsBtn = $(document).find('.answer-comments_show');

  $showCommentsBtn.on('click', function(e) {
    e.preventDefault();
    $answerComments = $(this).closest('.answer').find('.answer-comments');

    $answerComments.slideToggle();
  });
}
