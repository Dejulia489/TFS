<#
    .Synopsis
    Get TFS Permission Name Spaces

    .OUTPUTS
    PSCustomObject
#>
Function Get-TFSPermissionNameSpaces
{
    [CmdletBinding(DefaultParameterSetName='ByProjectCollection')]
    param
    (
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName='ByProjectCollection')]
        $ProjectCollectionName,

        #Application Server, Format: 'http:// ServerName : Port /'
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName='ByApplicationServer')]
        $Server,

        #TFS URI, Format: https://tfs
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName='ByProjectCollection')]
        $TFSUri
    )

    $TfSecurityexe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\TFSSecurity.exe'
    Try
    {
        $null = Resolve-Path -Path $TfSecurityexe -ErrorAction Stop
    }
    Catch
    {
        Write-Error -Exception $PSitem.Exception.Message
    }
    $arguments = @(
        '/a'
    )    
    If($server)
    {
        $arguments += '/Server:{0}' -f $Server
    }
    If($TFSUri)
    {
        $arguments += '/collection:{0}/{1}' -f $TFSUri, $ProjectCollectionName
    }
    #Execute Command
    $Results = . $TfSecurityexe $arguments 
    If ($Results.count -gt 1)
    {
        #Extract Length of Columns
        $ResultsCount = $Results.Count -3
        $filteredResults = $Results[6..$ResultsCount] 
        Foreach ($result in $filteredResults)
        {
            [PSCustomObject]@{
                NameSpace = $result.trim()
            }
        }
    }
    Else
    {
        $Results
    }
}
