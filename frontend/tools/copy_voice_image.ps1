<#
  Script para copiar la imagen temporal al proyecto
  Uso:
    - Abre PowerShell en la máquina donde está el repo
    - Ejecuta: .\frontend\tools\copy_voice_image.ps1
    - Opcional: pasar parámetros -Source y -Dest

  Este script no moverá archivos fuera del proyecto salvo que especifiques una ruta de destino distinta.
#>

param(
    [string]$Source = "$env:LOCALAPPDATA\Temp\Sin título-1.jpg",
    [string]$Dest = "$PSScriptRoot\..\assets\images\voice_page.png"
)

Write-Host "Fuente: $Source"
Write-Host "Destino: $Dest"

try {
    $resolved = Resolve-Path -Path $Source -ErrorAction Stop
} catch {
    Write-Error "No se encontró la imagen en la ruta: $Source"
    exit 1
}

$destDir = Split-Path -Path $Dest -Parent
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}

Copy-Item -Path $resolved -Destination $Dest -Force
if ($?) {
    Write-Host "Imagen copiada correctamente a: $Dest"
    exit 0
} else {
    Write-Error "Error al copiar la imagen."
    exit 2
}
