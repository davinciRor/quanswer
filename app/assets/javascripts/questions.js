$(document).ready(function () {
  $('.edit-question-link').click( function (e) {
    e.preventDefault();
    $(this).hide();
    var question_id = $(this).parents('.question').data('questionId');
    $('#delete-question-link-' + question_id).hide();
    $('#show-question-link-' + question_id).hide();
    $('form#edit-question-' + question_id).show();
  });

  $('.question-vote').bind('ajax:success', function (e, data, status, xhr) {
    var question_id = $(this).parents('.question').data('questionId');
    var vote_mark = JSON.parse(xhr.responseText).mark;
    var $question_rating = $('#question_' + question_id + ' .valuation');
    var rating = parseInt($question_rating.text());
    $question_rating.text(rating + vote_mark);
  });
});