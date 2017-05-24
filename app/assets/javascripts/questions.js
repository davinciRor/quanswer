$(document).ready(function () {
  $('.edit-question-link').on('click', function (e) {
    e.preventDefault();
    $(this).hide();
    var question_id = $(this).parents('.question').data('questionId');
    $('#delete-question-link-' + question_id).hide();
    $('#show-question-link-' + question_id).hide();
    $('form#edit-question-' + question_id).show();
  });
});