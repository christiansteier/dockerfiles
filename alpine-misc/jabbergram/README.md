# Jabbergram (x86_64 and armhf)
[Jabbergram](https://daemons.cf/cgit/jabbergram/about/), a simple XMPP-Telegram gateway by [drymer](https://daemons.cf/contacto.html). With this program, it's possible to use a MuC 
XMPP room to talk to a group on Telegram and vice versa. 

## Configuration
First create Telegram Bot. Talk to BotFather:
```
/start
/newbot
YourNameBot # ended in bot, always
# then it will show your bot token, save it
/setprivacy
YourNameBot
# now press Disable
```
Then copy docker-compose.yml and modify the environment variables:
```
JID=exampleJid@nope.org
JIDPASS=difficultPassword
MUC=exampleMuc@muc.nope.org
NICK=jabbergram
TOKEN=jabbergramBotTokken
GROUP=-10293943920
```
