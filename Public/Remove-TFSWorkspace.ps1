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
        ValueFromPipelineByPropertyName = $true)]
        $WorkspaceName,

        [String]
        [Parameter(Mandatory = $true, 
        ValueFromPipelineByPropertyName = $true)]
        $TFSUri,

        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true)]
        $ProjectCollectionName,

        [Parameter(Mandatory = $false, 
        ValueFromPipelineByPropertyName = $true)]
        [String]
        [Alias('Name')]
        $Owner
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
        If ($Owner)
        {
            $arguments[3] = "{0};ld\{1}" -f $arguments[3], $Owner
        }
        If ($PSCmdlet.ShouldProcess("This will remove the workspace: [$WorkspaceName] from Collection: [$TFSUri], are you sure?", 'Remove'))
        {
            Write-Verbose -Message "Removing Workspace: [$WorkspaceName]" -Verbose
            . $Tfexe $arguments
        }
    }
    End
    {
    
    }
}

