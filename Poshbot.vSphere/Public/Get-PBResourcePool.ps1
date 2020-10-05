function Get-PBResourcePool {
    <#
    .SYNOPSIS
        PoshBot command retrieves the resource pools available on a vCenter Server system.
    .EXAMPLE
        !getpool pool1
    #>
    [PoshBot.BotCommand(CommandName = 'getpool')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$pool
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($pool) {
        $objects = Get-ResourcePool $pool
    }
    else {
        $objects = Get-ResourcePool | Select-Object Name | Format-Table
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
