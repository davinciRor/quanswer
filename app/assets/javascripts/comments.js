$(document).ready(function () {
  var question_id = $('.question').data('questionId');

  App.cable.subscriptions.create({ channel: "CommentsChannel", question_id: question_id }, {
    connected: function () {
      this.perform('follow_for_question');
    },
    received: function (data) {
      console.log(data);
      var current_user_id = $('.user').data('currentUserId');
      var comment = JSON.parse(data['comment']);
      var user_id = comment.user_id;
      if( current_user_id !== user_id ) {
        $('.question-comments').append(JST["templates/comment"]({
          comment: comment
        }));
      }
    }
  });

  $('[data-answer-id]').each(function(i,v) {
    var answer_id = $(v).data('answerId');
    App.cable.subscriptions.create({ channel: "CommentsChannel", answer_id: answer_id }, {
      connected: function () {
        this.perform("follow_for_answer");
      },
      received: function (data) {
        var current_user_id = $('.user').data('currentUserId');
        var comment = JSON.parse(data['comment']);
        var user_id = comment.user_id;
        if( current_user_id !== user_id ) {
          $('[data-answer-id=' + answer_id + '] .answer-comments').append(JST["templates/comment"]({
            comment: comment
          }));
        }
      }
    });
  });
});