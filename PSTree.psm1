function Get-TreeInternal
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)][Alias("FullName")][string[]]$Path,
        [switch]$Size,
        $Depth=0,
        $DepthPrefix = ''
    )

    Process
    {
        if ($Path -eq $null)
        {
            $Path = "."
        }

        $Output = @()
                
        if ($Depth -eq 0)
        {
            $Output += $Path
        }

        $Items = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue

        $FileCount=0
        foreach ($Item in $Items)
        {
            $FileCount++

            $ItemTreeBranch = '├── '
            $NewDepthPrefix = '│   '
            
            $ItemTreeName = $DepthPrefix

            if ($FileCount -eq $Items.Count)
            {
                $ItemTreeBranch = '└── '
                $NewDepthPrefix = '    '
            }

            $ItemTreeName += $ItemTreeBranch

            if ($Size -and !$Item.PSIsContainer)
            {
                $ItemTreeName += ("[{0}] " -f (Convert-BytesToHumanSize -Bytes $Item.Length))
            }

            $ItemTreeName += $Item.Name

            $Output += $ItemTreeName
            if ($Item.PSIsContainer)
            {
                $Output += $Item | Get-TreeInternal -Size:$Size -Depth ($Depth+1) -DepthPrefix ($DepthPrefix + $NewDepthPrefix)
            }
        }

        return $Output
    }
}

function Get-Tree
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)][Alias("FullName")][string[]]$Path,
        [switch]$Size
    )

    return $Path | Get-TreeInternal -Size:$Size
}

function Convert-BytesToHumanSize($Bytes)
{
    switch ([math]::truncate([math]::log($Bytes,1024)))
    {
        1 {return "{0:n2} KB" -f ($Bytes / 1kb)}
        2 {return "{0:n2} MB" -f ($Bytes / 1mb)}
        3 {return "{0:n2} GB" -f ($Bytes / 1gb)}
        4 {return "{0:n2} TB" -f ($Bytes / 1tb)}
        5 {return "{0:n2} TB" -f ($Bytes / 1pb)}
        Default {return "$Bytes B"}
    }
}

Export-ModuleMember -Function "Get-Tree"
