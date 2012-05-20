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

function Duckie() {
  template = $('#result').remove().html();
}

Duckie.prototype.search = function() {
  var query = $("[name='query']").val();
  $.get('/search', {query: query}, function(data) {
      $.each(data, function(indexInArray, valueOfElement) {
        var img = $(template);
        img.attr('src', valueOfElement);
        img.appendTo('#results');
      });
    }
  );
  return false;
}



$(function() {
  var duckie = new Duckie();
  var search = $('#search');
  search.submit(duckie.search);
});
