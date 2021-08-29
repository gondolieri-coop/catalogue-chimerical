Function Get-UrlizedString {
  Param(
    $InputObject
  )
  $InputObject = $InputObject.ToLower()
  $InputObject = $InputObject -replace '\s', '-'
  $InputObject = $InputObject -replace "'", ''
  $InputObject
}
Function Export-ItemAsPage {
  [CmdletBinding()]
  Param(
    $RootPath,
    $Items,
    [Switch]$Force
  )
  Begin {}
  Process {
    ForEach ($Item in $Items) {
      $Path = "$RootPath/$($Item.categories -join '/')/$(Get-UrlizedString -InputObject $Item.name).md"
      $Content = @(
        '---'
        "title: $($Item.name)"
        "description: $(($Item.description.Substring(0,197) -split "`n")[0])..."
        'draft: false'
        '---'
        ''
        "## $($Item.name)"
        ''
        "$($Item.Description -join '')"
      ) -join "`n"
      If (!(Test-Path $Path) -or $Force) {
        New-Item -Path $Path -Value $Content -Force:$Force
      }
    }
  }
  End {}
}
Function Export-Item {
  [CmdletBinding()]
  Param(
    $Items,
    [Switch]$Force,
    $FolderPath,
    $Title
  )
  Begin {
    if ([string]::IsNullOrEmpty($FolderPath)) {
      $FolderPath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'content/en'
      Write-Verbose $FolderPath
    }
    switch ($Title) {
      'Bonus' {
        $Description = 'Bonus magical items unlocked by followers of the Catalogue Chimerical KS Campaign'
        $Path = "$FolderPath/$($Title.ToLower()).md"
      }
      'Collected' {
        $Description = 'Collected magical items for Catalogue Chimerical'
        $Path = "$FolderPath/collection.md"
      }
      Default {}
    }
    $Content = @(
      '---'
      "title: $Title Items"
      "description: $Description"
      'enabletoc: true'
      'tocLevels: ["h2", "h3", "h4"]'
      '---'
    ) -join "`n"
  }
  Process {
    ForEach ($Item in $Items) {
      $Content += @(
        ''
        "## $($Item.name)"
        ''
        "$($Item.Description -join '')"
      ) -join "`n"
    }
    If (!(Test-Path $Path) -or $Force) {
      New-Item -Path $Path -Value $Content -Force:$Force
    }
  }
  End {}
}

Function Get-ItemScaffold {
  [CmdletBinding()]
  Param(
    [string]$Category,
    [string]$SubCategory
  )
  Begin {
    $CategorySelection = @(
      @{
        Name = 'art'
        Type = @(
          'statues'
          'tablets'
          'illustrations'
          'pottery'
        )
      }
      @{
        Name = 'panoply'
        Type = @(
          'weapons'
          'armor'
          'shield'
        )
      }
      @{
        Name = 'jewelry'
        Type = @(
          'ring'
          'necklace'
          'circlet'
          'pin'
          'bracelet'
          'bellychain'
          'piercing'
          'brooch'
          'anklet'
        )
      }
      @{
        Name = 'clothing'
        Type = @(
          'apron'
          'robe'
          'bib'
          'blouse'
          'tunic'
          'hat'
          'veil'
          'shawl'
          'dress'
          'skirt'
          'gloves'
          'jacket'
          'vest'
          'cloak'
          'sash'
          'shirt'
          'socks'
          'handkerchief'
          'wrap'
        )
      }
      @{
        Name = 'ritual-sacrifices'
        Type = @(
          'bodypart'
          'food'
          'object'
        )
      }
      @{
        Name = 'tools'
        Type = @(
          'pliars'
          'tongs'
          'knife'
          'chisel'
          'stylus'
          'brush'
          'machete'
          'shears'
          'plane'
          'hook'
          'scythe'
          'saw'
          'whetstone'
          'handtruck'
          'fan'
          'mortar and pestle'
          'rod'
          'pitchfork'
          'sickle'
          'spade'
          'trowel'
          'fork'
          'drill'
        )
      }
    )

    $Target = @(
      'positive effect on self'
      'positive effect on others'
      'negative effect on self'
      'negative effect on others'
    )
    $Theme = @(
      'war'
      'love'
      'prosperity'
      'nature'
      'fire'
      'moon'
    )
    $DecorativeMaterial = @(
      'bronze'
      'iron'
      'ironoak'
      'pentolan marble'
      'precious metal'
      'porcelain'
      'precious gem'
    )
    $Detail = @(
      'bloodstained'
      'polished smooth and soft'
      'partially wrapped in silk'
      'marked with a strange rune'
      'has intricate opaline scrollwork'
      'has tiny iron charms attached'
      'always causes a small shock'
      'grows a strange mold'
      'hums softly in the dark'
      'makes light flicker nearby'
      'smells like a spice'
      'is always slightly damp'
    )
    $Effect = @(
      'gravity'
      'lust'
      'anger'
      'age'
      'sight'
      'light/darkness'
      'greed'
      'fire'
      'ice'
      'lightning'
      'stone'
      'speed'
      'mind'
      'hearing'
      'taste'
      'health'
      'beasts'
      'size'
      'plants'
      'metamagic'
    )
  }

  Process {
    if ([string]::IsNullOrEmpty($Category)) {
      $CategoryInfo = $CategorySelection
      | Get-Random -Count 1
    } else {
      $CategoryInfo = $CategorySelection
      | Where-Object -FilterScript { $_.Name -eq $Category }
      if ([string]::IsNullOrEmpty($SubCategory)) {
        $SubCategory = $CategoryInfo.Type
        | Get-Random -Count 1
      }
    }
    if ([string]::IsNullOrEmpty($SubCategory)) {
      $SubCategory = $CategoryInfo.Type
      | Get-Random -Count 1
    }
    $Item = [PSCustomObject]@{
      Category           = $CategoryInfo.Name
      Subcategory        = $SubCategory
      Target             = $Target | Get-Random -Count 1
      Theme              = $Theme | Get-Random -Count 1
      DecorativeMaterial = $DecorativeMaterial | Get-Random -Count 1
      Detail             = $Detail | Get-Random -Count 1
      Effect             = $Effect | Get-Random -Count 1
    }
    @"
- name: TODO
  categories:
    - $($Item.Category)
    - $($Item.Subcategory)
  tags:
    - $($Item.Theme)
    - $($Item.Effect)
  description: |
    This is a ($($Item.Category):$($Item.Subcategory)) which has a $($Item.Target).
    It's theme is $($Item.Theme) and it is decorated with $($Item.DecorativeMaterial) and $($Item.Detail);
    it effects $($Item.Effect).
"@
  }
  End {}
}
