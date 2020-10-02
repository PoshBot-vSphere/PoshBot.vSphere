function Add-PBVMTag {
    <#
    .SYNOPSIS
        PoshBot command to add a new Tag to a VM
    .EXAMPLE
        !addtagtovm vm1 tag1
    #>
    [PoshBot.BotCommand(CommandName = 'addtagtovm')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $true)]
        [string]$vm,
        [parameter(Position = 1, Mandatory = $true)]
        [string]$tag
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($vm -and $tag) {
        $objects = New-TagAssignment -Entity $vm -Tag $tag
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
