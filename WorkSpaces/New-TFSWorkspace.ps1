<#
        .Synopsis
        Remove TFS Workspace 
#>

Function New-TFSWorkspace
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

        # https://tfs/ProjectCollection
        [String]
        [Parameter(Mandatory = $false, 
        ValueFromPipelineByPropertyName = $true)]
        $TFSUri,

        [pscredential]
        [Parameter(Mandatory = $false)]
        $Credential
    )
    Begin
    {
        $Tfexe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\TF.exe'
        Try
        {
            $null = Resolve-Path -Path $Tfexe -ErrorAction Stop
        }
        Catch
        {
            Write-Error -Exception $PSitem.Exception.Message
        }
    }
    Process
    {
        $arguments = @(
            'workspace'
            '/New'
            '/NoPrompt'
            '/Collection:{0}' -f $TFSUri
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
    End
    {
    
    }
}

