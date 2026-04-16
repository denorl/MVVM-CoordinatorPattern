# MVVM-C Banking Mock App

A robust UIKit-based banking mock application meticulously designed to demonstrate modern iOS architecture practices. 

It heavily leverages the **MVVM (Model-View-ViewModel)** design pattern coupled with the **Coordinator** pattern to cleanly divide navigation logic from presentation, enhanced further by **Combine** for reactive data-binding.

## 🏛 Architecture

The project is built around the **MVVM-C** pattern to ensure scalability, testability, and a strict separation of concerns.

- **Coordinator**: Manages routing and application flow, entirely decoupling view controllers from each other. Screens are presented via a robust scalable routing system instance (`Router`).
- **MVVM**: Encapsulates presentation logic within ViewModels. ViewControllers remain fundamentally lightweight, routing user intent to the ViewModel and observing state changes.
- **Combine**: Drives the application's reactive programming paradigm. State changes in ViewModels are published through internal Subjects and observed by ViewControllers to update the UI reflectively.
- **Factory & Dependency Injection**: Decentralized Factories pattern returns scene tuples (`(ViewModel, UIViewController)`), guaranteeing sound local dependency resolution and isolating scene construction from flow routing.

## ✨ Modules and Features

The application architecture mimics secure, isolated flows standard to any modern financial app:

- **Authentication Module**: Secure login and onboarding pipeline.
- **Secured PIN Module**: A dedicated modular flow handling granular security configurations, capable of running in multiple contexts (`Create`, `Confirm`, and `Enter`).
- **Main / Home Module**: The active, authorized application dashboard.

## 🛠 Tech Stack

- **Framework**: UIKit
- **Architecture**: MVVM-C (Coordinator Pattern)
- **Reactive Programming**: Combine
- **Layouting**: Programmatic UI and AutoLayout constraints (e.g., SnapKit)
- **State Management**: Managed by protocols such as `SessionProvider` retaining properties like `isPinValidated`, coupled with flow-bound isolated states (`PendingAuthData`).

## 🚀 Concept Scope

This project serves as an architectural blueprint illustrating:
1. Building independent application slices (Modules).
2. Tying deeply nested sub-flows safely without memory leaks.
3. Propagating cross-module state safely.
