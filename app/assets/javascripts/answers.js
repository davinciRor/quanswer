$(document).ready(function () {
  $('.edit-answer-link').on('click', function (e) {
    e.preventDefault();
    $(this).hide();
    var answer_id = $(this).parents('.answer').data('answerId');
    $('#delete-answer-link-' + answer_id).hide();
    $('form#edit-answer-' + answer_id).show();
  });
});