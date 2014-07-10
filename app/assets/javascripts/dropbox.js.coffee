# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $("#toggle_upload_form").click ->
    $("#upload_form").slideToggle()

@get_share_link = (path, url, element) ->
  $.ajax(
    dataType: "json"
    url: url
    data:
      path: path
  ).success (data) ->
    $(element).parent().parent().children('.share_result').html data.share_link

