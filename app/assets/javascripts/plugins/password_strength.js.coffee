### Description ###
# jQuery plugin to adjust a Bootstrap progress bar based on password strength.

### Example: ###
# <input type="password" class="form_control">
# <div class="progress">
#   <div class="progress-bar" role="progressbar" style="width: 0%;">
#     very weak
#   </div>
# </div>
# <script>$('input[type=password]').passwordStrength()</script>

(($) ->
  class Strength
    DESCRIPTION_MAP =
      0: 'very weak'
      1: 'weak'
      2: 'not bad'
      3: 'strong'
      4: 'very strong'

    COLOR_MAP =
      0: 'danger'  # red
      1: 'warning' # orange
      2: 'info'    # ligt blue
      3: ''        # dark blue
      4: 'success' # green

    constructor: (@password) ->
      @result = zxcvbn(@password)
      @score = @result.score

    percent: ->
      # There score will be 0-4 but we use 1-5 for the progress bar so some of
      # it can always be seen
      percentage = (@score + 1) / 5 * 100

    description: ->
      DESCRIPTION_MAP[@score]

    color_class: ->
      color_to_class COLOR_MAP[@score]

    all_classes: ->
      $.map(COLOR_MAP, (v) -> color_to_class(v)).join(' ')

    color_to_class = (color) ->
      "progress-bar-#{color}"

  $.fn.passwordStrength = (options) ->
    settings = $.extend({progress_bar: $('.progress-bar')}, options)
    prog_bar = settings.progress_bar

    this.each (i, el) ->
      pass_box = $(el)

      pass_box.on 'keyup', ->
        strength = new Strength pass_box.val()

        prog_bar.attr 'style', "width: #{strength.percent()}%;"
        prog_bar.html strength.description()
        prog_bar.removeClass strength.all_classes()
        prog_bar.addClass strength.color_class()

) jQuery
