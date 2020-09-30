function New-PBVMSnapshot {
    <#
    .SYNOPSIS
        PoshBot command to create VM Snapshot
    .EXAMPLE
        !newvmsnapshot -vm VM01 -name 'snapshot' -Description 'before upgrade'
    #>
    [PoshBot.BotCommand(CommandName = 'newvmsnapshot')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $true, ValueFromRemainingArguments = $true)]
        [string]$vm,
        [parameter(Position = 1, Mandatory = $true, ValueFromRemainingArguments = $true)]
        [string]$name,
        [parameter(Position = 2, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string]$description
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds

    $objects = New-Snapshot -vm $vm -name $name -Description $description -Confirm:$false

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
