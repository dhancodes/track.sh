**track.sh** is a Bash script that monitors a specific process on your Linux
system via its PID, collects real-time stats, and sends the report directly to a
Telegram chat using a telegram bot. If the process is no longer running, the script
exits with a message.

### Requirements

- `curl`
- `ps`, `top`, `awk`, `sensors` (install with `lm-sensors`)
- A Telegram bot and a chat ID

### Setting up
Open the script `track.sh` and **manually set** your Telegram credentials:

```bash
# Inside track.sh — replace with your actual values
TG_BOT_TOKEN=""
TG_CHAT_ID=""
```

How to Get Telegram Bot Token
- Open Telegram and message @BotFather.
- Use /start, then /newbot to create a new bot.
- Follow the prompts
- Copy this and paste it into `TG_BOT_TOKEN` in your script.

How to Get Your Chat ID
- Message your bot once (say "Hi").
- Then run this in your terminal (replacing your token):
```bash
curl https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
```
Look for a field like "chat":{"id":123456789,...}
That number is your `TG_CHAT_ID`

![](kopimi-sm.png)
