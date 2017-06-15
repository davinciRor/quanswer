$(document).ready(function () {
  $('.edit-question-link').click( function (e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).parents('.question').data('questionId');
    $('#delete-question-link-' + questionId).hide();
    $('#show-question-link-' + questionId).hide();
    $('form#edit-question-' + questionId).show();
  });

  $('.question-vote').bind('ajax:success', function (e, data, status, xhr) {
    var questionId = $(this).parents('.question').data('questionId');
    var $errorsBlock = $('#question_' + questionId + ' .vote-error');
    $errorsBlock.html('');
    var voteMark = JSON.parse(xhr.responseText).mark;
    var $questionRating = $('#question_' + questionId + ' .valuation');
    var rating = parseInt($questionRating.text());
    $questionRating.text(rating + voteMark);
  }).bind('ajax:error', function(e, xhr, status, error) {
    var questionId = $(this).parents('.question').data('questionId');
    var $errorsBlock = $('#question_' + questionId + ' .vote-error');
    var error = JSON.parse(xhr.responseText)[0][0];
    $errorsBlock.html('<span>' + error + '</span>');
  });

  App.cable.subscriptions.create("QuestionsChannel", {
    connected: function () {
      this.perform("follow");
    },
    received: function (data) {
      var current_user_id = $('.user').data('currentUserId');
      var question = JSON.parse(data["question"]);
      var user_id = question.user_id;
      if( current_user_id != user_id ) {
        $('.questions').append(JST["question"]({
          question: question,
          current_user: current_user_id
        }));
      }
      $('.question-vote').bind('ajax:success', function (e, data, status, xhr) {
        var questionId = $(this).parents('.question').data('questionId');
        var $errorsBlock = $('#question_' + questionId + ' .vote-error');
        $errorsBlock.html('');
        var voteMark = JSON.parse(xhr.responseText).mark;
        var $questionRating = $('#question_' + questionId + ' .valuation');
        var rating = parseInt($questionRating.text());
        $questionRating.text(rating + voteMark);
      }).bind('ajax:error', function(e, xhr, status, error) {
        var questionId = $(this).parents('.question').data('questionId');
        var $errorsBlock = $('#question_' + questionId + ' .vote-error');
        var error = JSON.parse(xhr.responseText)[0][0];
        $errorsBlock.html('<span>' + error + '</span>');
      });
    }
  });
});


