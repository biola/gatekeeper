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

$('#non_biolan_password').passwordStrength()
