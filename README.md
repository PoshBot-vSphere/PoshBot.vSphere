# PoshBot.vSphere
The vSphere PoshBot Plugin will allow you to command and control your vSphere environment through the usage of PoshBot, directly from Slack!
Let's face it, we spend a lot of time in Slack these days - and we get a lot of requests from application owners and end-users.  This plugin will save you time by allowing you to simply issue commands directly from Slack to answer those mundane day-to-day questions, without having to jump into a PowerCLI session or open a UI.  

When an application owner asks you to take a snapshot for them - rather than jumping into the UI you can simply issue the `!newvmsnapshot -vm VM01 -name "Snapshot"` command.
When an end user complains of not being able to access a servce - quickly get the status of the VM with the `!getvm -vm VM01` command!  Oh, it's not powered on, start it up with the `!startVM -vm VM01` command.

Manage Snapshots, manage VMs, configure Tags, gather information about your environment, start and stop VMs - all without leaving the Slack workspace!

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

Now let's set a few PowerCLI defaults so we don't see nasty errors and warnings when we import the VMware.PowerCLI module

### VMware.PowerCLI settings

You know that annoying message about joining up for the customer experience program that pops up everytime you connect to a vCenter Server? Well, that is displayed as a PowerShell `Warning` - and if we don't disable it, you will see that come through in your PoshBot experience as a nasty yellow exclamation warning :warning: in Slack.  How about ignoring self signed certs - if we don't do that, and you are using them like 90% of the world, you actually see an error :x:. Use the following code to get around these issues and get yourself a nice clean, green checkmark :heavy_check_mark:
```
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope AllUsers
Set-PowerCLIConfiguration -ParticipateInCeip $False -Scope AllUsers
```

That's it for that!  Time to configure the actual vSphere Plugin now!

### PoshBot.vSphere plugin configuration

Adding and configuring the vSphere Poshbot plugin can be accomplished with the following steps
1. Download or clone this repository.  Ensure that you place the included PoshBot.vSphere (not the wrapper folder) into one of your supported module paths (`$env.PSModulePath`) or the `c:\Poshbot\plugins` directory
2. Add the following configuration to the `PluginConfiguration` hashtable inside your Poshbot configuration file. If following along here, that would be `c:\poshbot\config.psd1`.  Replace the valueds with your desired vCenter you would like to manage.
```
  PluginConfiguration = @{
    'PoshBot.vSphere' = @{
      Connection = @{
        Server   = 'vcenter.fqdn'
        Username = 'username'
        Password = 'password'
      }
    }
  }
  ```
  3. Restart your PoshBot service to include the newly modified configuration
  4. Issue the following command to install the plugin into your poshbot instance
  ```
  !installplugin PoshBot.vSphere
  ```
  5. You should be able to now issue commands to your vSphere Poshbot instance. For instance, to see a list of the vms, you could run the following command
  ```
  !getvm
  ```

  That's it, your done, Happy Chatting
  ## Contributing
  We will gladly accept any code and non code contributions to this project through Pull Requests on this repository.  A few things to keep in mind.
  - Any commands that you want to be public (executable from slack) need to be placed in their own file under the `Public` directory
  - Any commands that are private in nature, and could be reusable should be placed in the `Private` directory
  - In order for a command to be available, it must be added to the `FunctionsToExport` array inside `PoshBot.vSphere.psd1`
  - We will soon have the requirement for unit tests as well, but in the effort to get this project moving, they are not required at the moment
  - Simply issue a Pull request with your desired changes to the master branch of this repository, we will review, and merge - Easy Peasy!
