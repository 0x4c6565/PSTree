function Get-Tree($Directory, $DepthChar = '')
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
            $NewDepthChar = '     '
        }
        else
        {
            $ItemChar = '├'
            $NewDepthChar =  '    │'
        }
        
        $Output += Get-TreeOutput -Item $Item.Name -DepthChar $DepthChar -ItemChar $ItemChar

        if ($Item.PSIsContainer)
        {
            $Output += Get-Tree -Directory $Item.FullName -DepthChar ($DepthChar + $NewDepthChar)
        }
    }

    return $Output
}

function Get-TreeOutput($Item, $DepthChar, $ItemChar = '├')
{
    return ("{0}    {1}── {2}" -f $DepthChar, $ItemChar, $Item)
}
