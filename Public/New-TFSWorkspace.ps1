<#
        .Synopsis
        New TFS Workspace 
#>

Function New-TFSWorkspace
{
    [CmdletBinding()]
    param
    (
        # Root directory for the workspace you are working in.
        [String]
        [Parameter(Mandatory = $true)]
        $WorkingDirectory,

        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true)]
        $WorkspaceName,

        [String]
        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true)]
        $ComputerName,

        [String]
        [Parameter(Mandatory = $false)]
        $Template,

        [String]
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private', 'PublicLimited', 'Public')]
        $Permission,

        [String]
        [Parameter(Mandatory = $true)]
        [ValidateSet('Local', 'Server')]
        $Location,

        # https://tfs/ProjectCollection
        [String]
        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true)]
        $TFSUri,

        # Will supress prompts
        [Parameter(Mandatory = $false)]
        [switch]
        $NoPrompt,

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
            'workspace'
            '/New'
            '/Collection:{0}/{1}' -f $TFSUri, $ProjectCollectionName
            '/Location:{0}' -f $Location
            '{0}' -f $WorkspaceName 
            '/Permission:{0}' -f $Permission
        )
        If ($ComputerName)
        {
            $arguments += '/Computer:{0}' -f $ComputerName
        }
        If ($Template)
        {
            $arguments += '/Template:{0}' -f $Template
        }
        If ($NoPrompt)
        {
            $arguments += '/NoPrompt'
        }
        If ($Credential)
        {
            $arguments += '/Login:{0},{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().Password
        }

        . $Tfexe $arguments
    }
    End
    {
    
    }
}

