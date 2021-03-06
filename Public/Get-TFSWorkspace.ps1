﻿<#
        .Synopsis
        Gets TFS Workspace data 

        .OUTPUTS
        PSCustomObject
#>
Function Get-TFSWorkspace
{
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true)]
        $ComputerName = '*',

        [String]
        [Parameter(Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true)]
        $WorkspaceName,

        [String]
        $owner = '*',

        [String]
        [ValidateSet('Detailed', 'Brief')]
        $Format = 'Brief',
        
        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true)]
        $ProjectCollectionName,

        [String]
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true)]
        $TFSUri
    )
    Begin
    {
        $Tfexe = Get-TFSTfexe
    }
    Process
    {
        $arguments = @(
            'workspaces'
            '/Computer:{0}' -f $ComputerName
            '/owner:{0}' -f $owner
            '/Collection:{0}/{1}' -f $TFSUri, $ProjectCollectionName
            '{0}' -f $WorkspaceName
            '/Format:{0}' -f $Format
        )
        #Execute Command
        $Results = . $Tfexe $arguments 
        If ($Results.count -gt 1)
        {
            If ($Format -eq 'Brief')
            {
                #Extract Length of Columns
                $Char = $Results[2].Split(' ')
                $WorkSpaceLength = $Char[0].Length
                $NameLength = $Char[1].Length
                $ComputerNameLength = $Char[2].Length
                $filteredResults = $Results[3..$Results.Count] 
                Foreach ($result in $filteredResults)
                {
                    [PSCustomObject]@{
                        WorkSpaceName         = ($result.Substring(0, $WorkSpaceLength)).trim()
                        Owner                 = ($result.Substring($WorkSpaceLength + 1, $NameLength)).trim()
                        ComputerName          = ($result.Substring(($WorkSpaceLength + 1 + $NameLength + 1), $ComputerNameLength)).trim()
                        TFSUri                = $TFSUri
                        ProjectCollectionName = $ProjectCollectionName
                    }
                }
            }
            ElseIf ($Format -eq 'Detailed')
            {
                $Results += '='
                Foreach ($result in $Results)
                {
                    If ($result -eq '')
                    {
                        Continue
                    }
                    If ($result.StartsWith('='))
                    {
                        #Output Object
                        If ($Object)
                        {
                            $Object
                        }
                        [pscustomobject]$Object = @{}

                        [pscustomobject]$workingFolderObject = @{}
                    }
                    else
                    {
                        If ($result.StartsWith('Working'))
                        {
                            Continue
                        }
                        If ($result.StartsWith(' $'))
                        {
                            $workingFolderObject += @{
                                ($result.Split(':', 2)[0]).trim() = ($result.Split(':', 2)[1]).trim()
                            }
                        }
                        Else
                        {
                            $Object += @{
                                ($result.Split(':')[0]).trim() = ($result.Split(':')[1]).trim() 
                            }
                        }
                        If ($workingFolderObject)
                        {
                            $Object.WorkingFolder = $workingFolderObject
                        }
                    }                   
                }
            }
        }
        Else
        {
            $Results
        }
    }
    End
    {
    
    }
}
