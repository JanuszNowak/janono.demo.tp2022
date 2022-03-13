<#
.SYNOPSIS
Add enpoints to azure traffica manager
.DESCRIPTION
This is a Help function to add endpint to traffica manger and work arount to arm temaplte issue when creating new infrastrucure
.PARAMETER ResourceGroupName
The name of the Azure Resource Group Name you want to run the command against.
.EXAMPLE
Add-Endpoints -resourceGroupName app-env-locaiton-rg
.LINK
blog.janono.pl
#>

param
(
    [Parameter(Mandatory=$true)][string]$resourceGroupName
)

$webSites=Get-AzWebApp -ResourceGroupName $resourceGroupName 
    $TmProfile = get-AzTrafficManagerProfile -ResourceGroupName $resourceGroupName 
    foreach($web in $webSites)
    {
        if(!$TmProfile.Endpoints.Name.Contains($web.Name))
        {
            Add-AzTrafficManagerEndpointConfig -EndpointName $web.Name -TrafficManagerProfile $TmProfile -Type AzureEndpoints -Target $web.HostNames[0] -EndpointLocation $web.Location -EndpointStatus Enabled -TargetResourceId $web.Id
        }
    }
    Set-AzTrafficManagerProfile -TrafficManagerProfile $TmProfile 
