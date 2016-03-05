$ ->
  animate = () ->
    message = $('.display')
    message.removeClass('hide')
    #message.show ->
    message.addClass('animated flipInX')
    message.one('webkitAnimationEnd oanimationend oAnimationEnd msAnimationEnd animationend', ->
      message.removeClass('animated flipInX');
      setTimeout(->
        message.addClass('animated flipOutX')
        message.one 'webkitAnimationEnd oanimationend oAnimationEnd msAnimationEnd animationend', ->
          message.addClass('hide')
          message.removeClass('animated flipOutX');
          setTimeout(animate, 500)

      , 5000)
    )
  animate()