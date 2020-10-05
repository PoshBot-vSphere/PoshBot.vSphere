function Get-PBHost {
    <#
    .SYNOPSIS
        PoshBot command retrieving host information
    .EXAMPLE
        !gethost hostname
    #>
    [PoshBot.BotCommand(CommandName = 'gethost')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$host
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($host) {
        $objects = Get-VMHost $host
    }
    else {
        $objects = Get-VMHost | Select-Object Name | Format-Table
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-VIServer -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
