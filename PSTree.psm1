function Get-TreeInternal
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)][Alias("FullName")][string[]]$Path,
        [switch]$Size,
        [switch]$Directory,
        [int]$MaxDepth=0,
        $Depth=0,
        $DepthPrefix = ''
    )

    Process
    {
        if ($MaxDepth -gt 0 -and ($Depth+1) -gt $MaxDepth)
        {
            return
        }

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
        $TotalCountCount = $Items.Count
        if ($Directory)
        {
            $TotalCountCount = ($Items | Where-Object -FilterScript {$_.PSIsContainer}).Count
        }
        
        foreach ($Item in $Items)
        {
            if ($Directory -and !$Item.PSIsContainer)
            {
                continue
            }

            $FileCount++

            $ItemTreeBranch = '├── '
            $NewDepthPrefix = '│   '
            
            $ItemTreeName = $DepthPrefix

            if ($FileCount -eq $TotalCountCount)
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
                $Output += $Item | Get-TreeInternal -Size:$Size -Directory:$Directory -MaxDepth $MaxDepth -Depth ($Depth+1) -DepthPrefix ($DepthPrefix + $NewDepthPrefix)
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
        [switch]$Size,
        [switch]$Directory,
        [int]$MaxDepth=0
    )

    return $Path | Get-TreeInternal -Size:$Size -Directory:$Directory -MaxDepth $MaxDepth
}

function Convert-BytesToHumanSize($Bytes)
{
    switch ([math]::truncate([math]::log($Bytes,1024)))
    {
        1 {return "{0:n2} KB" -f ($Bytes / 1kb)}
        2 {return "{0:n2} MB" -f ($Bytes / 1mb)}
        3 {return "{0:n2} GB" -f ($Bytes / 1gb)}
        4 {return "{0:n2} TB" -f ($Bytes / 1tb)}
        5 {return "{0:n2} PB" -f ($Bytes / 1pb)}
        default {return "$Bytes B"}
    }
}

Export-ModuleMember -Function "Get-Tree"
