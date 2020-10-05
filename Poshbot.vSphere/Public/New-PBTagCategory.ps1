function New-PBTagCategory {
    <#
    .SYNOPSIS
        PoshBot command to create a new Tag Category.
    .EXAMPLE
        !newtagcategory tagCateg1
    #>
    [PoshBot.BotCommand(CommandName = 'newtagcategory')]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $true, ValueFromRemainingArguments = $true)]
        [string]$tagCategory
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($tagCategory) {
        $objects = New-TagCategory -Name $tagCategory
    }
    else {
        exit
    }

    $ResponseSplat = @{
        Text = Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
