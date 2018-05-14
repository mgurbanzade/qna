var addAnswer = function() {
  if (!App.answers_channel) {
    App.answers_channel = App.cable.subscriptions.create('AnswersChannel', {
      connected: function() {
        var questionId = $('.question').data('id');
        console.log('Answers Channel is Connected!');
        this.perform('follow', { id: questionId });
      },

      received: function(data) {
        if (gon.user_id !== data.data.user_id) {
          $('.answers').prepend(JST["templates/answer"](data));
        }
      }
    });
  }
};

$(document).on('turbolinks:load', addAnswer);
