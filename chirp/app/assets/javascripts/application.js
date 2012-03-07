// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


ENTER_KEYCODE = 13;
POST_SELECTOR = '#post';
POST_LENGTH = 140;
COUNTDOWN_SELECTOR = '#countdown';


/*---------------------------------------------------------------------------*\
 |                                    $()                                    |
\*---------------------------------------------------------------------------*/

$(function() {
    var post = $(POST_SELECTOR);
    if (post.length) {
        post.focus(focusPost);
        post.blur(blurPost);
        post.keydown(keydownPost);
        post.keyup(changePost);
        post.change(changePost);
        post.bind('input cut', function(e) {changePost();});
        post.bind('input paste', function(e) {changePost();});

        var defaultPost = post.prop('defaultValue');
        post.val(defaultPost);
    }
});


/*---------------------------------------------------------------------------*\
 |                                focusPost()                                |
\*---------------------------------------------------------------------------*/

function focusPost() {
    var post = $(POST_SELECTOR);
    var defaultPost = post.prop('defaultValue');
    if (post.val() == defaultPost) {
        post.val('');
    }
}


/*---------------------------------------------------------------------------*\
 |                                 blurPost()                                |
\*---------------------------------------------------------------------------*/

function blurPost() {
    var post = $(POST_SELECTOR);
    if (post.val() == '') {
        var defaultPost = post.prop('defaultValue');
        post.val(defaultPost);
    }
}


/*---------------------------------------------------------------------------*\
 |                               keydownPost()                               |
\*---------------------------------------------------------------------------*/

function keydownPost(e) {
    if (e.keyCode == ENTER_KEYCODE) {
        var post = $(POST_SELECTOR);
        var body = post.val();
        var charsTyped = body.length;
        var charsRemaining = POST_LENGTH - charsTyped;
        if (charsRemaining >= 0) {
            var data = {}
            data['post[body]'] = body;
            $.ajax({
                type: 'POST',
                url: '/posts.json',
                data: data,
                success: function(data, textStatus, jqXHR) {
                    alert(data);
                }
            });
        }
        return false;
    }
}


/*---------------------------------------------------------------------------*\
 |                                changePost()                               |
\*---------------------------------------------------------------------------*/

function changePost() {
    var post = $(POST_SELECTOR);
    var charsTyped = post.val().length;
    var charsRemaining = POST_LENGTH - charsTyped;
    var html = charsRemaining.toString();

    var countdown = $(COUNTDOWN_SELECTOR);
    if (countdown.html() != html) {
        countdown.html(html);
        if (charsRemaining < 0) {
            countdown.addClass('negative');
        } else {
            countdown.removeClass('negative');
        }
    }
}
