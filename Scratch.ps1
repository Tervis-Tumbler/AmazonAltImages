$CSVRecords | Select-Object -First 10 -Property "Item: UPC Number"

$CSVRecords | Select-Object -First 1 

$CSVRecords | Group-Object -Property "Alternate Images to Use"