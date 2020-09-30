function Get-PBDatacenter {
    <#
    .SYNOPSIS
        PoshBot command retrieves the datacenters available on a vCenter Server system.
    .EXAMPLE
        !getdatacenter DC1
    #>
    [PoshBot.BotCommand(CommandName = 'getdatacenter')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$dc
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($dc) {
        $objects = Get-Datacenter $dc
    }
    else {
        $objects = Get-Datacenter | select Name | ft
    }
    
    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
