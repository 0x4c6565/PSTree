function Get-Tree($Directory, $Depth = 0)
{
    $Output = @()

    if ($Directory -ne $null)
    {
        $Items = Get-ChildItem -Path $Directory -ErrorAction SilentlyContinue
    }
    else
    {
        $Items = Get-ChildItem -ErrorAction SilentlyContinue
    }



    $FileCount=0
    foreach ($Item in $Items)
    {
        $FileCount++
        
        if ($FileCount -eq $Items.Count)
        {
            $ItemChar = '└'
        }
        else
        {
            $ItemChar = '├'
        }
        
        $Output += Get-TreeOutput -Item $Item -Depth $Depth -ItemChar $ItemChar

        if ($Item.PSIsContainer)
        {
            $Output += Get-Tree -Directory $Item.FullName -Depth ($Depth + 1)
        }
    }

    return $Output
}

function Get-TreeOutput($Item, [int]$Depth, $ItemChar = '├')
{
    return ("{0}   {1}── {2}" -f ("   │" * $Depth), $ItemChar, $Item.Name)
}
