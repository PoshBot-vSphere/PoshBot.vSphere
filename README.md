# PoshBot.vSphere
vSphere PoshBot Plugin

## Getting Started
Here are the steps to getting started with the vSphere PoshBot Plugin

### Install and configure Poshbot
For the most part, the easiest way I've found to get up and running in a solid way is to follow the steps laid out in [this blog post](http://ramblingcookiemonster.github.io/PoshBot/).  For the sake of permanence, I'll summarize below:

1. Grab an API token from your slack team and save for Step 3
    - Browse to `https://YOURSLACKTEAM.slack.com/services/new/bot`
    - Name the bot, remember this for later
    - Once created, copy the generated API token for later use

2. Install and Import the module. Run the following in a PowerShell session
```
Install-Module Poshbot -Force -AllowClobber
Import-Module Poshbot
```
3. Define configuration variables. Run the following in a PowerShell session:
```
$Token = 'YOUR SECRET API TOKEN HERE'
$BotName = 'The Name you chose' # The name of the bot we created
$BotAdmin = 'mwpreston' # My account name in Slack, not the bot name
$PoshbotPath = 'C:\poshbot'
$PoshbotConfig = Join-Path $PoshbotPath config.psd1
$PoshbotPlugins = Join-Path $PoshbotPath plugins
$PoshbotLogs = Join-Path $PoshbotPath logs

$BotParams = @{
    Name = $BotName
    BotAdmins = $BotAdmin
    CommandPrefix = '!'
    LogLevel = 'Info'
    BackendConfiguration = @{
        Name = 'SlackBackend'
        Token = $Token
    }
    AlternateCommandPrefixes = 'bender', 'hal'
    ConfigurationDirectory = $PoshbotPath
    LogDirectory = $PoshbotLogs
    PluginDirectory = $PoshbotPlugins
}
```
4. Create the folders/structure for Poshbot to run.  Execute the following in a PowerShell session:
```
$null = mkdir $PoshbotPath, $PoshbotPlugins, $PoshbotLogs -Force
$pbc = New-PoshBotConfiguration @BotParams
Save-PoshBotConfiguration -InputObject $pbc -Path $PoshbotConfig
```

