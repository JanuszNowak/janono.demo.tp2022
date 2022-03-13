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
