function Remove-PBVMSnapshot {
    <#
    .SYNOPSIS
        PoshBot command to retrieve VM Snapshot
    .EXAMPLE
        !getvmsnapshot -vm VM01
    #>
    [PoshBot.BotCommand(CommandName = 'removevmsnapshot')]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory=$true)]
        [parameter(ParameterSetName="IndividualSnapshot")]
        [parameter(ParameterSetName="AllSnapshots")]
        [hashtable]$Connection,
        [parameter(Mandatory = $true)]
        [parameter(ParameterSetName="IndividualSnapshot")]
        [parameter(ParameterSetName="AllSnapshots")]
        [string]$vm,
        [parameter(Mandatory=$true, ParameterSetName="IndividualSnapshot")]
        [string]$name,
        [parameter(Mandatory=$true,ParameterSetName="AllSnapshots")]
        [Switch]$all
    )

    #Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-VIServer -Server $Connection.Server -Credential $creds

    if ($all) {
        $objects = Get-Snapshot -VM $vm | Remove-Snapshot -Confirm:$false
    }
    else {
        $objects = Get-Snapshot -VM $vm -Name $name | Remove-Snapshot -Confirm:$false
    }


        $ResponseSplat = @{
            Text = "Snapshot(s) removed"
            AsCode = $true
        }

    Disconnect-Viserver -Confirm:$false
    New-PoshBotTextResponse @ResponseSplat
}
