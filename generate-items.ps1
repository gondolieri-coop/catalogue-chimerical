[CmdletBinding()]
Param()
Begin {
  # Dependency Import
  Import-Module powershell-yaml
  . "$PSScriptRoot/pwsh/functions.ps1"

  # Bonus Item Retrieval
  $BonusItems = Get-Content "$PSScriptRoot/data/bonus-items.yaml" -Raw
  | ConvertFrom-Yaml -Ordered
  $BonusItems = ForEach ($Item in $BonusItems) { [PSCustomObject]$Item }
  # Catalogue Item Retrieval
  $CatalogueItems = Get-Content "$PSScriptRoot/data/catalogue-items.yaml" -Raw
  | ConvertFrom-Yaml -Ordered
  $CatalogueItems = ForEach ($Item in $CatalogueItems) { [PSCustomObject]$Item }
}

Process {
  # Export Collection of all Catalogue Items
  # Export-Item -Items $CatalogueItems -Title 'Collected' -Force
  # Export Individual Catalogue Items
  Export-ItemAsPage -Items $BonusItems -RootPath "$PSScriptRoot/content/en/items" -Force
  # Export Bonus Items
  Export-Item -Items $BonusItems -Title 'Bonus' -Force
}

End {}
