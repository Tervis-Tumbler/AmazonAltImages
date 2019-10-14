$PathToCSV = "\\tervis.prv\creative\Graphics Drive\DESIGNS\Image Req\Amazon Image Requests\Amazon Alternate Images\Product Catalog_US 10.7.19active.csv"
$CSVRecords = Import-Csv -Path $PathToCSV

$AlternateImagesToUseToFileNameMap = @{
    "16 oz, Lid, Box, 2 Pack, Decoration" = @{
        PT08 = "16oz-2-pak-lid.jpg"
    }
    "16 oz, Lid, No Box, Single, Decoration" = @{
    }
    "16 oz, Lid, No Box, Single, No Decoration" = @{
    }
    "16 oz, No Lid, Box, 2 Pack, Decoration" = @{
        PT08 = "16oz-2-pak-nolid.jpg"
    }
    "16 oz, No Lid, Box, 2 Pack, No Decoration" = @{
        PT08 = "16oz-2-pak-nolid.jpg"
    }
    "16 oz, No Lid, Box, 4 Pack, Decoration" = @{
        PT08 = "16oz-4-pak-nolid.jpg"
    }
    "16 oz, No Lid, Box, 4 Pack, No Decoration" = @{
        PT08 = "16oz-4-pak-nolid.jpg"
    }
    "16 oz, No Lid, No Box, Single, Decoration" = @{

    }
    "16 oz, No Lid, No Box, Single, No Decoration" = @{

    }
}

$SizeAndSubCategory = @(
    @{
        "Item: Product Size" = 16
        "Item: Product Sub Category" = "DWT"
        FileName = [ordered]@{
            PT07 = [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                FileName ="16oz-alt-lid.jpg"
            }
            PT08 = [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                "Package Type" = "04"
                FileName ="16oz-4-pak-lid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "NA"
                "Package Type" = "04"
                FileName ="16oz-4-pak-nolid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                "Package Type" = "02"
                FileName ="16oz-2-pak-lid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "NA"
                "Package Type" = "02"
                FileName ="16oz-2-pak-nolid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                "Package Type" = "BX"
                FileName ="16oz-1-pak-lid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "NA"
                "Package Type" = "BX"
                FileName ="16oz-1-pak-nolid.jpg"
            }
        }
    },
    @{
        "Item: Product Size" = 16
        "Item: Product Sub Category" = "DWT"
        FileName = [ordered]@{
            PT07 = [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                FileName ="16oz-alt-lid.jpg"
            }
            PT08 = [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                "Package Type" = "04"
                FileName ="16oz-4-pak-lid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "NA"
                "Package Type" = "04"
                FileName ="16oz-4-pak-nolid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                "Package Type" = "02"
                FileName ="16oz-2-pak-lid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "NA"
                "Package Type" = "02"
                FileName ="16oz-2-pak-nolid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "TRAVEL LID"
                "Package Type" = "BX"
                FileName ="16oz-1-pak-lid.jpg"
            },
            [ordered]@{
                "Item: Lid Type" = "NA"
                "Package Type" = "BX"
                FileName ="16oz-1-pak-nolid.jpg"
            }
        }
    }
)


$ResourcesPath = "/Users/rpaul/Desktop/01_DEVELOP/14113-081619-Amazon-16ozAltImages/resources"
$DestinationImageRootPath = "/Users/rpaul/Desktop/01_DEVELOP/14113-081619-Amazon-16ozAltImages"

# Where-Object "Alternate Images to Use" -eq "16 oz, Lid, Box, 2 Pack, Decoration" |
# Select-Object -First 1 |

$CSVRecords |
ForEach-Object -Process {
    $CSVRecord = $_

    $FileNames = $SizeAndSubCategory | 
    Where-Object -Property "Item: Product Size" -EQ $CSVRecord."Item: Product Size" |
    Where-Object -Property "Item: Product Sub Category" -EQ $CSVRecord."Item: Product Sub Category" |
    Select-Object -ExpandProperty FileName

    $AmazonAltImageCodes = $FileNames.Keys + @("PT08")
    $AmazonAltImageCodes |
    ForEach-Object -Process {
        $AmazonAltImageCode = $_

        if ($AmazonAltImageCode -eq "PT08" -and -not $AlternateImagesToUseToFileNameMap[$CSVRecord.'Alternate Images to Use'].PT08) {
            
        } else {
            $FileName = if ($AmazonAltImageCode -ne "PT08") {
                $FileNames[$AmazonAltImageCode]
            } else {
                $AlternateImagesToUseToFileNameMap[$CSVRecord.'Alternate Images to Use'].PT08
            }
            $SourcePath = "$ResourcesPath/$AmazonAltImageCode/$FileName"
            $DestinationDirectoryPath = "$DestinationImageRootPath/$($CSVRecord.'Alternate Images to Use')/$AmazonAltImageCode"
            $Destination = "$DestinationDirectoryPath/$($CSVRecord.'Item: UPC Number').$AmazonAltImageCode.jpg" 
            $WhatIf = $false
    
            if (-not (Test-Path -LiteralPath $Destination)) {
                New-Item -Force -Path $DestinationDirectoryPath -ItemType Directory -WhatIf:$WhatIf | Out-Null
                Copy-Item -LiteralPath $SourcePath -Destination $Destination -WhatIf:$WhatIf
            }
        }


    }

}