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

At this point you are good to go in terms of Poshbot.  You could, if you wanted start the bot by executing `Start-PoshBot -Configuration $pbc -Verbose`.  That said, it's better to set PoshBot up to run as a service.  Again, we will follow the process laid out in [this blog](http://ramblingcookiemonster.github.io/PoshBot/).  To get started, you will need nssm to create the service, you can find that [here](https://nssm.cc/)

5. Create Start-Poshbot.ps1 - create a new file called `Start-Poshbot.ps1` within your `c:\Poshbot` directory with the following code
```
Import-Module PoshBot -force
$pbc = Get-PoshBotConfiguration -Path C:\poshbot\config.psd1

while($True)
{
    try
    {
        $err = $null
        Start-PoshBot -Configuration $pbc -Verbose -ErrorVariable err
        if($err)
        {
            throw $err
        }
    }
    catch
    {
        $_ | Format-List -Force | Out-String | Out-File (Join-Path $pbc.LogDirectory Service.Error)
    }
}
```

6. Create the service based off of `Start-Poshbot`.  Execute the folowing to create a new service within Windows to control your Poshbot
```
$nssm = 'C:\nssm.exe'

$ServiceName = 'poshbot'
$ServicePath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
$ServiceArguments = "-ExecutionPolicy Bypass -NoProfile -File C:\poshbot\start-poshbot.ps1"

& $nssm install $ServiceName $ServicePath $ServiceArguments
Start-Sleep -Seconds .5

# check the status... should be stopped
& $nssm status $ServiceName

# start things up!
& $nssm start $ServiceName

# verify it's running
& $nssm status $ServiceName
```

You are now good to go - you can turn the bot on/off and restart using the native windows services control.  You should be able to head into slack and send your bot one of the generic built in commands such as `!help` or `!about`

Now is time to get the vSphere plugin running

### PoshBot.vSphere plugin configuration
