(function() {
  var Splix;

  Splix = {};

  window.Splix = Splix;

  Splix.addGitHub = function() {
    return _.each($('.github-buttons'), function(x) {
      var repo, user;

      repo = $(x).data('github-repo');
      user = $(x).data('github-user');
      return _.each(['fork', 'watch'], function(type) {
        return $(x).append("<iframe src='http://ghbtns.com/github-btn.html?user=" + user + "&repo=" + repo + "&type=" + type + "&count=true' allowtransparency='true' frameborder='0' scrolling='0' width='95px' height='24px'></iframe>");
      });
    });
  };

  Splix.addDocMenu = function() {
    $('.navigation ul').empty();
    return _.each($('.main h1'), function(h) {
      var id, li, title;

      id = $(h).attr('id');
      title = $(h).text();
      li = "<li><a href='#" + id + "'>" + title + "</a></li>";
      return $('.navigation ul').append(li);
    });
  };

  Splix.addRibbon = function(repo) {
    var r;

    r = "<a href=\"https://github.com/splix/" + repo + "\"><img style=\"position: absolute; top: 0; right: 0; border: 0;\" src=\"https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png\" alt=\"Fork me on GitHub\"></a>";
    return $('body').append(r);
  };

}).call(this);
