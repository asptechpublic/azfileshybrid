
#Enter parameters for the script
param(
    [Parameter(Mandatory = $True,valueFromPipeline=$true)][String] $SubscriptionId,
    [Parameter(Mandatory = $True,valueFromPipeline=$true)][String] $StorageAccountName,
    [Parameter(Mandatory = $True,valueFromPipeline=$true)][String] $ResourceGroupName
    )

#Create a new directory to download
New-Item -Path 'c:\temp\' -itemtype directory -force

#Install required modules

Install-Module -Name PowerShellGet -Force
Install-module -Name AZ -force

#Set execution policy to run script
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Currentuser

# Download the file containing the module from Github
Invoke-WebRequest -Uri "https://github.com/asptechpublic/azfileshybrid/blob/main/files/azfileshybrid.zip?raw=true" -OutFile 'c:\temp\azfileshybrid.zip'

Expand-Archive -literalpath 'c:\temp\azfileshybrid.zip' -destinationpath 'c:\temp\azfileshybrid\' -Force

# Navigate to where AzFilesHybrid is unzipped and stored and run to copy the files into your path
Set-Location -path 'c:\temp\azfileshybrid\'

Invoke-expression "c:\temp\azfileshybrid\CopyToPSPath.ps1" 

#Import AzFilesHybrid module
Import-Module -Name AzFilesHybrid

#Login with an Azure AD credential that has either storage account owner or contributer Azure role assignment
Connect-AzAccount

#Select the target subscription for the current session
Select-AzSubscription -SubscriptionId $SubscriptionId 

#Join storage account to the domain
Join-AzStorageAccountForAuth -ResourceGroupName $ResourceGroupName  -StorageAccountName $StorageAccountName -DomainAccountType "ComputerAccount"
