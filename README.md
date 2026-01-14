# **Project Overview**

**Hedieaty** is a modern, cross-platform gift list management application built with Flutter. It is designed to streamline the process of creating, managing, and sharing wish lists for special occasions like birthdays, parties, and babyshowers, featuring robust offline support and real-time synchronization.

<p align="center">
  <img src="https://i.postimg.cc/ZYxrK1nR/app_Logo.png" />
</p>

## **Table of Contents**

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Showcase Video](#showcase-video)

## **Features**

- **Dynamic Theming**: Supports both Light and Dark modes to enhance the user's experience.
- **User Authentication**: Provided using both client-side validation and server-side validation through Firebase Authentication.
- **Real-time Sync**: Firebase' Realtime Database is used to sync events, gift status(pledged/available), and friend lists across users.
- **Local Caching**: Integrated [_sqflite_](https://pub.dev/packages/sqflite) for local data persistence, allowing users to view and manage their events without an active internet connection.
- **Push Notifications**: Are integrated using Firebase Cloud Messaging (FCM) to notify users when they are added by friends or when a gift in their event has been pledged by someone.
- **Smart Connectivity Handling**: Automatic Checks are done for an internet connection during critical actions (Publishing, Editing, Or deleting Events. & Pledging Gifts)
- **Events Management**: Users are able to categorize events with dynamic icons, Control the privacy of their event, Or delete their un-published events.

## **Tech Stack**

**Frontend**: Flutter (Dart)

**Local Database**: sqflite(SQLite)

**Backend**: Firebase Authentication, Firebase Realtime Database, Firebase Cloud Messaging (FCM)

## **Showcase Video**

[Hedieaty Showcase]((https://youtu.be/O156heIY5zY))
