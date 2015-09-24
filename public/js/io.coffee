socket = io()
$('form').submit ->
    socket.emit 'chat message', $('#m').val()
    $('#m').val ''
    return false

socket.on 'chat message', (msg) ->
    console.log msg
    messageHeader = "#{msg.username} #{msg.datetime}"
    $('#messages').append $('<span class="username">').text(messageHeader)
    $('#messages').append $('<p class="content">').text(msg.msg)
    $('#messages').append $('<hr>')