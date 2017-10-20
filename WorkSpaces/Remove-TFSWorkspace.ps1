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

        # https://tfs/ProjectCollection
        [String]
        [Parameter(Mandatory = $false, 
        ValueFromPipelineByPropertyName = $true)]
        $TFSUri,

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
            '/Collection:{0}' -f $TFSUri
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
        If ($PSCmdlet.ShouldProcess("This will remove the workspace: [$WorkspaceName] from Collection: [$TFSUri], are you sure?", 'Remove'))
        {
            $arguments += '/delete'
        }
        
        Write-Verbose -Message "Removing Workspace: [$WorkspaceName]" -Verbose
        . $Tfexe $arguments
    }
    End
    {
    
    }
}

