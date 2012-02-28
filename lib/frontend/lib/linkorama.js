var Result = Backbone.Model.extend({});

var ResultList = Backbone.Collection.extend({
  model: Result,
  url: '/search',
  search: function(searchTerm) {
    this.fetch({'data': {'q': searchTerm}});
  }
});

var ResultView = Backbone.View.extend({
  tagName: 'div',
  className: 'result',
  template: _.template('<div class="row well"><a href="<%= url %>"><div class="title"><%= title %> - <%= url %></div></a></div>'),
  render: function() {
    $(this.el).append(this.template(this.model.toJSON()));
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
    var q = $(this.el).find('.search-query').val();
    this.model.search(q);
  },
  render: function() {
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
