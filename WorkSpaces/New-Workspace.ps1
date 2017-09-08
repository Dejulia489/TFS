<#
    .Synopsis
    Remove TFS Workspace 
#>

Function New-Workspace
{
    [CmdletBinding()]
    param
    (
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

        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true)]
        [String]
        $Collection,

        [pscredential]
        [Parameter(Mandatory = $false)]
        $Credential
    )

    $Tfexe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\TF.exe'

    $arguments = @(
        'workspace'
        '/New'
        '/NoPrompt'
        '/Collection:{0}' -f $Collection
        '/Location:{0}' -f $Location
        '{0}' -f $WorkspaceName 
    )
    If ($ComputerName)
    {
        $arguments += '/Computer:{0}' -f $ComputerName
    }
    If ($Template)
    {
        $arguments += '/Template:{0}' -f $Template
    }
    If ($Permission)
    {
        $arguments += '/Permission:{0}' -f $Permission
    }
    If ($Credential)
    {
        $arguments += '/Login:{0},{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().Password
    }

    . $Tfexe $arguments
}

