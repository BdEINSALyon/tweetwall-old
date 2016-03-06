$ ->
  message = $('.display')
  updateIntervalTime = 5000
  animationsIn = ['flipInX', 'fadeInLeft', 'bounceInRight', 'bounceInLeft', 'zoomInDown', 'zoomInUp', 'rollIn']
  animationsOut = ['flipOutX', 'fadeOutLeft', 'bounceOutRight', 'bounceOutLeft', 'zoomOutDown', 'zoomOutUp', 'rollOut', 'hinge']
  pool = []
  viewed = []

  updatePool = ()->
    $.get('/publications.json', (results)->
      $.each results, (i, tweet)->
        if $.inArray(tweet.id,viewed) is -1
          viewed.push tweet.id
          pool.push tweet
      setTimeout(updatePool, updateIntervalTime*2)
    )

  refreshFromPool = () ->
    if pool.length>0
      animationOut = animationsOut[Math.floor(Math.random()*animationsOut.length)]
      animationIn = animationsIn[Math.floor(Math.random()*animationsIn.length)]
      # Hide the current tweet
      message.addClass('animated '+animationOut)
      message.one 'webkitAnimationEnd oanimationend oAnimationEnd msAnimationEnd animationend', ->
        message.addClass('hide')
        message.removeClass('animated '+animationOut)

        # Update Logic
        element = pool.pop()

        message.find('.content > span').html(element.content)
        message.find('.tweet-from > .user').html(element.author)
        message.find('.tweet-from > img').attr('src', element.author_image)
        unless element.resource_type == ""
          message.find('.tweet').addClass('with-resource')
          message.find('.tweet').removeClass('without-resource')
        else
          message.find('.tweet').removeClass('with-resource')
          message.find('.tweet').addClass('without-resource')
        message.find('.content').textfill('50')
        # Show the new tweet
        message.removeClass 'hide'
        message.addClass 'animated '+animationIn
        message.one 'webkitAnimationEnd oanimationend oAnimationEnd msAnimationEnd animationend', ->
          message.removeClass 'animated '+animationIn
          setTimeout refreshFromPool, updateIntervalTime
    else
      viewed = []
      setTimeout(refreshFromPool, updateIntervalTime/2)

  animate = () ->
    message.removeClass('hide')
    message.addClass('animated flipInX')
    message.find('.content').textfill('50')
    message.one('webkitAnimationEnd oanimationend oAnimationEnd msAnimationEnd animationend', ->
      message.removeClass('animated flipInX');
      setTimeout(refreshFromPool, 5000)
    )
  animate()
  updatePool()