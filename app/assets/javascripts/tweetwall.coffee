$ ->
  message = $('.display')
  if message.length <= 0
    return false
  loader = $('#loader')
  updateIntervalTime = 5000
  animationsIn = ['bounceInRight', 'bounceInUp', 'bounceInDown', 'bounceInLeft']
  animationsOut = ['bounceOutRight', 'bounceOutUp', 'bounceOutDown', 'bounceOutLeft']
  pool = []
  viewed = []
  graphicThreadLaunched = false
  dataThreadLaunched = false

  updatePool = ()->
    dataThreadLaunched = true
    $.get('/publications.json', (results)->
      $.each results, (i, tweet)->
        if $.inArray(tweet.id,viewed) is -1
          viewed.push tweet.id
          pool.push tweet
      setTimeout(updatePool, 1000)
    )

  firstLoad = true
  nextGraphicUpdate = updateIntervalTime

  writeTweetInDOM = (tweet) ->
    message.find('.content').html(twemoji.parse(tweet.content))
    message.find('.tweet-from > .user').html(tweet.author)
    message.find('.tweet-from > img').attr('src', tweet.author_image)
    unless tweet.resource_type == "" or tweet.resource_type == null
      message.find('.tweet').addClass('with-resource')
      message.find('.tweet').removeClass('without-resource')
      media = message.find('.media')
      media.find('>*').addClass('hide')
      media.find('>video').each (video)->
        $(this).get(0).pause();
      switch tweet.resource_type
        when 'image' then media.find('img').attr('src', tweet.resource).removeClass('hide')
        when 'video'
          video = media.find('video').attr('src', tweet.resource).removeClass('hide')[0]
          video.play()
        when 'gif'
          domElem = media.find('video').attr('src', tweet.resource).removeClass('hide')[0]
          domElem.play()
    else
      message.find('.tweet').removeClass('with-resource')
      message.find('.tweet').addClass('without-resource')
    if tweet.time
      nextGraphicUpdate = Math.max(tweet.time-2,updateIntervalTime)
    #message.find('.content').textfill('50')

  loadNextTweet = (animationOut, animationIn) ->
    message.addClass('hide')
    message.removeClass('animated ' + animationOut)
    # Update Logic
    element = pool.pop()
    writeTweetInDOM(element)
    loader.addClass 'hide'
    # Show the new tweet
    message.removeClass 'hide'
    message.addClass 'animated ' + animationIn
    message.one 'webkitAnimationEnd oanimationend oAnimationEnd msAnimationEnd animationend', ->
      message.removeClass 'animated ' + animationIn
      setTimeout refreshFromPool, nextGraphicUpdate

  refreshFromPool = () ->
    graphicThreadLaunched = true
    nextGraphicUpdate = updateIntervalTime
    if pool.length>0
      animationOut = animationsOut[Math.floor(Math.random()*animationsOut.length)]
      animationIn = animationsIn[Math.floor(Math.random()*animationsIn.length)]
      if firstLoad
        loadNextTweet(animationOut, animationIn)
        firstLoad = false
      else
        # Hide the current tweet
        message.addClass('animated '+animationOut)
        message.one 'webkitAnimationEnd oanimationend oAnimationEnd msAnimationEnd animationend', ->
          loadNextTweet(animationOut, animationIn)
    else
      viewed = []
      setTimeout(refreshFromPool, 10)
  updatePool()
  setTimeout(refreshFromPool, 100);
  setInterval( () ->
    if(firstLoad == false)
      $('.content').fitText()
  , 100)