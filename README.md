# Apps I-Desa - Flutter Desktop Application

A modern Flutter desktop application for village management information system (Sistem Informasi Manajemen Desa).

## Features

- **Authentication System**: Secure login with JWT cookies
- **Dashboard Analytics**: Visual charts and statistics for village data
- **Population Management**: Manage villagers and family cards
- **Development Indicators**: Track 13 dimensions of village development
- **Modern UI**: Green theme with rounded corners and Material Design 3

## Supported Platforms

- Windows
- macOS

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Windows or macOS

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run -d windows  # For Windows
flutter run -d macos    # For macOS
```

## Project Structure

```
lib/
├── core/           # Core utilities, theme, constants
├── data/           # Models, repositories, services
├── providers/      # Riverpod state management
└── presentation/   # UI screens and widgets
```

## Backend

This app connects to the Apps I-Desa backend API.

Default API URL: `http://localhost:3000`
