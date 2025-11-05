# Build Release APK/AAB com todas as variaveis do .env
# Uso: .\build-release.ps1 -BuildType apk (ou appbundle)

param(
    [ValidateSet('apk','appbundle')]
    [string]$BuildType = 'appbundle',
    
    [switch]$Clean
)

Write-Host "Build Release Script - RollFlix" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

# Verificar se o .env existe
$envFile = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envFile)) {
    Write-Host "Arquivo .env nao encontrado!" -ForegroundColor Red
    Write-Host "Crie o arquivo .env na raiz do projeto com as variaveis necessarias." -ForegroundColor Yellow
    exit 1
}

Write-Host "Lendo variaveis do .env..." -ForegroundColor Green

# Ler o arquivo .env e criar um hashtable com as variaveis
$envVars = @{}
Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith('#')) {
        $parts = $line -split '=', 2
        if ($parts.Count -eq 2) {
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            $envVars[$key] = $value
            Write-Host "   OK: $key" -ForegroundColor Gray
        }
    }
}

# Verificar variaveis obrigatorias
$requiredVars = @(
    'TMDB_API_KEY',
    'ADMOB_ANDROID_APP_ID',
    'ADMOB_ANDROID_REWARDED_ID'
)

$missingVars = @()
foreach ($var in $requiredVars) {
    if (-not $envVars.ContainsKey($var) -or [string]::IsNullOrWhiteSpace($envVars[$var])) {
        $missingVars += $var
    }
}

if ($missingVars.Count -gt 0) {
    Write-Host ""
    Write-Host "Variaveis obrigatorias faltando no .env:" -ForegroundColor Red
    $missingVars | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    exit 1
}

# Verificar se o keystore existe
$keyPropsFile = Join-Path $PSScriptRoot "android\key.properties"
if (-not (Test-Path $keyPropsFile)) {
    Write-Host ""
    Write-Host "Arquivo android/key.properties nao encontrado!" -ForegroundColor Red
    Write-Host "Configure o keystore para assinar o build de release." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Keystore configurado: OK" -ForegroundColor Green

# Construir argumentos --dart-define
$dartDefines = @()
foreach ($key in $envVars.Keys) {
    $value = $envVars[$key]
    if (-not [string]::IsNullOrWhiteSpace($value)) {
        $dartDefines += "--dart-define=$key=$value"
    }
}

# Gerar VERSION_CODE dinamico (timestamp yyMMddHH - ano/mes/dia/hora)
# Formato: 25110420 = 2025-11-04 20:XX
# Maximo permitido pelo Android: 2.100.000.000
$versionCode = Get-Date -Format 'yyMMddHH'

Write-Host ""
Write-Host "VERSION_CODE: $versionCode" -ForegroundColor Cyan

# Flutter clean (opcional)
if ($Clean) {
    Write-Host ""
    Write-Host "Executando flutter clean..." -ForegroundColor Yellow
    flutter clean
}

# Construir o comando
$buildArgs = @('build', $BuildType, '--release')
$buildArgs += $dartDefines
# Passar VERSION_CODE como propriedade Gradle
$buildArgs += "--build-number=$versionCode"

Write-Host ""
Write-Host "Construindo $BuildType..." -ForegroundColor Cyan
Write-Host "Comando: flutter build $BuildType --release --build-number=$versionCode (com $($dartDefines.Count) variaveis)" -ForegroundColor Gray
Write-Host ""

# Executar o build (usando & para preservar variáveis de ambiente)
flutter @buildArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=======================================================" -ForegroundColor Green
    Write-Host "Build concluido com sucesso!" -ForegroundColor Green
    Write-Host "=======================================================" -ForegroundColor Green
    Write-Host ""
    
    if ($BuildType -eq 'appbundle') {
        $outputPath = "build\app\outputs\bundle\release\app-release.aab"
        Write-Host "App Bundle: $outputPath" -ForegroundColor Cyan
    } else {
        $outputPath = "build\app\outputs\flutter-apk\app-release.apk"
        Write-Host "APK: $outputPath" -ForegroundColor Cyan
    }
    
    if (Test-Path $outputPath) {
        $fileInfo = Get-Item $outputPath
        $sizeMB = [math]::Round($fileInfo.Length / 1MB, 2)
        Write-Host "Tamanho: $sizeMB MB" -ForegroundColor Gray
        Write-Host "VERSION_CODE usado: $versionCode" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "Proximos passos:" -ForegroundColor Yellow
    Write-Host "1. Teste o $BuildType em um dispositivo" -ForegroundColor White
    Write-Host "2. Verifique se o login Google funciona" -ForegroundColor White
    Write-Host "3. Teste as compras in-app (RevenueCat)" -ForegroundColor White
    Write-Host "4. Verifique se os anuncios carregam" -ForegroundColor White
    
    if ($BuildType -eq 'appbundle') {
        Write-Host ""
        Write-Host "Para upload no Play Console:" -ForegroundColor Yellow
        Write-Host "- Va em Release -> Production (ou Testing)" -ForegroundColor White
        Write-Host "- Crie um novo release e faca upload do AAB" -ForegroundColor White
    }
    
    exit 0
} else {
    Write-Host ""
    Write-Host "Build falhou com codigo de erro: $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}
