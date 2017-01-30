
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
            
        if ($Items.Count -gt 0 -and $FileCount -eq $Items.Count)
        {
            $ItemChar = '└'
        }
        else
        {
            $ItemChar = '├'
        }

        if ($Item.PSIsContainer)
        {
            $Output += Get-TreeOutput -Item $Item -Depth $Depth -ItemChar $ItemChar
            $Output += Get-Tree -Directory $Item.FullName -Depth ($Depth + 1)
        }
        else
        {
            $Output += Get-TreeOutput -Item $Item -Depth $Depth -ItemChar $ItemChar
        }
    }

    return $Output
}

function Get-TreeOutput($Item, [int]$Depth, $ItemChar = '├')
{
    return ("{0}   {1}── {2}" -f ("   │" * $Depth), $ItemChar, $Item.Name)
}
