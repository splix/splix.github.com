Splix =
  os: {}

window.Splix = Splix

Splix.os.addGitHub = ->
  _.each($('.github-buttons'), (x) ->
    repo = $(x).data('github-repo')
    user = $(x).data('github-user')
    _.each(['fork', 'watch'], (type) ->
      $(x).append("<iframe src='http://ghbtns.com/github-btn.html?user=#{user}&repo=#{repo}&type=#{type}&count=true' allowtransparency='true' frameborder='0' scrolling='0' width='95px' height='24px'></iframe>")
    )
  )