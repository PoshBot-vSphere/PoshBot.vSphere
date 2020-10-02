function New-PBTag {
    <#
    .SYNOPSIS
        PoshBot command to create a new Tag.
    .EXAMPLE
        !newtag tag1 tagCateg1
    #>
    [PoshBot.BotCommand(CommandName = 'newtag')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $true)]
        [string]$tag,
        [parameter(Position = 1, Mandatory = $true)]
        [string]$tagCategory
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($tag -and $tagCategory) {
        $objects = New-Tag -Name $tag -Category $tagCategory
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
