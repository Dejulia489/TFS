<#
    .Synopsis
    Remove TFS Workspace 
#>
Function Remove-Workspace
{
    [CmdletBinding(SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    param
    (
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true)]
        $WorkspaceName,

        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true)]
        [String]
        $Collection,

        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true)]
        [String]
        [Alias('Name')]
        $Owner,

        [pscredential]
        [Parameter(Mandatory = $false)]
        $Credential
    )
    Begin
    {
        $Tfexe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\TF.exe'
    }
    Process
    {
        $arguments = @(
            'workspace'
            '/Collection:{0}' -f $Collection
            '{0}' -f $WorkspaceName 
        )
        If ($Owner)
        {
            $arguments[2] = '{0};{1}' -f $arguments[2], $Owner
        }
        If ($Credential)
        {
            $arguments += '/Login:{0},{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().Password
        }
        If ($PSCmdlet.ShouldContinue("This will remove the workspace: [$WorkspaceName] from Collection: [$Collection], are you sure?", 'Remove'))
        {
            $arguments += '/delete'
        }
        
        . $Tfexe $arguments
    }
    End
    {
    
    }
}

