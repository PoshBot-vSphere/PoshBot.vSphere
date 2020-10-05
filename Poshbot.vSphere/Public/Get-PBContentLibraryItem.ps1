function Get-PBContentLibraryItem {
    <#
    .SYNOPSIS
        PoshBot command retrieves the items in the content libraries available on a vCenter Server system.
    .EXAMPLE
        !getcontentlibraryitem item1
    #>
    [PoshBot.BotCommand(CommandName = 'getcontentlibraryitem')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$item
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($item) {
        $objects = Get-ContentLibraryItem $item
    }
    else {
        $objects = Get-ContentLibraryItem | Select-Object Name | Format-Table
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
