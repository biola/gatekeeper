### Description ###
# jQuery plugin to present a warning when an input is changed

### Example: ###
# <div id="email_warning">I wouldn't do that if I were you</div>
# <input type="email" name="email" data-warning="#email_warning">
# <script>$('input[type=password]').changeWarning()</script>

(($) ->
  $.fn.changeWarning = ->
    this.each (i, el) ->
      input = $(el)
      warning = $(input.data('warning'))

      input.data 'original-value', input.val()
      warning.hide()

      input.on 'keyup', ->
        if input.val() != input.data('original-value')
          warning.slideDown()
        else
          warning.slideUp()

) jQuery
