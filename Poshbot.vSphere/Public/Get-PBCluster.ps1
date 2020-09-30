function Get-PBCluster {
    <#
    .SYNOPSIS
        PoshBot command retrieves the clusters available on a vCenter Server system.
    .EXAMPLE
        !getcluster cluster1
    #>
    [PoshBot.BotCommand(CommandName = 'getcluster')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$cluster
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($cluster) {
        $objects = Get-Cluster $cluster
    }
    else {
        $objects = Get-Cluster
    }
    
    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
