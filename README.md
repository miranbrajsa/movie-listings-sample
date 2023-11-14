# movie-listings-sample
An architectural example of a simple movie listings application

## API Keys
The application uses a custom property list to store the API key for TMDB service. This file is under `.gitignore` and should **never** be added to source control. It must be created manually upon project start as it is required for the build process. The filename should read `Secrets.plist` and the contents should be equivalent to the following:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>tmdbAPIKey</key>
    <string>THEMOVIEDB_API_KEY_VALUE_HERE</string>
</dict>
</plist>

```