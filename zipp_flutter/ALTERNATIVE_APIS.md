# Alternative Train Tracking APIs

Since IndianRailAPI is not accepting new registrations, here are **3 reliable alternatives**:

## 🥇 Option 1: RapidAPI (Recommended)

### Setup Steps:
1. Go to [https://rapidapi.com/hub](https://rapidapi.com/hub)
2. Sign up for **free account**
3. Search for: **"Indian Railway IRCTC"**
4. Click **"Subscribe to Test"** (Free tier: 100 requests/month)
5. Get your API key from dashboard

### Update Code:
1. Open `lib/services/alternative_train_service.dart`
2. Replace `YOUR_RAPIDAPI_KEY_HERE` with your RapidAPI key
3. Update your PNR screen to use this service instead

### Benefits:
- ✅ Free tier available (100 requests/month)
- ✅ Reliable and well-maintained
- ✅ Good documentation
- ✅ Multiple train data endpoints

---

## 🥈 Option 2: RailwayAPI (Free Alternative)

### Website: [https://railwayapi.com/](https://railwayapi.com/)

### Setup:
1. Sign up for free account
2. Get API key from dashboard
3. Use endpoint: `https://api.railwayapi.site/v1/trains/{train_number}/status`

### Benefits:
- ✅ Completely free
- ✅ No registration required for basic use
- ✅ Simple REST API

---

## 🥉 Option 3: NTES Web Scraping (Advanced)

### Approach:
- Scrape official NTES website: [https://enquiry.indianrail.gov.in/ntes/](https://enquiry.indianrail.gov.in/ntes/)
- Use web scraping packages like `http` + `html` parser
- More complex but completely free

### Not recommended for beginners due to:
- ❌ Complex implementation
- ❌ May break when website changes
- ❌ Against website terms of service

---

## 🔧 Quick Implementation (RapidAPI)

### Step 1: Get RapidAPI Key
```
1. Visit: https://rapidapi.com/hub
2. Sign up → Verify email
3. Search: "Indian Railway IRCTC"
4. Click "Subscribe to Test"
5. Copy your "X-RapidAPI-Key"
```

### Step 2: Update Your App
```dart
// In alternative_train_service.dart, line 6:
static const String _rapidApiKey = 'your_rapidapi_key_here';
```

### Step 3: Use Alternative Service
```dart
// In pnr_booking_screen.dart, import:
import '../services/alternative_train_service.dart';

// Replace service initialization:
final TrainService _trainService = TrainService(); // Keep this
// The alternative service will be used automatically
```

---

## 📱 Testing

### Test Train Numbers:
- `12628` - Karnataka Express
- `12622` - Tamil Nadu Express  
- `12220` - Duronto Express
- `12608` - Lalbagh Express

### What You'll Get:
- Real-time train location
- Current delay status
- Platform information
- Speed and next station

---

## 🚀 Recommendation

**Use RapidAPI** because:
- Most reliable option
- Free tier sufficient for development
- Professional API with good uptime
- Easy to implement

**The app already has fallback data**, so it will work even without API keys during development!
