# Music Streaming App

## Information
This is a demo application showcasing the Music Streaming App functionality. Here, music is streamed directly from Firebase Cloud Firestore.

Within our Firebase Cloud Firestore, we maintain two collections: one for music and another for users. Our assets, including music images, music files, and user images, are stored in Firebase Storage, utilizing two separate buckets. Cloud Firestore seamlessly retrieves these assets from storage as needed. The application is designed to cache data efficiently.

The data presented within the app is dynamically streamed. Any changes made within the app are instantly reflected in the database console, and vice versa, ensuring real-time synchronization without the need for manual refresh.

## Features
- Music Player functionalities such as music selection, searching, playback controls (play, pause, stop, next, previous)
- User Session Management allowing login across multiple devices with the same account
- Local Database for storing preferences like chosen themes
- Live Data Stream powered by Cloud Firestore
- Offline Data Sync Capability
- Active Internet Connectivity Checker
- Data and Image Caching for enhanced performance
- Multi-Theme Support
- Custom Font (Lato)
- Engaging Animations, Transitions, Lotties, and Audio Waves

This project adheres to SOLID Design Principles and Clean Code Guidelines, ensuring a robust and maintainable codebase. Additionally, the app has been thoroughly tested on both Android and iOS platforms.


