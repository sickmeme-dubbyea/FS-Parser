# Define the path for the generated text file
$FilePath = "./demodata.txt"

# Initialize an array to store the lines
$lines = @()

# Generate 100 entries, each with 5 lines
for ($i = 1; $i -le 100; $i++) {
    $lines += "Form$i"
    $lines += "Student_name$i"
    $lines += "Student_ID$i"
    $lines += "Course$i"
    $lines += "Reason$i"
    $lines += ""
}

# Write the lines to the file
$lines | Out-File -FilePath $FilePath

Write-Output "Sample data written to $FilePath"