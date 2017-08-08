function Get-Tree
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)][Alias("FullName")][string[]]$Path,
        $Depth=0,
        $DepthPrefix = ''
    )

    Begin
    {
        if ($Path -eq $null)
        {
            $Path = "."
        }
    }

    Process
    {
        foreach ($CurrentPath in $Path)
        {
            $Output = @()
                
            if ($Depth -eq 0)
            {
                $Output += $CurrentPath
            }

            $Items = Get-ChildItem -Path $CurrentPath -ErrorAction SilentlyContinue

            $FileCount=0
            foreach ($Item in $Items)
            {
                $FileCount++

                if ($FileCount -eq $Items.Count)
                {
                    $ItemChar = '└'
                    $NewDepthPrefix = '    '
                }
                else
                {
                    $ItemChar = '├'
                    $NewDepthPrefix =  '│   '
                }

                $Output += ("{0}{1}── {2}" -f $DepthPrefix, $ItemChar, $Item.Name)

                if ($Item.PSIsContainer)
                {
                    $Output += Get-Tree -Path $Item.FullName -Depth ($Depth+1) -DepthPrefix ($DepthPrefix + $NewDepthPrefix)
                }
            }

            return $Output
        }
    }
}

Export-ModuleMember -Function "Get-Tree"
