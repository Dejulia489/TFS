<#
        .Synopsis
        The Invoke-TFSCheckIn command checks in your pending changes to files or folders to the server.
#>

Function Invoke-TFSCheckIn
{
    [CmdletBinding()]
    param
    (
        # Root directory for the workspace you are branching in.
        [String]
        [Parameter(Mandatory = $true)]
        $WorkingDirectory,

        # Specifies the scope of the items to check in from the user's workspace. You can specify more than one Itemspec argument
        [String]
        [Parameter()]
        $ItemSpec,

        # The user-provided value for the /author option.
        [String]
        [Parameter()]
        $AuthorName,

        # Provides a comment about the check in.
        [String]
        [Parameter()]
        $Comment,

        # Suppresses any prompts for input from you.
        [Parameter()]
        [switch]
        $NoPrompt,

        # Provides one or more check-in notes to associate with the changeset using one of the following arguments:
        [Parameter()]
        [string]
        $Notes,

        # Overrides a check-in policy, provide this parameter a reason for the override
        [Parameter()]
        [string]
        $Override,

        # For folders branch all files inside, too
        [Parameter()]
        [switch]
        $Recursive,

        # Tests whether the check in would succeed without checking in the files. The system evaluates check-in policies, check-in notes, and lists conflicts.
        [Parameter()]
        [switch]
        $Validate,

        # Bypasses a gated check-in requirement. 
        [Parameter()]
        [switch]
        $Bypass,

        # Forces a check-in on items with pending edits even when there are no content changes in the file.
        [Parameter()]
        [switch]
        $Force,

        # By default, the system automatically attempts to AutoResolve All, see https://docs.microsoft.com/en-us/vsts/tfvc/resolve-team-foundation-version-control-conflicts?view=vsts
        [Parameter()]
        [switch]
        $NoAutoResolve,

        # The selected state of each pending change (as shown in the Check In dialog box), the comment, associated work items, check-in notes, and check-in policy override reason, are stored on your dev machine as pending changes until you check them in. The /new option clears this check-in metadata before you check in.
        [Parameter()]
        [switch]
        $New,

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
            'checkin'
            '{0}' -f $ItemSpec
        )
        If ($AuthorName)
        {
            $arguments += '/author:{0}' -f $AuthorName
        }
        If ($Comment)
        {
            $arguments += '/comment:"{0}"' -f $Comment
        }
        If ($NoPrompt)
        {
            $arguments += '/noprompt'
        }
        If ($Notes)
        {
            $arguments += '/notes:{0}' -f $Notes
        }
        If ($Override)
        {
            $arguments += '/override:{0}' -f $Override
        }
        If ($Recursive)
        {
            $arguments += '/recursive'
        }
        If ($Validate)
        {
            $arguments += '/validate'
        }
        If ($Bypass)
        {
            $arguments += '/bypass'
        }
        If ($Force)
        {
            $arguments += '/force'
        }
        If ($NoAutoResolve)
        {
            $arguments += '/noautoresolve'
        }
        If ($New)
        {
            $arguments += '/new'
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

