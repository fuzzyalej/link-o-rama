var Result = Backbone.Model.extend({});

var ResultList = Backbone.Collection.extend({
  model: Result,
  url: '/search',
  search: function(searchTerm) {
    this.fetch({'data': {'q': searchTerm}});
  }
});

var ResultView = Backbone.View.extend({
  tagName: 'li',
  className: 'result',
  render: function() {
    console.log('called render on view');
    $(this.el).append("<h1>hola hola</h1>");
    return this.el;
  }
});

var SearchView = Backbone.View.extend({
  initialize: function() {
    $(this.el).find('#search-button').click(_.bind(this.do_search, this));
    this.model.on('reset', _.bind(this.render, this));
  },
  do_search: function(e) {
    e.preventDefault();
    console.log("do_search");
    var q = $(this.el).find('.search-query').val();
    this.model.search(q);
  },
  render: function() {
    console.log("render?");
    var container = $(this.el).find('#results');
    container.html('');
    this.model.each(function(m) {
      container.append(new ResultView({model: m}).render());
    });
  }
});

//Start the app
$(function(){
  var search_view = new SearchView({el: $('body'), model: new ResultList()});
});
