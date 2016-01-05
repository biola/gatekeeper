if $('body.users').length > 0
  email = $('input#non_biolan_email')
  warning = $('#email_warning')
  warning.hide()

  email.data('original_value', email.val())
  email.on 'keyup', ->
    if email.val() != email.data('original_value')
      warning.slideDown()
    else
      warning.slideUp()

prog_bar = $('.progress-bar')
if prog_bar.length > 0
  pass_box = $('#non_biolan_password')

  description_map = {
    0: 'very weak'
    1: 'weak'
    2: 'not bad'
    3: 'strong'
    4: 'very strong'
  }

  color_map = {
    0: 'danger'
    1: 'warning'
    2: 'info'
    3: 'success'
    4: 'success'
  }

  pass_box.on 'keyup', ->
    result = zxcvbn(pass_box.val())
    score = result.score
    percentage = score/4 * 100

    prog_bar.attr 'style', "width: #{percentage}%;"
    prog_bar.html description_map[score]
    for _, color of color_map
      prog_bar.removeClass "progress-bar-#{color}"
    prog_bar.addClass "progress-bar-#{color_map[score]}"
