<#
        .Synopsis
        The Add-TFSItem command adds files and folders to version control.
#>

Function Add-TFSItem
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
        [Parameter(Mandatory = $true)]
        $ItemSpec,

        # Suppresses the display of windows and dialog boxes and redirects output data to the command prompt. 
        [Parameter()]
        [switch]
        $NoPrompt,

        # Recursively adds items in the specified directory and any subdirectories.
        [Parameter()]
        [switch]
        $Recursive,

        # By default certain types of files (for example, .dll files) are ignored by version control. The rules in a .tfignore files apply to the Add command when you specify a wildcard in your itemspec. To override the application of the rules in this case, specify /noignore.
        [Parameter()]
        [switch]
        $NoIgnore,

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
            'add'
            '{0}' -f $ItemSpec
        )
        If ($NoPrompt)
        {
            $arguments += '/noprompt'
        }

        If ($Recursive)
        {
            $arguments += '/recursive'
        }
        If ($NoIgnore)
        {
            $arguments += '/noignore'
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

