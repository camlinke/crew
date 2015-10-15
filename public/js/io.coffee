# group = $('#m').data "group"
# console.log group
socket = io()
$('form').submit ->
    socket.emit "chat message", $('#m').val()
    $('#m').val ''
    return false

socket.on "chat message", (msg) ->
    console.log msg
    messageHeader = "#{msg.username}"
    messages = $('#messages')
    messages.append $('<span class="username">').text messageHeader
    messages.append $('<span class="datetime">').html "&nbsp;&nbsp;&nbsp;#{msg.datetime}"
    messages.append $('<p class="content">').text "#{msg.msg}"
    messages.append $('<hr>')
    $('#latest').remove()
    messages.append $('<span id="latest">')
    $('body').animate {
        scrollTop: $(document).height()
    }