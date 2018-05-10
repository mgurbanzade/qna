$(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      console.log('Answers Channel is Connected!');
      this.perform('follow');
    },

    received: function(data) {
      $('.answers').prepend(JST["templates/answer"](data));
    }
  });
});
