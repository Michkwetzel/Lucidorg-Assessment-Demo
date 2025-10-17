# 🎯 LucidOrg Assessment Application
Employee-facing assessment interface for organizational health surveys.



https://github.com/user-attachments/assets/9a4d9fa5-962d-4098-bc07-52d24fef6fd7



## 💡 What It Does
Users receive an email with a unique JWT-authenticated link to complete organizational health assessments. Results are submitted directly to the backend API—no direct database writes from the frontend.
## 🛠️ Tech Stack
- **Frontend**: Flutter/Dart
- **Backend**: Google Cloud Functions (Python)
- **Database**: Cloud Firestore
- **Auth**: JWT token-based
- **Deployment**: Firebase Hosting
## ⚙️ How It Works
1. User receives email with unique assessment link containing JWT token
2. User completes assessment through guided interface
3. Results submit to backend API via REST endpoints
4. Backend validates JWT and processes data
## 🔗 Platform Integration
This assessment frontend integrates with two admin platforms:
| Platform | Purpose | Status |
|----------|---------|--------|
| **MVP Dashboard** | Original SaaS platform for distributing assessments and viewing results | Deprecated (Oct 2024 - Feb 2025) |
| **Org Studio** | Rebuilt internal business tool | Active (July 2025+) |

Both platforms use this same assessment frontend with different backend architectures.
## 🔒 Security Model
- JWT tokens embedded in assessment URLs
- Backend-only database writes
- Token validation on all API requests
- Locked-down Firestore with no direct frontend access
## ✨ Key Features
- Guided assessment flow with progress tracking
- Responsive design (mobile + desktop)
- Automatic retry logic for failed requests

## 📚 Related Repositories
- [MVP Dashboard Repository] - Original SaaS admin platform
- [Org Studio Repository] - Current business logic platform
- [Full Case Study](https://www.notion.so/LucidOrg-Assessment-Platform-From-Manual-to-Automated-SaaS-Deep-Dive-28db502d0e3a80aa9a12c88c7a4a274c?pvs=21) - Complete technical breakdown
---
**Built as Founding Engineer | Oct 2024 - Oct 2025**
