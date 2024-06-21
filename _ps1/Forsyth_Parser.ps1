<#
    A simple parser to convert text files into a CSV for my wife

    Charles Witherspoon | Husband
#>

param (
    [string]$FilePath = "demodata.txt",
    [int]$Step = 5
)

function Convert-TextToCSV {
    param (
        [string]$FilePath,
        [int]$Step
    )

    # Construct the full path for the input file
    $FullFilePath = Join-Path -Path (Get-Location) -ChildPath $FilePath

    # Check if the file exists
    if (-Not (Test-Path $FullFilePath)) {
        Write-Output "File not found: $FullFilePath"
        $FullFilePath = Read-Host -Prompt "Enter the full path to the source file > "
        
    }

    try {
        # Grab our data file 
        $DataSet = Get-Content $FullFilePath | Where-Object { $_ -ne "" }

        # Container to store our data 
        $RESULTS = @()

        # Check if the total number of lines is a multiple of $Step
        if ($DataSet.Length % $Step -ne 0) {
            Write-Output "Data file is corrupted or incomplete. Number of lines is not a multiple of $Step."
            return
        }

        for ($i = 0; $i -lt $DataSet.Length; $i += $Step) {
            # Verify that we're not at the end of our file
            if ($i + $Step - 1 -lt $DataSet.Length) {
                # Data checks, is the line we're on what we think it is 
                $currObj = [ordered]@{
                    Form         = $DataSet[$i]
                    Student_name = $DataSet[$i + 1]
                    Student_ID   = $DataSet[$i + 2]
                    Course       = $DataSet[$i + 3]
                    Reason       = $DataSet[$i + 4]
                }
                $RESULTS += $currObj
            }
        }

        # Convert results to JSON
        $jsonOutput = $RESULTS | ConvertTo-Json | ConvertFrom-Json

        # Get the current date and time in a specific format
        $dateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

        # Construct the new file name
        $FileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
        #$FileExtension = [System.IO.Path]::GetExtension($FilePath)
        #$NewFileName = "$FileName`_$dateTime$FileExtension"
        $NewFileName = "$FileName`_$dateTime.csv"
        $OutputDir = Join-Path -Path (Get-Location) -ChildPath "_output"
        $NewFilePath = Join-Path -Path $OutputDir -ChildPath $NewFileName

        # Output the JSON to the new file
        $jsonOutput | Export-Csv -Path $NewFilePath

        Write-Output "Output written to $NewFilePath"
    }
    catch {
        Write-Output "An error occurred: $_"
    }
}

# Update the FilePath to be relative to the _input directory
$FilePath = Join-Path -Path "_input" -ChildPath $FilePath

# Call the function with the provided parameters
Convert-TextToCSV -FilePath $FilePath -Step $Step