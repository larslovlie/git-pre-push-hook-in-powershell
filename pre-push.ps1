Write-Host "Pre-push hook: Running tests"

# Using mstest
# ---------------------
$env:Path += "; C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE"

$path_base = "C:\path\to\your\project"

$test_containers = @()
$test_containers += $path_base + "\path\to\myproject.UnitTests\bin\Debug\MyProject.UnitTests.dll"
$test_containers += $path_base + "\path\to\anotherproject.UnitTests\bin\Debug\AnotherProject.UnitTests.dll"

$results = New-Object System.Collections.Generic.List[System.String]
foreach($test_container in $test_containers){
    Write-Host "Pre-push hook: " $test_container

    $exe = "mstest.exe"
    $arg = "/testcontainer:" + $test_container
    $result = &$exe $arg
    
    # Take only lines preceded by "Failed"
    $failedLines = $result |
     select-string -pattern "Failed" -Context 0,0 |
     Select-String -pattern "Passed|Inconclusive|Test Run|[0-9]" -NotMatch
    
    foreach($failedLine in $failedLines){
        if($failedLine -eq $null){
            continue
        }
        
        $tmp = $failedLine.ToString().Split(".")
        $failedTest = [string]::Join(".", $tmp[-2..-1])
        
        if([bool]$failedTest){
            $results.Add( $failedTest )
        }
    }
}

if($results.Count -gt 0){
    Write-Host ""
    Write-Host "Pre-push hook: Push failed because of " $results.Count " errors:"
    foreach($failedTest in $results){
        Write-Host "- " $failedTest
    }
    
    exit 1
}