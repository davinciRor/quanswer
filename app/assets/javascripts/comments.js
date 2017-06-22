$(document).ready(function () {
  App.cable.subscriptions.create({ channel: "CommentsChannel" }, {
    connected: function () {
      this.perform('follow');
    },
    received: function (data) {
      var current_user_id = $('.user').data('currentUserId');
      var comment = JSON.parse(data['comment']);
      var type = comment.commentable_type;
      var comment_id = comment.commentable_id;
      var user_id = comment.user_id;
      if( current_user_id !== user_id ) {
        switch(type) {
          case 'Question':
            $('.question-comments').append(JST["templates/comment"]({
              comment: comment
            }));
            break;
          case 'Answer':
            $('#answer_' + comment_id + ' .answer-comments').append(JST["templates/comment"]({
              comment: comment
            }));
            break;
        }
      }
    }
  });
});
