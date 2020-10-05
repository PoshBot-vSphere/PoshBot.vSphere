function Get-PBContentLibrary {
    <#
    .SYNOPSIS
        PoshBot command retrieves the content libraries available on a vCenter Server system.
    .EXAMPLE
        !getcontentlibrary library1
    #>
    [PoshBot.BotCommand(CommandName = 'getcontentlibrary')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$library
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($library) {
        $objects = Get-ContentLibrary $library
    }
    else {
        $objects = Get-ContentLibrary | Select-Object Name
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
