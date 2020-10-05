function Get-PBDatastore {
    <#
    .SYNOPSIS
        PoshBot command retrieves the datastores available on a vCenter Server system.
    .EXAMPLE
        !getdatastore DS1
    #>
    [PoshBot.BotCommand(CommandName = 'getdatastore')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$ds
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($ds) {
        $objects = Get-Datastore $ds
    }
    else {
        $objects = Get-Datastore | Select-Object Name | Format-Table
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
