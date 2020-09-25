function Format-PBvSphereObject {
    <#
    .SYNOPSIS
    Unified function to format output to be used by the public functions
    .DESCRIPTION
    Format the output as strings and with a set width, will display different objects based on the function that called it
    .EXAMPLE
    Format-PBvSphereObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
    Description
    -----------
    When called from another vSphere Module for PoshBot function, the function name will be used to determine the type of objects is contained in the $objects variable
    #>
        param (
            # The objects returned by the API, will be reformatted
            [Parameter(
                Position = 0)]
            $Object,
            # Name of the function that calls this function, will be used to create custom message if no objects are returned
            [Parameter(
                Position = 1)]
            [string] $FunctionName
        )
    
        if (($object.count -eq 0) -or (-not $object)) {
            $msg = 'No {0} found'
            switch ($functionname) {
                'Get-PBVM' {$msg -f 'virtual machines'}
                'Set-PBVMPowerStatus' {$msg -f 'vm power status'}
                default {$msg -f 'objects'}
            }
        } else {
            $object | Format-List | Out-String -Width 120
        }
    }