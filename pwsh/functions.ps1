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
    $Path = "$PSScriptRoot/content/en/bonus.md"
  )
  Begin {
    $Content = @(
      '---'
      'title: Bonus Items'
      'description: Bonus magical items unlocked by followers of the Catalogue Chimerical KS Campaign'
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
  Param()
  Begin {
    $CategorySelection = @(
      @('art:statues')
      @('art:tablets')
      @('art:pottery')
      @('art:illustrations')
      @('art:paintings')
      @('panoply:weapons')
      @('panoply:armor')
      @('panoply:shields')
      @('jewelry')
      @('clothing')
      @('ritual-sacrifices')
      @('tools')
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
    $Item = [PSCustomObject]@{
      CategorySelection  = $CategorySelection | Get-Random -Count 1
      Target             = $Target | Get-Random -Count 1
      Theme              = $Theme | Get-Random -Count 1
      DecorativeMaterial = $DecorativeMaterial | Get-Random -Count 1
      Detail             = $Detail | Get-Random -Count 1
      Effect             = $Effect | Get-Random -Count 1
    }
    "This is a ($($Item.CategorySelection)) which has a $($Item.Target). It's theme is $($Item.Theme) and it is decorated with $($Item.DecorativeMaterial) and $($Item.Detail); it effects $($Item.Effect)."
  }
  End {}
}
