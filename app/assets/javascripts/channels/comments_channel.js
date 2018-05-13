var addComment = function() {
  if (!App.comments_channel) {
    App.comments_channel = App.cable.subscriptions.create('CommentsChannel', {
      connected: function() {
        var questionId = $('.question').data('id');
        console.log('Comments Channel is Connected!');
        this.perform('follow', { id: questionId });
      },

      received: function(data) {
        if (data.data.commentable_type !== undefined) {
          type = data.data.commentable_type.toLowerCase();
          id = data.data.commentable_id;
          selector = "." + type + '_' + id;
          $(selector).find('.' + type + '-comments').prepend(JST["templates/comment"](data));
        }
      }
    });
  }
};

$(document).on('turbolinks:load', addComment);
