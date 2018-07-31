<#
        .Synopsis
        The Remove-TFSItem command removes files and folders from the Team Foundation version control server and deletes them from the disk.
#>

Function Remove-TFSItem
{
    [CmdletBinding()]
    param
    (
        # Root directory for the workspace you are branching in.
        [String]
        [Parameter(Mandatory = $true)]
        $WorkingDirectory,

        # Identifies the file or folder to delete from the Team Foundation version control server.
        [String]
        [Parameter(Mandatory = $true)]
        $ItemSpec,

        # Prevents other users from checking in or checking out the specified items.
        [String]
        [Parameter(Mandatory = $false)]
        [ValidateSet('none','checkin','checkout')]
        $Lock = 'none',

        # Deletes all files and/or folders and subfolders that match the itemspec from the specified directory.
        [Parameter(Mandatory = $false)]
        [switch]
        $Recursive,

        # Provides a value to the /login option. You can specify a username value as either DOMAIN*UserName* or UserName.
        [pscredential]
        [Parameter(Mandatory = $false)]
        $Credential
    )
    Begin
    {
        $Tfexe = Get-TFSTfexe
    }
    Process
    {
        Set-Location -Path $WorkingDirectory
        $arguments = @(
            'delete'
            '{0}' -f $ItemSpec
        )
        If ($Lock)
        {
            $arguments += '/lock:"{0}"' -f $Lock
        }
        If ($Recursive)
        {
            $arguments += '/recursive'
        }

        . $Tfexe $arguments
    }
    End
    {
    }
}

