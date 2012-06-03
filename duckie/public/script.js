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


var template = null;
var jqXHR = null;


$(function() {
  template = $('#result').remove().html();
  $('#search').submit(search);
  $("[name='query']").focus();
});


function search() {
  if (jqXHR !== null) {
    jqXHR.abort();
    console.log('aborted previous query');
  }

  var query = $("[name='query']").val().toLowerCase();
  document.title = 'rubber duckie: ' + query;
  $('.query').html(query);
  $("[name='query']").val('');
  $('#results').empty();
  $('.no-results').hide();

  jqXHR = $.getJSON('/search', {query: query}, function(data) {
      jqXHR = null;
      $.each(data, function(indexInArray, valueOfElement) {
        var result = $(template);
        result.find('a.photo').attr('href', valueOfElement.full_size);
        result.find('a.photo').facebox();
        result.find('a.photo img.photo').attr('src', valueOfElement.thumbnail);
        result.appendTo('#results');
      });
      if (data.length == 0) {
        $('.no-results').show();
      }
    }
  );
  return false;
}
