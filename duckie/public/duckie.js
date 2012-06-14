/*---------------------------------------------------------------------------*\
 |   script.js                                                               |
 |                                                                           |
 |   Copyright (c) 2012, Rajiv Bakulesh Shah, original author.               |
 |                                                                           |
 |       This file is free software; you can redistribute it and/or modify   |
 |       it under the terms of the GNU General Public License as published   |
 |       by the Free Software Foundation, either version 3 of the License,   |
 |       or (at your option) any later version.                              |
 |                                                                           |
 |       This file is distributed in the hope that it will be useful, but    |
 |       WITHOUT ANY WARRANTY; without even the implied warranty of          |
 |       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   |
 |       General Public License for more details.                            |
 |                                                                           |
 |       You should have received a copy of the GNU General Public License   |
 |       along with this file.  If not, see:                                 |
 |           <http://www.gnu.org/licenses/>.                                 |
\*---------------------------------------------------------------------------*/


Duckie = {
  template: null,
  jqXHR: null,

  init: function() {
    this.template = $('#result').remove().html();
    $('#search').submit(this.search);
    $("[name='query']").focus();
    $(document).keypress(this.keyPress);
    $(document).scroll(this.scroll);
  },

  search: function() {
    if (Duckie.jqXHR !== null) {
      Duckie.jqXHR.abort();
      console.log('aborted previous query');
    }

    var query = $("[name='query']").val().toLowerCase();
    document.title = 'rubber duckie: ' + query;
    $('.query').html(query);
    $("[name='query']").val('');

    $('.loading').show();
    $('#results').empty();
    $('.no-results').hide();

    Duckie.jqXHR = $.getJSON('/search', {query: query}, function(data) {
        Duckie.jqXHR = null;
        $('.loading').hide();
        $.each(data, Duckie.showResult);
        $('.lazy').lazyload();
        if (data.length == 0) {
          $('.no-results').show();
        }
      }
    );
    return false;
  },

  showResult: function(index, value) {
    var result = $(Duckie.template);
    result.find('a.photo').attr('href', value.full_size);
    result.find('a.photo').facebox();
    result.find('a.photo img.photo').attr('data-original', value.thumbnail);
    result.appendTo('#results');
  },

  keyPress: function(eventObject) {
    if (!$("[name='query']").is(':focus')) {
      if (String.fromCharCode(eventObject.keyCode) === '/') {
        window.scrollTo(0, 0);
        return false;
      }
    } else {
        window.scrollTo(0, 0);
    }
  },

  scroll: function(eventObject) {
    $.facebox.close();
    var position = $('html').position();
    if (position.left == 0 && position.top == 0) {
      $("[name='query']").focus();
    }
  }
};


$(function() {
  Duckie.init();
});
