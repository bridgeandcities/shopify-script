
$site = Read-Host "[1] kbdfans`n[2] novelkeys`n[3] dailyclack`nWhich site?`n"
$uri = switch ($site) {
    1 {
        $siteRoot = "https://kbdfans.com/collections/"
        $siteCategory = Read-Host "[1] Switches`n[2] Keycaps`n[3] Diy Kit`n[4] Group Buy`n[5] Case`n[6] Plate`n[7] PCB`n"
        switch ($siteCategory) {
            1 { $siteRoot + "switches" + "/products.json" }
            2 { $siteRoot + "keycaps" + "/products.json" }
            3 { $siteRoot + "diy-kit" + "/products.json" }
            4 { $siteRoot + "group-buy" + "/products.json" }
            5 { $siteRoot + "case" + "/products.json" }
            6 { $siteRoot + "plate" + "/products.json" }
            7 { $siteRoot + "pcb" + "/products.json" }
        }
    }
    2 {
        $siteRoot = "https://novelkeys.xyz/collections/"
        $siteCategory = Read-Host "[1] Switches`n[2] Keycaps`n[3] Diy Kits`n[4] Group Buys`n[5] Miscellaneous`n"
        switch ($siteCategory) {
            1 { $siteRoot + "switches" + "/products.json"  }
            2 { $siteRoot + "keycaps" + "/products.json" }
            3 { $siteRoot + "diy-kits" + "/products.json" }
            4 { $siteRoot + "group-buys" + "/products.json" }
            5 { $siteRoot + "miscellaneous" + "/products.json"}
        }
    }
    3 {
        $siteRoot = "https://dailyclack.com/collections/"
        $siteCategory = Read-Host "[1] Switches`n[2] Keycaps`n[3] PCBs-Kits`n[4] Group Buys`n[5] Stabs, Lubes, Springs`n"
        switch ($siteCategory) {
            1 { $siteRoot + "switches" + "/products.json"  }
            2 { $siteRoot + "keycaps" + "/products.json" }
            3 { $siteRoot + "pcbs-kits" + "/products.json" }
            4 { $siteRoot + "group-buys" + "/products.json" }
            5 { $siteRoot + "stabilisers" + "/products.json" }
        }
    }
}

#$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

$b = Invoke-WebRequest -Uri $uri -UseBasicParsing
$productsAll = $b.Content | ConvertFrom-Json
$productsAll = $productsAll.products

$currentTime = Get-Date
$productsAll.PSObject.ImmediateBaseObject | ForEach-Object {
    $productMaster = $_
    $_.variants | ForEach-Object {
        if ($_.available) {
            $aConverted = Get-Date -Date $productMaster.updated_at
            $timeDifference = (New-TimeSpan -End $currentTime -Start $aConverted)
            $timeDifference = "$($timeDifference.Days)D $($timeDifference.Hours)H:$($timeDifference.Minutes)M:$($timeDifference.Seconds)S ago"
            if ($_.title -eq "Default Title") {
                return $timeDifference.ToString() + " | " + $productMaster.title + " | " + $_.price
            }
            return $timeDifference.ToString() + " | " + "$($productMaster.title) $($_.title)" + " | " + $_.price
        }
    }
} | Sort-Object

#$stopwatch.Stop()
#$stopwatch.Elapsed
<#
$c = Read-Host -Prompt "Press Enter to exit"
if (!$c) {
    stop-process -name powershell_ise -force
    stop-process -name powershell -force
}
#>
