function Stop-PBVMGuest {
    <#
    .SYNOPSIS
        PoshBot command to shutdown VM guest OS. The virtual machine must have VMware Tools installed.
    .EXAMPLE
        !stopvm vm1
    #>
    [PoshBot.BotCommand(CommandName = 'stopvm')]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [parameter(Position = 0, Mandatory = $true, ValueFromRemainingArguments = $true)]
        [string[]]$vm
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds
    if ($vm) {
        $objects = Stop-VMGuest $vm -Confirm:$false
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
