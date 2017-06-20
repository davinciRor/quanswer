$(document).ready(function () {
  $('.edit-answer-link').click(function (e) {
    e.preventDefault();
    $(this).hide();
    var answer_id = $(this).parents('.answer').data('answerId');
    $('#delete-answer-link-' + answer_id).hide();
    $('form#edit-answer-' + answer_id).show();
    $('#best-answer-link-' + answer_id).hide();
  });

  $('.answer-vote').bind('ajax:success', function (e, data, status, xhr) {
    var answerId = $(this).parents('.answer').data('answerId');
    var $errorsBlock = $('#answer_' + answerId + ' .vote-error');
    $errorsBlock.html('');
    var voteMark = JSON.parse(xhr.responseText).mark;
    var $answerRating = $('#answer_' + answerId + ' .valuation');
    var rating = parseInt($answerRating.text());
    $answerRating.text(rating + voteMark);
  }).bind('ajax:error', function(e, xhr, status, error) {
    var answerId = $(this).parents('.answer').data('answerId');
    var $errorsBlock = $('#answer_' + answerId + ' .vote-error');
    var error = JSON.parse(xhr.responseText)[0][0];
    $errorsBlock.html('<span>' + error + '</span>');
  });
});
