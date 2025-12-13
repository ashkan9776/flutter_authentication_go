# Flutter + Go Authentication App

This is a simple authentication app built with Flutter (for the frontend) and Go (for the backend). The app allows users to register, login, and view their profile after logging in. It uses JWT (JSON Web Tokens) for user authentication.

## Features

- **User Registration:** Users can create a new account by providing a username and password.
- **User Login:** Users can log in using their credentials (username and password).
- **Profile Viewing:** Once authenticated, users can view their profile information (username and custom message).
- **JWT Authentication:** The app uses JWT tokens for user authentication and session management.

## Tech Stack

- **Frontend:** Flutter, Riverpod for state management
- **Backend:** Go (Gin Framework for HTTP server)
- **Database:** In-memory data storage (for demo purposes)

## Prerequisites

Make sure you have the following installed on your machine:
- [Flutter](https://flutter.dev/docs/get-started/install) (version >= 2.0)
- [Go](https://golang.org/doc/install) (version >= 1.16)
- A mobile device or emulator (Android/iOS)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/flutter_go_auth_app.git
