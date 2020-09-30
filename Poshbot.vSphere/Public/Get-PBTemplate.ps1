function Get-PBTemplate {
    <#
    .SYNOPSIS
        PoshBot command retrieves the templates available on a vCenter Server system.
    .EXAMPLE
        !gettemplate windows16
    #>
    [PoshBot.BotCommand(CommandName = 'gettemplate')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$template
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($template) {
        $objects = Get-Template $template
    }
    else {
        $objects = Get-Template | select Name | ft
    }
    
    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
