# build_android.ps1
param(
    [string]$TmdbApiKey = "4e44d9029b1270a757cddc766a1bcb63",
    [string]$AdmobAndroidAppId = "ca-app-pub-8627801071005444~5894654302",
    [string]$AdmobIosAppId = "ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx",
    [string]$AdmobAndroidRewardedId = "ca-app-pub-8627801071005444/4888694395",
    [string]$AdmobIosRewardedId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx"
)

flutter build apk --release `
  --dart-define=TMDB_API_KEY=$TmdbApiKey `
  --dart-define=ADMOB_ANDROID_APP_ID=$AdmobAndroidAppId `
  --dart-define=ADMOB_IOS_APP_ID=$AdmobIosAppId `
  --dart-define=ADMOB_ANDROID_REWARDED_ID=$AdmobAndroidRewardedId `
  --dart-define=ADMOB_IOS_REWARDED_ID=$AdmobIosRewardedId