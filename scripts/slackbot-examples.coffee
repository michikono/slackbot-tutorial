# Description:
#   This description shows up in the /help command
#
# Commands:
#   uppity? - prints out the count of the number of times somebody said "up"
#   bug me - secret surprise
#
# Notes:
#   https://github.com/github/hubot/blob/master/docs/scripting.md#documenting-scripts
#
# Author:
#   Michi Kono
#
module.exports = (robot) ->
  # helper method to get sender of the message
  get_username = (response) ->
    "@#{response.message.user.name}"

  # helper method to get channel of originating message
  get_channel = (response) ->
    if response.message.room == response.message.user.name
      "@#{response.message.room}"
    else
      "##{response.message.room}"

  ###
  # basic example of a fully qualified command
  ###
  # responds to "[botname] sleep it off"
  # note that if you direct message this command to the bot, you don't need to prefix it with the name of the bot
  robot.respond /sleep it off/i, (msg) ->
    # responds in the current channel
    msg.send 'zzz...'

  ###
  # demo of brain functionality (persisting data)
  # https://github.com/github/hubot/blob/master/docs/scripting.md#persistence
  # counts every time somebody says "up"
  # prints out the count when somebody says "are we up?"
  ###
  # /STUFF/ means match things between the slashes. the stuff between the slashes = regular expression.
  # \b is a word boundary, and basically putting it on each side of a phrase ensures we are matching against
  # the word "up" instead of a partial text match such as in "sup"
  robot.hear /\bup\b/, (msg) ->
    # note that this variable is *GLOBAL TO ALL SCRIPTS* so choose a unique name
    robot.brain.set('everything_uppity_count', (robot.brain.get('everything_uppity_count') || 0) + 1)

  # ? is a special character in regex so it needs to be escaped with a \
  # the i on the end means "case *insensitive*"
  robot.hear /are we up\?/i, (msg) ->
    msg.send "Up-ness: " + (robot.brain.get('everything_uppity_count') || "0")

  # A script to watch a channel's new members
  channel_to_watch = '#bot-test'
  robot.enter (msg) ->
    # limit our annoyance to this channel
    if(get_channel(msg) == channel_to_watch)
      # https://github.com/github/hubot/blob/master/docs/scripting.md#random
      msg.send msg.random ['welcome', 'hello', 'who are you?']

  ###
  # demo of replying to specific messages
  # replies to any message containing an "!" with an exact replica of that message
  ###
  # .* = matches anything; we access the entire matching string using match[0]
  # for using regex, use this tool: http://regexpal.com/
  robot.hear /.*!.*/, (msg) ->
    # send back the same message
    # reply prefixes the user's name in front of the text
    msg.reply msg.match[0]

  ###
  # Example of building an external endpoint (that lives on your heroku app) for others things to trigger your bot to do stuff
  # To see this in action, visit https://[YOUR BOT NAME].herokuapp.com/hubot/my-custom-url/:room after deploying
  # This could be used to let bots talk to each other, for example.
  # More on this here: https://github.com/github/hubot/blob/master/docs/scripting.md#http-listener
  ###
  # robot.router.get should probably be a .post to prevent spiders from making it fire
  robot.router.get '/hubot/my-custom-url/:room', (req, res) ->
    robot.emit "bug-me", {
      room: req.params.room
      # note the REMOVE THIS PART in this example -- since we are using a GET and the link is being published in the chat room
      # it can cause an infinite loop since slack itself pre-fetches URLs it sees
      source: "a HTTP call to #{process.env.HEROKU_URL or ''}[/ REMOVE THIS PART ]/hubot/my-custom-url/#{req.params.room} (could be any room name)"
    }
    # reply to the browser
    res.send 'OK'

  ###
  # Secondary example of triggering a custom event
  # note that if you direct message this command to the bot, you don't need to prefix it with the name of the bot
  ###
  robot.respond /bug me/i, (msg) ->
    robot.emit "bug-me", {
      # removing the @ symbol
      room: get_username(msg).slice(1),
      source: 'use of the bug me command'
    }

  ###
  # A generic custom event listener
  # Also demonstrating how to send private messages and messages to specific channels
  # https://github.com/github/hubot/blob/master/docs/scripting.md#events
  ###
  robot.on "bug-me", (data) ->
    try
      # this will do a private message if the "data.room" variable is the user id of a person
      robot.messageRoom data.room, 'This is a custom message due to ' + data.source
    catch error

  ###
  # Demonstration of how to parse private messages
  ###
  # responds to all private messages with a mean remark
  robot.hear /./i, (msg) ->
    # you can chain if clauses on the end of a statement in coffeescript to make things look cleaner
    # in a direct message, the channel name and author are the same
    msg.send 'shoo!' if get_channel(msg) == get_username(msg)

  # any message above not yet processed falls here. See the console to examine the object
  # uncomment to test this
  # robot.catchAll (response) ->
  #   console.log('catch all: ', response)

