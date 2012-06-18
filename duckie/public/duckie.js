/*---------------------------------------------------------------------------*\
 |   duckie.js                                                               |
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
  _TIMEOUT: 10000,

  _initialized: false,
  _template: null,
  _brokenTimer: null,
  _jqXHR: null,

  init: function() {
    if (this._initialized) {
      return false;
    } else {
      this._initialized = true;
      this._template = $('#result').remove().html();
      $('#templates').remove()
      $('#search').submit(this._search);
      $(document).keypress(this._keyPress);
      $(document).scroll(this._scroll);
      return true;
    }
  },

  _search: function() {
    if (Duckie._brokenTimer !== null) {
      window.clearTimeout(Duckie._brokenTimer);
      Duckie._brokenTimer = null;
    }
    if (Duckie._jqXHR !== null) {
      Duckie._jqXHR.abort();
      Duckie._jqXHR = null;
    }

    var query = $("[name='query']").val();
    query = query.toLowerCase().trim().replace(/ +/g, ' ');
    if (query) {
      Duckie._preSearch(query);
      Duckie._brokenTimer = window.setTimeout(Duckie._broken, Duckie._TIMEOUT);
      Duckie._jqXHR = $.getJSON('/search', {query: query}, function(data) {
          window.clearTimeout(Duckie._brokenTimer);
          Duckie._brokenTimer = null;
          Duckie._jqXHR = null;
          Duckie._postSearch(data);
        }
      );
    }

    return false;
  },

  _preSearch: function(query) {
    document.title = 'rubber duckie - ' + query;
    $('.query').html(query);
    $("[name='query']").val('');

    $('#loading').show();
    $('#results').empty();
    $('#no-results').hide();
    $('#broken').hide();
  },

  _broken: function() {
    if (Duckie._brokenTimer !== null) {
      window.clearTimeout(Duckie._brokenTimer);
      Duckie._brokenTimer = null;
    }
    if (Duckie._jqXHR !== null) {
      Duckie._jqXHR.abort();
      Duckie._jqXHR = null;
    }

    $('#loading').hide();
    $('#broken').show();
  },

  _postSearch: function(results) {
    if (results.length !== 0) {
      $("[name='query']").blur();
    }
    $('#loading').hide();
    $.each(results, Duckie._showResult);
    $('.lazy').lazyload();
    if (results.length === 0) {
      $('#no-results').show();
    }
  },

  _showResult: function(index, value) {
    var result = $(Duckie._template);
    result.find('a.photo').attr('href', value.full_size);
    result.find('a.photo').facebox();
    result.find('a.photo img.photo').attr('data-original', value.thumbnail);
    result.appendTo('#results');
  },

  _keyPress: function(eventObject) {
    $.facebox.close();
    window.scrollTo(0, 0);
    $("[name='query']").focus();
  },

  _scroll: function(eventObject) {
    $.facebox.close();
    var position = $('html').position();
    if (position.left === 0 && position.top === 0) {
      $("[name='query']").focus();
    }
  }
};


$(function() {
  Duckie.init();
});
