<#
.SYNOPSIS
    Get an inventory of your Azure environment
.DESCRIPTION
    The script exports your Azure inventory as a CSV file. It builds different CSV files for each subscription with resources. 
.EXAMPLE
    PS C:\> .\Get-AzureEnvironment.ps1
    Gets all resources in all available subscriptions and exports them to CSV files

.EXAMPLE
    PS C:\> .\Get-AzureEnvironment.ps1 -SubscriptionId <subscription-id>
    Gets all resources in a particular subscription and exports them to CSV files

.PARAMETER SubscriptionId
    (optional) Specifies the subscription.

.LINK
    https://github.com/cloudchristoph/AzureInventory
#>
[CmdletBinding()]
param (
    # (optional) Specifies the subscription.
    [Parameter()]
    [string]$SubscriptionId = ""
)

Write-Verbose -Message "Getting subscriptions"
try {
    if ($SubscriptionId.Length -eq 0) {
        $subscriptions = Get-AzSubscription
    } else {
        $subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId
    }    
}
catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException] { 
    Write-Warning -Message "You're not connected. Connecting now."
    Connect-AzAccount
    if ($SubscriptionId.Length -eq 0) {
        $subscriptions = Get-AzSubscription -ErrorAction Stop
    } else {
        $subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop
    }    
}
Write-Verbose -Message "Found $($subscriptions.Length) subscription(s)"

$subscriptions | Export-Csv -Path "./subscriptions.csv"

foreach ($subscription in $subscriptions) {
    $pathInventory = "./inventory_$($subscription.Id).csv"
    $pathMarketplace = "./marketplace_$($subscription.Id).csv"
    Write-Verbose -Message "Getting resources from subscription $($subscription.Name)"
    Select-AzSubscription -SubscriptionObject $subscription
    $ressources = Get-AzResource | Select-Object ResourceName, ResourceGroupName, ResourceType, Sku
    if ($ressources.Length -gt 0) {
        Write-Verbose -Message "$($ressources.Length) resources found"
        $ressources | Export-Csv -Path $pathInventory
        $marketplaceItems = $ressources | Where-Object { $_.ResourceType -notlike "Microsoft.*" } 
        if ($marketplaceItems.Length -gt 0) {
            Write-Verbose -Message "$($marketplaceItems.Length) marketplace resources found"
            $marketplaceItems | Export-Csv -Path $pathMarketplace
        }
    }
}

