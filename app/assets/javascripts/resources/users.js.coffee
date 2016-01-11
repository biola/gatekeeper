$('#non_biolan_password').passwordStrength()
$('[data-warning]').changeWarning()

if window.location.hash == '#change_password'
  $('#change_password_modal').modal 'show'
