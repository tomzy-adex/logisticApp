# Google Maps Setup Guide

## Getting a Google Maps API Key

To use Google Maps in the logistics app, you need to obtain a Google Maps API key:

### 1. Go to Google Cloud Console
- Visit [Google Cloud Console](https://console.cloud.google.com/)
- Create a new project or select an existing one

### 2. Enable Maps SDK for Android
- Go to "APIs & Services" > "Library"
- Search for "Maps SDK for Android"
- Click on it and press "Enable"

### 3. Create API Key
- Go to "APIs & Services" > "Credentials"
- Click "Create Credentials" > "API Key"
- Copy the generated API key

### 4. Restrict the API Key (Recommended)
- Click on the created API key
- Under "Application restrictions", select "Android apps"
- Add your app's package name and SHA-1 certificate fingerprint
- Under "API restrictions", select "Restrict key" and choose "Maps SDK for Android"

### 5. Update the App
Replace the placeholder API key in `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyDj8vnLW0ss28PfWKT0Gy6huvKMK_ZpqBM" />
```

## Current Implementation

The app currently includes:
- ✅ Google Maps widget with markers for origin and destination
- ✅ Automatic bounds fitting to show both locations
- ✅ Info windows with address details
- ✅ Color-coded markers (green for origin, red for destination)
- ✅ Zoom controls and compass

## Features

- **Origin Marker**: Green marker showing pickup location
- **Destination Marker**: Red marker showing delivery location
- **Info Windows**: Tap markers to see address details
- **Auto-fit**: Map automatically adjusts to show both locations
- **Interactive**: Users can zoom, pan, and explore the map

## Testing

To test the map functionality:
1. Login to the app
2. Navigate to any shipment
3. Tap on the shipment to view details
4. Scroll down to see the "Route Maps" section
5. The map will show both origin and destination markers

## Troubleshooting

If the map appears blank:
1. Check your internet connection
2. Verify the API key is correct
3. Ensure Maps SDK for Android is enabled
4. Check that the API key has proper restrictions
5. Look for error messages in the console

## Alternative Implementation

If you prefer not to use Google Maps, the app also includes a custom map widget that shows:
- Visual representation of the route
- Origin and destination markers
- Route line with arrow
- Shipment information overlay

This custom widget doesn't require any API keys and works offline. 