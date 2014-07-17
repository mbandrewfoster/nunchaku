# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#
#= require bootstrap
#= require bootstrap-datepicker
#= require bootstrap3-editable/bootstrap-editable
#= require select2
#= require gritter
#= require_tree .
#= require_self

$ ->
	$(".select2-container").width("100%")

$ ->
  $("a[data-behaviour='editable']").editable
    params: (params) ->
      params['_method'] = 'put'
      params["#{$(this).data('resource')}[#{params.name}]"] = params.value

      params

window.nunchaku = {}

window.nunchaku.selection_affects_other = (selector, other, url, param_callback) ->
  $(selector).change ->
    params =
      if typeof param_callback is "undefined"
        selection: $(this)[0].value
      else
        param_callback()
    $.get(url, params).done (data) ->
      $(other).replaceWith data
      return
