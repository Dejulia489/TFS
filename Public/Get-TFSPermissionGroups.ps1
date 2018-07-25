<#
    .Synopsis
    Get TFS Permission Groups

    .OUTPUTS
    PSCustomObject
#>
Function Get-TFSPermissionGroups
{
    [CmdletBinding(DefaultParameterSetName = 'ByProjectCollection')]
    param
    (
        [String]
        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ByProjectCollection')]
        $TeamProjectName,

        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true)]
        $ProjectCollectionName,

        #Application Server, Format: 'http:// ServerName : Port /'
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ByApplicationServer')]
        $Server,

        #TFS URI, Format: https://tfs
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ByProjectCollection')]
        $TFSUri

    )

    $TfSecurityexe = Get-TFSTfSecurityexe
    Try
    {
        $null = Resolve-Path -Path $TfSecurityexe -ErrorAction Stop
    }
    Catch
    {
        Write-Error -Exception $PSitem.Exception.Message
    }
    $arguments = @(
        '/g'
    )
    If ($TeamProjectName)
    {
        $arguments += '{0}' -f $TeamProjectName
    }
    If ($server)
    {
        $arguments += '/Server:{0}' -f $Server
    }
    If ($TFSUri)
    {        
        $arguments += '/Collection:{0}/{1}' -f $TFsUri, $ProjectCollectionName
    }
    #Execute Command
    $Results = . $TfSecurityexe $arguments 
    If ($Results.count -gt 1)
    {
        $Results += 'SID'
        Foreach ($result in $Results.Trim())
        {
            If ($result.StartsWith('SID'))
            {
                If ($Object)
                {
                    $Object
                }
                $Object = @{}
                $Object.SID += $result.Split(':')[-1].Trim()
            }
            If ($result.StartsWith('Identity'))
            {
                $Object.Identity = $result.Split(':')[-1].Trim()
            }
            If ($result.StartsWith('Group'))
            {
                $Object.Group = $result.Split(':')[-1].Trim()
            }
            If ($result.StartsWith('Project'))
            {
                $Object.ProjectScope = $result.Split(':')[-1].Trim()
            }
            If ($result.StartsWith('Display'))
            {
                $Object.DisplayName = $result.Split(':')[-1].Trim()
            }
            If ($result.StartsWith('Description'))
            {
                $Object.Description = $result.Split(':')[-1].Trim()
            }
        }
    }
    Else
    {
        $Results
    }
}
