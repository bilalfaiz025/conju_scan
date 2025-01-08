# Conju Scan

## Overview
Conju Scan is a mobile application built with **Flutter** that leverages AI to diagnose **conjunctivitis** and provide essential tools for users and administrators. The app integrates with a **FastAPI backend** for AI predictions and Firebase for additional functionalities, such as authentication, account management, and data storage.

This project is an extension of a research study on conjunctivitis that I led, culminating in a published article exploring its types and impacts.

## Features

### User Features:
- **AI Diagnosis:** Upload images of the eye and receive predictions for conjunctivitis.
- **Doctors Database:** View and contact specialized doctors.
- **Product Awareness:** Learn about harmful medical products not recommended for use.
- **History Tracking:** Access past diagnoses for better health insights.
- **Account Management:** Update profiles, recover passwords, and access help centers.

### Admin Features:
- **Management Tools:** Add, edit, update, or delete doctors, users, and products.
- **User Control:** Manage user accounts and monitor activities.
- **Product Oversight:** Keep product listings accurate and safe for users.

## Tech Stack

### Frontend:
- **Flutter**: For building a responsive and user-friendly UI.

### Backend:
- **FastAPI**: Powers the AI prediction system.
- **TensorFlow**: Implements the AI model for detecting conjunctivitis.
- **Firebase**: Provides authentication, database, and cloud functionalities.

## Installation

### Prerequisites:
- Flutter SDK installed ([Get Flutter](https://flutter.dev/docs/get-started/install))
- Python 3.7+ installed
- Firebase project set up with configuration files

### Steps:
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/bilalfaiz025/conju-scan.git
   cd conju-scan
   ```

2. **Setup Backend (FastAPI):**
   - Navigate to the backend directory:
     ```bash
     cd backend
     ```
   - Create a virtual environment:
     ```bash
     python -m venv myenv
     myenv/Scripts/activate # or source myenv/bin/activate on macOS/Linux
     ```
   - Install dependencies:
     ```bash
     pip install -r requirements.txt
     ```
   - Run the server:
     ```bash
     uvicorn app:app --reload
     ```

3. **Setup Frontend (Flutter):**
   - Navigate to the Flutter project directory:
     ```bash
     cd ../frontend
     ```
   - Install dependencies:
     ```bash
     flutter pub get
     ```
   - Run the app:
     ```bash
     flutter run
     ```

4. **Configure Firebase:**
   - Add your `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) files to the appropriate directories in the project.

## Usage
- **Users:**
  - Register or log in to access features.
  - Upload an eye image to get an AI diagnosis.
  - View doctor recommendations and stay informed about harmful products.

- **Admins:**
  - Manage doctors, products, and users through dedicated tools.
  - Monitor app data and user activities.

## Research Basis
This project is grounded in a research article I led, exploring the types and impacts of conjunctivitis. The research provided the foundation for creating a medically relevant and impactful application.

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add feature-name"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contact
For any inquiries or support, feel free to contact me:
- Email: bilalfaiz396@gmail.com
- LinkedIn: [Your LinkedIn Profile](https://www.linkedin.com/in/bilal-faiz025/))

---

We hope Conju Scan contributes to raising awareness and providing accessible solutions for conjunctivitis diagnosis and management. Your feedback and contributions are invaluable!

