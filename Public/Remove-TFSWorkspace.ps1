<#
        .Synopsis
        Remove TFS Workspace 
#>
Function Remove-TFSWorkspace
{
    [CmdletBinding(SupportsShouldProcess = $true,
        ConfirmImpact = 'Low')]
    param
    (
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        $WorkspaceName,

        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        $TFSUri,

        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        $ProjectCollectionName,

        [Parameter()]
        [pscredential]
        $Credential
    )
    Begin
    {
        $Tfexe = Get-TFSTfexe
    }
    Process
    {
        $arguments = @(
            'workspace'
            '/delete'
            '/server:{0}/{1}' -f $TFSUri, $ProjectCollectionName
            '{0}' -f $WorkspaceName 
        )
        If ($Credential)
        {
            $arguments += "/login:{0},{1}" -f $Credential.UserName, $Credential.GetNetworkCredential().Password
        }
        If ($PSCmdlet.ShouldProcess("This will remove the workspace: [$WorkspaceName] from Collection: [$TFSUri], are you sure?", 'Remove'))
        {
            Write-Verbose -Message "Removing Workspace: [$WorkspaceName]"
            . $Tfexe $arguments
        }
    }
    End
    {
    
    }
}

