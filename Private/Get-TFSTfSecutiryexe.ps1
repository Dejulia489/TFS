<#
        .Synopsis
        Gets TFSTfSecurity.exe path

        .OUTPUTS
        String
#>
Function Get-TFSTfSecurityexe
{
    [CmdletBinding()]
    param()
    Begin
    {
        $paths = @(
            'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\TFSSecurity.exe',
            'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\TFSSecurity.exe'
            'C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\TFSSecurity.exe'
        )
    }
    Process
    {   
        Foreach($path in $paths)
        {
            If(Resolve-Path -Path $path -ErrorAction SilentlyContinue)
            {
                $Tfexe = $path
                break
            }
            
        }
        If(-not($Tfexe))
        {
            Write-Error "Cannot find TF.exe installation" -ErrorAction Stop
        }
    }
    End
    {
        Write-Output $Tfexe
    }
}
