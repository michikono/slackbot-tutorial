# Slackbot Tutorial Bot

This tutorial is geared toward writing a Slack hubot instance. It includes demos and examples that work in hubot + slack (but could work with another adapter).

### Overview

* An accompanying blog post can be found here: http://www.michikono.com/2015/07/10/in-depth-tutorial-on-writing-a-slackbot/
* This project contains a more thorough set of example scripts in [slackbot-examples.coffee](https://github.com/michikono/slackbot-tutorial/blob/master/scripts/slackbot-examples.coffee). 

### Running tutorial Locally

You can test your hubot by running the following.

You can start hubot-tutorial locally by running:

    % npm install
    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt:

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot-tutorial by typing `hubot help`.

    hubot> hubot help

    hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...

You can test out custom commands by typing them in as if you were in a chat room with the bot:

    hubot> hubot sleep it off
    hubot> zzz...

### Steps to recreate this bot ###
 
If you have root permissions on your current user account:
 
    npm install -g hubot coffee-script yo generator-hubot
    mkdir -p /path/to/hubot
    cd /path/to/hubot
    yo hubot
    # choose "slack" as the adapter
    
Otherwise:

    npm config set prefix ~/.npm
    export PATH="$PATH:$HOME/.npm/bin"
    npm install hubot coffee-script yo generator-hubot
    mkdir -p /path/to/hubot
    cd /path/to/hubot
    yo hubot
    # choose "slack" as the adapter

Install redis (the database that powers hubot):

If you have brew, use this:

    brew install redis
        
Otherwise, use this resource: http://redis.io/topics/quickstart

Start redis:

    redis-server

### Scripting

An example script is included at [`scripts/slackbot-examples.coffee`](https://github.com/michikono/slackbot-tutorial/blob/master/scripts/slackbot-examples.coffee), so check it out to
get started, along with the [Scripting Guide](https://github.com/github/hubot/blob/master/docs/scripting.md).


### hubot-scripts

There will inevitably be functionality that everyone will want. Instead
of writing it yourself, you can check
[hubot-scripts][hubot-scripts] for existing scripts.

To enable scripts from the hubot-scripts package, add the script name with
extension as a double quoted string to the `hubot-scripts.json` file in this
repo.

[hubot-scripts]: https://github.com/github/hubot-scripts

Once you write this, check out my [todo](https://github.com/michikono/how-tos/blob/master/publishing-hubot-scripts-with-npm.md) on how to publish it to NPM.

### external-scripts

Hubot is able to load scripts from third-party `npm` package. Check the package's documentation, but in general it is:

1. Add the packages as dependencies into your `package.json`
2. `npm install` to make sure those packages are installed
3. Add the package name to `external-scripts.json` as a double quoted string

You can review `external-scripts.json` to see what is included by default.

##  Persistence

If you are going to use the `hubot-redis-brain` package
(strongly suggested), you will need to add the Redis to Go addon on Heroku which requires a verified
account or you can create an account at [Redis to Go][redistogo] and manually
set the `REDISTOGO_URL` variable.

    % heroku config:add REDISTOGO_URL="..."

If you don't require any persistence feel free to remove the
`hubot-redis-brain` from `external-scripts.json` and you don't need to worry
about redis at all.

[redistogo]: https://redistogo.com/

## Testing the bot locally:

    HUBOT_SLACK_TOKEN=YOUR_TOKEN_HERE ./bin/hubot -a slack
    
## Deployment

This is a modified set of instructions based on the [instructions on the Hubot wiki](https://github.com/github/hubot/blob/master/docs/deploying/heroku.md).

- Follow the instructions above to create a hubot locally
- Edit your `Procfile`; it should look something like this:

        web: bin/hubot --adapter slack

- Install [heroku toolbelt](https://toolbelt.heroku.com/) if you haven't already.
- `heroku create my-company-slackbot`
- `heroku addons:add redistogo:nano`
- Activate the Hubot service on your ["Team Services"](http://my.slack.com/services/new/hubot) page inside Slack.
- Add the [config variables](#adapter-configuration). For example:

        % heroku config:add HUBOT_SLACK_TOKEN=xoxb-1234-5678-91011-00e4dd
        % heroku config:add HEROKU_URL=http://my-company-slackbot.herokuapp.com

- Deploy and start the bot:

        % git push heroku master
        % heroku ps:scale web=1

- Profit!

## Configuration

This adapter uses the following environment variables:

 - `HUBOT_SLACK_TOKEN` - this is the API token for the Slack user you would like to run Hubot under.

To add or remove your bot from specific channels or private groups, you can use the /kick and /invite slash commands that are built into Slack.

## Restart the bot

You may want to get comfortable with `heroku logs` and `heroku restart`
if you're having issues.
