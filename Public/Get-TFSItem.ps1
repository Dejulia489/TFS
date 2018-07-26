<#
        .Synopsis
        Gets (downloads) either the latest version or a specified version of one or more files or folders from Team Foundation Server to the workspace.
#>

Function Get-TFSItem
{
    [CmdletBinding()]
    param
    (
        # Root directory for the workspace you are working in.
        [String]
        [Parameter(Mandatory = $true)]
        $WorkingDirectory,

        # Specifies the scope of the items to add. You can specify more than one itemspec argument.
        [String]
        [Parameter(Mandatory = $false)]
        $ItemSpec,

        # Provides a value for the /version option. For more information about how Team Foundation parses a version specification to determine which items are within its scope, see https://msdn.microsoft.com/library/56f7w6be.
        [String]
        [Parameter()]
        $VersionSpec,

        # Your Team Foundation Server maintains an internal record of all the items the workspace contains, including the version of each. By default, when you get files, if the internal record on the server indicates the workspace already has the version you are getting, then it does not retrieve the item. This option gets the items regardless of the data contained in this internal record.
        [Parameter()]
        [switch]
        $All,

        # By default, the system does not retrieve an item if it is writable (that is, if its read-only attribute is cleared) on the client machine. This option overrides the default behavior and overwrites a writable item, unless the item is checked out.
        [Parameter()]
        [switch]
        $Overwrite,

        # Combines /all and /overwrite.
        [Parameter()]
        [switch]
        $Force,

        # See http://go.microsoft.com/fwlink/?LinkId=253390
        [Parameter()]
        [switch]
        $ReMap,

        # Recursively gets items in the specified directory and any subdirectories. If you do not specify an itemspec, then this option is implied.
        [Parameter()]
        [switch]
        $Recursive,

        # Displays what would occur, without actually performing the Get operation.
        [Parameter()]
        [switch]
        $Preview,

        # By default, the system automatically attempts to AutoResolve All 
        [Parameter()]
        [switch]
        $NoAutoResolve,

        # By default certain types of files (for example, .dll files) are ignored by version control. The rules in a .tfignore files apply to the Add command when you specify a wildcard in your itemspec. To override the application of the rules in this case, specify /noignore.
        [Parameter()]
        [switch]
        $NoPrompt,

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
            'get'
            '{0}' -f $ItemSpec
        )
        If ($VersionSpec)
        {
            $arguments += '/version:{0}' -f $VersionSpec
        }
        If ($All)
        {
            $arguments += '/all'
        }
        If ($Overwrite)
        {
            $arguments += '/overwrite'
        }
        If ($Force)
        {
            $arguments += '/force'
        }
        If ($ReMap)
        {
            $arguments += '/remap'
        }
        If ($Recursive)
        {
            $arguments += '/recursive'
        }
        If ($Preview)
        {
            $arguments += '/preview'
        }
        If ($NoAutoResolve)
        {
            $arguments += '/noautoresolve'
        }
        If ($NoPrompt)
        {
            $arguments += '/noprompt'
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

