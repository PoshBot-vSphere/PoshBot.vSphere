function Get-PBVMAllWithTag {
    <#
    .SYNOPSIS
        PoshBot command to get all Entities to which the Tags is assigned
    .EXAMPLE
        !getallvmswithtag tag1
    #>
    [PoshBot.BotCommand(CommandName = 'getallvmswithtag')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $true)]
        [string]$tag
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($tag) {
        $objects = (Get-TagAssignment | Where {$_.Tag.Name -eq $tag}).Entity | Select Name
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
