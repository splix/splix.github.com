---
---

Splix = {}

window.Splix = Splix

Splix.addGitHub = ->
  _.each($('.github-buttons'), (x) ->
    repo = $(x).data('github-repo')
    user = $(x).data('github-user')
    _.each(['fork', 'watch'], (type) ->
      $(x).append("<iframe src='http://ghbtns.com/github-btn.html?user=#{user}&repo=#{repo}&type=#{type}&count=true' allowtransparency='true' frameborder='0' scrolling='0' width='95px' height='24px'></iframe>")
    )
  )

Splix.addDocMenu = ->
  $('.navigation ul').empty()
  _.each($('.main h1'), (h) ->
    id = $(h).attr('id')
    title = $(h).text()
    li = "<li><a href='##{id}'>#{title}</a></li>"
    $('.navigation ul').append(li)
  )

Splix.addRibbon = (repo) ->
  r = "<a href=\"https://github.com/splix/#{repo}\"><img style=\"position: absolute; top: 0; right: 0; border: 0;\" src=\"https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png\" alt=\"Fork me on GitHub\"></a>"
  $('body').append(r)