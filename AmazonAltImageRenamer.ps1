function Invoke-AmazonAltImageCopyAndRename {
    [CmdletBinding()]
    param (
        $PathToCSV = "\\tervis.prv\creative\Graphics Drive\DESIGNS\Image Req\Amazon Image Requests\Amazon Alternate Images\Product Catalog_US 10.7.19active.csv",
        $ResourcesPath = "\\tervis.prv\creative\Graphics Drive\DESIGNS\Image Req\Amazon Image Requests\Amazon Alternate Images",
        $DestinationImageRootPath = "C:\Users\hourg\Desktop\AmazonAltImages"
    )
    $CSVRecords = Import-Csv -Path $PathToCSV
    $CSVRecords |
    Add-Member -MemberType ScriptProperty -Name PTO8ImageFileName -Value {
        "$($This.'Item: Product Size')$($This.'Item: Product Sub Category')-$($This.'Item: Cup Count'.PadLeft(2,'0'))-$($This.'Item: Lid Type').jpg"
    } -Force
    
    $CSVRecords |
    ForEach-Object -Process {
        $CSVRecord = $_
        $ProductSize = $CSVRecord."Item: Product Size"
        $ProductFormType = $CSVRecord."Item: Product Sub Category"
        $AmazonAltImageByProductSizeAndProductFormTypeRootDirectory = "$ResourcesPath\$ProductSize$ProductFormType"

        $AmazonAltImageCodesWithOnlyOneImageFile = 5..12 | Where-Object {$_ -ne 8} | ForEach-Object { "PTO$($_)"}
        $AmazonAltImageCodesWithOnlyOneImageFile |
        ForEach-Object -Process {
            $AmazonAltImageCode = $_
            $AmazonAltImageSourceFile = Get-ChildItem -ErrorAction SilentlyContinue -Path "$AmazonAltImageByProductSizeAndProductFormTypeRootDirectory\$AmazonAltImageCode"
            Copy-AmazonAltImageFile -DestinationImageRootPath $DestinationImageRootPath -AmazonAltImageCode $AmazonAltImageCode -CSVRecord $CSVRecord -AmazonAltImageSourceFile $AmazonAltImageSourceFile

        }

        $AmazonAltImageCodesWithMultipleImageFile = @("PTO8")
        $AmazonAltImageCodesWithMultipleImageFile |
        ForEach-Object -Process {
            $AmazonAltImageCode = $_

            $AmazonAltImageSourceFile = Get-Item -ErrorAction SilentlyContinue -Path "$AmazonAltImageByProductSizeAndProductFormTypeRootDirectory\$AmazonAltImageCode\$($CSVRecord.`"$($AmazonAltImageCode)ImageFileName`")"
            Copy-AmazonAltImageFile -DestinationImageRootPath $DestinationImageRootPath -AmazonAltImageCode $AmazonAltImageCode -CSVRecord $CSVRecord -AmazonAltImageSourceFile $AmazonAltImageSourceFile
        }
    }
}

function Copy-AmazonAltImageFile {
    param(
        $DestinationImageRootPath,
        $AmazonAltImageCode,
        $CSVRecord,
        $AmazonAltImageSourceFile
    )
    if ($AmazonAltImageSourceFile) {
        $DestinationDirectoryPath = "$DestinationImageRootPath/$AmazonAltImageCode"
        $Destination = "$DestinationDirectoryPath/$($CSVRecord.UPC).$AmazonAltImageCode.jpg"

        if (-not (Test-Path -LiteralPath $Destination)) {
            New-Item -Force -Path $DestinationDirectoryPath -ItemType Directory -WhatIf:$WhatIf | Out-Null
            $AmazonAltImageSourceFile | Copy-Item -Destination $Destination -WhatIf:$WhatIf
        }
    }
}