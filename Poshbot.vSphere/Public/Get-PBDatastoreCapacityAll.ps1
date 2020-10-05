function Get-PBDatastoreCapacityAll {
    <#
    .SYNOPSIS
        PoshBot command to get capacity of all datastores.
    .EXAMPLE
        !getCapacityAllDS
    #>
    [PoshBot.BotCommand(CommandName = 'getCapacityAllDS')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    $objects = Get-Datastore | Select-Object -Property Name, FreespaceGB, CapacityGB, @{ Name='Provisioned'; Expression={ $_.capacityGb - $_.FreespaceGB + ($_.extensiondata.summary.uncommitted/1GB)}} | Sort-Object Name

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
