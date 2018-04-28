$ ->
  $editBtn = $('.answer_edit-btn')
  $editForm = $('.answer_edit-form')

  $editBtn.on 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    answerId = $(this).data('answerId')
    $("form#edit-answer-#{answerId}").show()
