function Get-PBFolder {
    <#
    .SYNOPSIS
        PoshBot command retrieves the folders available on a vCenter Server system.
    .EXAMPLE
        !getfolder folder1
    #>
    [PoshBot.BotCommand(CommandName = 'getfolder')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$folder
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($folder) {
        $objects = Get-Folder $folder
    }
    else {
        $objects = Get-Folder | Select-Object Name | Format-Table
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
