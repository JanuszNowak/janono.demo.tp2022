#
# jnno.ps1
#

#cd "D:\Repos\janono\vurl\src\vurl.AzureResourceGroup\Scripts"

cd "C:\repos\jn260223\mimuw\src\MIMUW.ResourceGroup\Scripts"

Login-AzAccount �SubscriptionName  "MSDN-Apsis"

get-azcontext

$app = "mimuw"
$appLong="mimuw"

$env = "dev";
$regionLocation = "West Europe"
$regionLocationShort = "global"
$resourceGroupName = "$app-$env-$regionLocationShort-rg"

#Remove-AzureRmResourceGroup -Name $resourceGroupName -Force

Remove-AzureRmResourceGroup $resourceGroupName

cd .

$ScriptName = Split-Path $PSCommandPath -Leaf
$PSScriptRoot
$PSCommandPath
$ScriptName

#$PSScriptRoot
Unistall-Module AzureRM

Get-AzLocation | Format-List *

Import-Module AzureRM
.\Deploy-AzureResourceGroup.ps1 -ResourceGroupLocation $regionLocation -ResourceGroupName $resourceGroupName -TemplateFile ..\azuredeploy.json -TemplateParametersFile ..\azuredeploy.parameters.json

$webSites=Get-AzWebApp -ResourceGroupName $resourceGroupName
$webSites|Out-GridView

foreach($site in $webSites)
{
 Stop-AzWebApp -ResourceGroupName $resourceGroupName  -Name $site.Name
}

#$names=$webSites | select -Property Name
$MSDeployPath = "$env:ProgramFiles\IIS\Microsoft Web Deploy V3\msdeploy.exe"

foreach($site in $webSites)
{
 $a=   $site.Name + '/publishingcredentials'
 #$a
  $creds = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/config -ResourceName $a -Action list -ApiVersion 2015-08-01 -Force

    if(!$creds)
    {
        Write-Error "Failed Getting publishing credentials"
    }

    $username = $creds.Properties.PublishingUserName
    $password = $creds.Properties.PublishingPassword
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
    #$username
    #$password
    #$base64AuthInfo

    $dest="-dest:iisApp='$($site.Name)',ComputerName='https://$($site.Name).scm.azurewebsites.net:443/msdeploy.axd?site=$($site.Name)',UserName='$username',Password='$password',AuthType='Basic'"
    #-enableRule:DoNotDeleteRule"

    $source= "-source:IisApp='D:\Repos\janono\vurl\src\vur.azfun\bin\Release\netstandard2.0'"

    &$MSDeployPath @('-verb:sync', $source, $dest)
}



$fqdn="u.xprv.ml";
$fqdn2="xprv.ml";


foreach($site in $webSites)
{
#$site
    # Add a custom domain name to the web app.
    Set-AzureRmWebApp -Name $($site.Name) -ResourceGroupName $resourceGroupName -HostNames @($fqdn,"$($site.Name).azurewebsites.net",$fqdn2,"avab-dev-global-tmanager.trafficmanager.net")
    #get-AzureRmWebApp -Name $($site.Name) -ResourceGroupName $resourceGroupName
}


foreach($site in $webSites)
{
 Stop-AzureRmWebApp -ResourceGroupName $resourceGroupName  -Name $site.Name
}

foreach($site in $webSites)
{

 Start-AzureRmWebApp -ResourceGroupName $resourceGroupName  -Name $site.Name
}

#
#

#empty  cname u.xprv.pl
#U  cname avab-dev-global-tmanager.trafficmanager.net




# Upload and bind the SSL certificate to the web app.
New-AzureRmWebAppSSLBinding -WebAppName $webappname -ResourceGroupName $webappname -Name $fqdn `
-CertificateFilePath $pfxPath -CertificatePassword $pfxPassword -SslState SniEnabled


#openssl pkcs12 -export -out myserver.pfx -inkey <private-key-file> -in <merged-certificate-file>
#//https://benohead.com/export-app-service-certificate-pfx-file-powershell/
#https://zerossl.com/

$certificateName = "xprv.ml-A03C5DAC5C08027FFBED9EB7773853F4DBB1E640"
$certificateResource = Get-AzureRmResource -ResourceName $certificateName -ResourceGroupName $resourceGroupName -ResourceType "Microsoft.Web/certificates" -ApiVersion "2015-08-01"

$certs=Get-AzureRmResource -ResourceGroupName $resourceGroupName |where ResourceType -eq "Microsoft.Web/certificates"


$certs | where ResourceType -eq "Microsoft.Web/certificates"
$certs[0].Properties.keyVaultId


$certificateResource = Get-AzureRmResource -ResourceName "xprv.ml-A03C5DAC5C08027FFBED9EB7773853F4DBB1E640" -ResourceGroupName $resourceGroupName -ResourceType "Microsoft.Web/certificates" -ApiVersion "2015-08-01"
  Get-Member $certificateResource



  #https://management.azure.com/subscriptions/4525b20d-4a83-4845-97b7-a35f0f1a8ce5/resourceGroups/aa-dev-global-rg/providers/Microsoft.Web/certificates?api-version=2016-03-01
  #subscriptions/4525b20d-4a83-4845-97b7-a35f0f1a8ce5/resourceGroups/aa-dev-global-rg/providers/Microsoft.Web/certificates/xprv.ml-A03C5DAC5C08027FFBED9EB7773853F4DBB1E640