<#
        .Synopsis
        The Invoke-TFSShelve command stores a set of pending changes, together with pending check-in notes, a comment, and a list of associated work items on the server that is running Visual Studio Team Foundation Server without actually checking them into the version control server.
#>

Function Invoke-TFSShelve
{
    [CmdletBinding()]
    param
    (
        # Root directory for the workspace you are branching in.
        [String]
        [Parameter(Mandatory = $true)]
        $WorkingDirectory,

        # Specifies a name by which the shelveset can be retrieved from the Team Foundation server.
        [String]
        [Parameter(Mandatory = $true)]
        $ShelveSetName,

        # Identifies the files or folders to shelve. By default, all pending changes in the current workspace are shelved if this parameter is not specified. 
        [String]
        [Parameter()]
        $ItemSpec,

        # Specifies the comment for the shelveset.
        [String]
        [Parameter()]
        $Comment,

        # Removes pending changes from the workspace after the shelve operation is successful.
        [Parameter()]
        [switch]
        $Move,

        # Replaces the existing shelveset with the same name and owner as the one that you specify.
        [Parameter()]
        [switch]
        $Replace,

        # Suppresses any prompts for input from you.
        [Parameter()]
        [switch]
        $NoPrompt,

        # Shelves all items in the specified shelveset folder, its subfolders and all items therein if the itemspec you provide is a folder.
        [Parameter()]
        [switch]
        $Recursive,

        # Tests whether the check in would succeed without checking in the files. The system evaluates check-in policies, check-in notes, and lists conflicts.
        [Parameter()]
        [switch]
        $Validate,

        # Provides a value to the /login option. You can specify a username value as either DOMAIN*UserName* or UserName.
        [pscredential]
        [Parameter()]
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
            'shelve'
            '{0}' -f $ShelveSetName
        )
        If ($ItemSpec)
        {
            $arguments += '{0}' -f $ItemSpec
        }
        If ($Comment)
        {
            $arguments += '/comment:"{0}"' -f $Comment
        }
        If ($Move)
        {
            $arguments += '/move'
        }
        If ($Replace)
        {
            $arguments += '/replace'
        }
        If ($NoPrompt)
        {
            $arguments += '/noprompt'
        }
        If ($Recursive)
        {
            $arguments += '/recursive'
        }
        If ($Validate)
        {
            $arguments += '/validate'
        }
        If ($Credential)
        {
            $arguments += '/login:{0},{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().UserName
        }

        . $Tfexe $arguments
    }
    End
    {
    }
}

