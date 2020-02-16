# Get an inventory of your Azure environment

The script exports your Azure inventory as CSV files. It builds different CSV files for each subscription with resources.

This is most useful if you change your contract model. For example from EA or Pay-As-You-Go to a CSP contract. Some of the marketplace resources aren't available yet in CSP. You can send your CSP provider this files to give them an overview about your Azure environment.

# Prerequisites

1. PowerShell >= 5.1 or PowerShell Core 6.x   
2. Azure PowerShell Az Module \
   You can download this module at: https://github.com/Azure/azure-powershell/releases/latest \
   or install it directly with `Install-Module -Name Az`
3. At least "Reader" rights on your desired subscriptions

# Usage

1. Download or clone this repo
2. Open up a PowerShell (non-elevated is fine)
3. (optional) Connect to your Azure environment by running `Connect-AzAccount`
4. Run `.\Get-AzureInventory.ps1`. If you're not connected now, it will connect you now.
5. As a result you'll get different CSV files:
   - "subscriptions.csv" with information about all scanned subscriptions.
   - "inventory_<subscription_id>.csv" with all resource information (Name, Resource Group, Type, SKU)
   - "marketplace_<subscription_id>.csv" with all marketplace resources

# Parameters
|Parameter|Default|Possible Value|
|--|--|--|
| `-SubscriptionId` | empty | A subscription ID from your environment. The script will only load resources from this subscription.|
| `-Verbose` |  | Set this parameter to get more information while the script is running |
