$(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Questions Channel is Connected!');
      this.perform('follow');
    },

    received: function(data) {
      $('.questions').prepend(data);
    }
  });
});
