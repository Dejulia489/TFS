<#
        .Synopsis
        The New-TFSBranch command copies an item or set of items, including metadata and version control history, from one location to another in the Team Foundation version control server and in the local workspace.
#>

Function New-TFSBranch
{
    [CmdletBinding()]
    param
    (
        # Root directory for the workspace you are branching in.
        [String]
        [Parameter(Mandatory = $true)]
        $WorkingDirectory,

        # Specifies the name of the source file or folder being branched. The olditem may also contain version information in the format item;version.
        [String]
        [Parameter(Mandatory = $true)]
        $OldItem,

        # Specifies the name of the destination file or folder or the parent folder for the destination. If newitem already exists and is a Team Foundation version control server folder, Team Foundation creates the branched items within it. Otherwise, newitem specifies the name of the destination file or folder. Conflicts can occur during check-in if the destination already exists.
        [String]
        [Parameter(Mandatory = $true)]
        $NewItem,

        # Provides a value for the /version option. For more information about how Team Foundation parses a version specification to determine which items are within its scope, see https://msdn.microsoft.com/library/56f7w6be.
        [String]
        [Parameter(Mandatory = $false)]
        $VersionSpec,

        # Provides a comment about the branch.
        [String]
        [Parameter(Mandatory = $false)]
        $Comment,

        # The user-provided value for the /author option.
        [String]
        [Parameter(Mandatory = $false)]
        $AuthorName,

        # If this option is specified, local copies of the files and folders in the new branch are not created in the local workspace. However, local copies will be retrieved into the workspace the next time that you perform a recursive Get operation.
        [Parameter(Mandatory = $false)]
        [switch]
        $NoGet,

        # Suppresses any prompts for input from you.
        [Parameter(Mandatory = $false)]
        [switch]
        $NoPrompt,

        # Implies /noget and specifies that output is not written to the Command Prompt window when you create a branch.
        [Parameter(Mandatory = $false)]
        [switch]
        $Silent,

        # Creates and checks in the branch to the server in one operation. This option does not create any pending changes in the local workspace.
        [Parameter(Mandatory = $false)]
        [switch]
        $Checkin,

        # For folders branch all files inside, too
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
            'branch'
            '{0}' -f $OldItem
            '{0}' -f $NewItem
        )
        If ($VersionSpec)
        {
            $arguments += '/version:{0}' -f $VersionSpec
        }
        If ($Comment)
        {
            $arguments += '/comment:"{0}"' -f $Comment
        }
        If ($AuthorName)
        {
            $arguments += '/author:{0}' -f $AuthorName
        }
        If ($Credential)
        {
            $arguments += '/login:{0},{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().UserName
        }
        If ($NoGet)
        {
            $arguments += '/noget'
        }
        If ($NoPrompt)
        {
            $arguments += '/noprompt'
        }
        If ($Silent)
        {
            $arguments += '/silent'
        }
        If ($Checkin)
        {
            $arguments += '/checkin'
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

