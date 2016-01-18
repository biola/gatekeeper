if $('#trogdir_uuid_form').length > 0
  type_field = $('#id_type_field')
  type_label = $('#id_type_label')

  $('#trogdir_uuid_form ul.dropdown-menu a').on 'click', (e) ->
    option = $(e.currentTarget)
    type_field.val option.data 'slug'
    type_label.html option.html()

    e.preventDefault()

  $('#trogdir_person button.close').on 'click', (e) ->
    $('#trogdir_uuid').attr 'disabled', false
