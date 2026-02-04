# build_android.ps1
# SEGURANÇA: Não commite este arquivo com chaves reais!
# Use variáveis de ambiente ou passe via parâmetros
param(
    [Parameter(Mandatory=$true)]
    [string]$TmdbApiKey,
    
    [Parameter(Mandatory=$true)]
    [string]$AdmobAndroidAppId,
    
    [string]$AdmobIosAppId = "",
    
    [Parameter(Mandatory=$true)]
    [string]$AdmobAndroidRewardedId,
    
    [string]$AdmobIosRewardedId = ""
)


flutter build apk --release `
  --dart-define=TMDB_API_KEY=$TmdbApiKey `
  --dart-define=ADMOB_ANDROID_APP_ID=$AdmobAndroidAppId `
  --dart-define=ADMOB_IOS_APP_ID=$AdmobIosAppId `
  --dart-define=ADMOB_ANDROID_REWARDED_ID=$AdmobAndroidRewardedId `
  --dart-define=ADMOB_IOS_REWARDED_ID=$AdmobIosRewardedId

  $env:VERSION_CODE = '1001'
  flutter build appbundle --release `
  --build-number=1001 `
  --dart-define=TMDB_API_KEY=$TmdbApiKey `
  --dart-define=ADMOB_ANDROID_APP_ID=$AdmobAndroidAppId `
  --dart-define=ADMOB_IOS_APP_ID=$AdmobIosAppId `
  --dart-define=ADMOB_ANDROID_REWARDED_ID=$AdmobAndroidRewardedId `
  --dart-define=ADMOB_IOS_REWARDED_ID=$AdmobIosRewardedId