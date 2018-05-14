$(document).on('turbolinks:load', function() {
  var $rateBtn = $(document).find('a.rate');

  $(document).on('ajax:success', 'a.rate', function(e) {
    var response = e.detail[0];
    var rating = response.rating > 0 ? '+' + response.rating : response.rating;
    var $rateContainer = $('.rate_' + response.klass.toLowerCase() + '_' + response.id);
    var $currentRating = $rateContainer.find('.current_rating');
    var $likeBtn = $rateContainer.find('.like');
    var $dislikeBtn = $rateContainer.find('.dislike');

    $currentRating.html(rating);

    if (response.action === 'liked') {
      $likeBtn.html('Unvote');
      $dislikeBtn.addClass('disabled');
    } else if (response.action === 'disliked') {
      $dislikeBtn.html('Unvote');
      $likeBtn.addClass('disabled');
    } else {
      $likeBtn.html('Like');
      $likeBtn.removeClass('disabled');
      $dislikeBtn.html('Dislike');
      $dislikeBtn.removeClass('disabled');
    }
  });
});
