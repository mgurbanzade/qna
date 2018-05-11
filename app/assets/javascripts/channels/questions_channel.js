var addQuestion = function() {
  if (!App.questions_channel) {
    App.questions_channel = App.cable.subscriptions.create('QuestionsChannel', {
      connected: function() {
        console.log('Questions Channel is Connected!');
        this.perform('follow');
      },

      received: function(data) {
        $('.questions').prepend(data);
      }
    });
  }
};

$(document).on('turbolinks:load', addQuestion);
