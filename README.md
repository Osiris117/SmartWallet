# WalkYou

## Our Mission

WalkYou was created to build an inclusive financial solution, specifically designed for people with sensory disabilities. Our main focus is to break down the traditional barriers these individuals encounter when performing everyday financial operations.

## Who We Are

We are a team committed to financial inclusion and technological accessibility:

- Alavez Hernández Humberto
- Cortés Hernández Arely
- Minor Nava Santiago Ian
- Silva García Osiris

## Our Vision

To develop a mobile application that not only facilitates financial transactions, but also:

- Provides a completely accessible experience for users with different capabilities
- Integrates sign language technologies for more inclusive communication
- Offers an intuitive and user-friendly interface for all users
- Promotes financial independence for people with different abilities

## Key Features

### Current Implementation

- Interface adapted for different accessibility needs
- Intuitive navigation system
- Basic send and receive money functionalities
- Integrated instructional videos in sign language
- Simplified and guided user experience
- Interledger Open Payments integration for peer-to-peer transfers

### Future Projection

- Complete sign language implementation throughout the application
- Integration with voice recognition systems
- Additional accessibility features
- Expansion of inclusive financial services

## Technical Architecture

### Frontend

Built with Flutter/Dart for cross-platform compatibility (iOS, Android, Web, Desktop).

**Core Dependencies:**

- flutter_svg: Vector graphics support
- video_player: Sign language instructional videos
- google_fonts: Typography customization
- http: API communication layer
- url_launcher: Browser-based authorization flow

**Key Pages:**

- Send Money Page: Peer-to-peer payment interface with Interledger integration
- Receive Page: Payment request interface
- Voice Continue Page: Accessibility-focused navigation
- Home Screen: Main dashboard with transaction actions

### Backend

Node.js REST API server exposing Interledger Open Payments functionality.

**Core Dependencies:**

- @interledger/open-payments v7.1.3: Official Interledger SDK
- express: HTTP server framework
- cors: Cross-origin resource sharing

**Architecture:**

```
backend/
├── server.js          # REST API with 7 endpoints
├── index.js           # CLI tutorial for testing ILP flow
├── private.key        # Authentication key for Open Payments client
├── package.json       # Node.js dependencies
└── README.md          # Backend documentation
```

### Interledger Open Payments Integration

The application uses Interledger Protocol for secure, cross-border peer-to-peer payments via the Open Payments API.

**Payment Flow:**

1. User initiates payment from Send Money page
2. Frontend validates input and calls backend REST API
3. Backend creates authenticated Open Payments client
4. System retrieves sender and receiver wallet addresses
5. Backend creates incoming payment grant and payment object
6. Backend generates quote for the transaction
7. Backend requests outgoing payment grant with interactive authorization
8. User authorizes payment in browser via redirect URL
9. Frontend completes payment by finalizing the grant
10. Payment executes through Interledger network
11. Both parties receive transaction confirmation

**Backend API Endpoints:**

- POST /api/transfer/simple: Initiate payment and return authorization URL
- POST /api/outgoing-payment/complete: Finalize payment after user authorization
- GET /api/wallet/:walletUrl: Retrieve wallet address information
- POST /api/incoming-payment: Create incoming payment
- POST /api/quote: Generate transaction quote
- POST /api/grant/outgoing: Request outgoing payment grant
- GET /api/health: Service health check

**Authentication:**
The backend uses an authenticated Open Payments client initialized with:

- Wallet Address URL: https://ilp.interledger-test.dev/ian
- Private Key: RSA key stored in private.key file
- Key ID: Unique identifier for the authentication key

**Test Environment:**

- Network: Interledger Test Network (ilp.interledger-test.dev)
- Sender Wallet: https://ilp.interledger-test.dev/arely
- Receiver Wallet: https://ilp.interledger-test.dev/humberto
- Client Wallet: https://ilp.interledger-test.dev/ian
- Currency: USD (assetCode: USD, assetScale: 2)

**Amount Format:**
Amounts are represented as strings of integers in base units:

- User input: 1.00 USD
- Converted to: "100" (1.00 USD × 10^2)
- assetScale: 2 (2 decimal places for cents)

### Frontend-Backend Communication

**Request Flow:**

```
Flutter UI → ApiService → HTTP POST → Express Server → Open Payments SDK → ILP Network
```

**Sample Request:**

```json
POST http://localhost:3000/api/transfer/simple
Content-Type: application/json

{
  "senderWalletUrl": "https://ilp.interledger-test.dev/arely",
  "receiverWalletUrl": "https://ilp.interledger-test.dev/humberto",
  "amount": "100",
  "currency": "USD"
}
```

**Sample Response:**

```json
{
  "success": true,
  "requiresAuthorization": true,
  "authorizationUrl": "https://ilp.interledger-test.dev/...",
  "continueUri": "https://ilp.interledger-test.dev/continue/...",
  "continueToken": "access_token_value",
  "message": "Authorization required"
}
```

**Authorization Flow:**

1. Backend returns authorization URL
2. Frontend displays dialog with "Authorize" button
3. User clicks button, browser opens authorization page
4. User approves payment on Interledger platform
5. User returns to app and confirms completion
6. Frontend calls /api/outgoing-payment/complete
7. Backend finalizes grant and executes payment

**Error Handling:**

- 400: Invalid amount format or missing required fields
- 401: Authentication failed with Open Payments client
- 404: Wallet address not found
- 500: Internal server error or Open Payments API failure

All errors include detailed messages and are logged on both frontend and backend for debugging.

## Setup and Installation

### Prerequisites

- Flutter SDK 3.0+
- Node.js 16+
- Git
- Chrome browser (for web development)

### Backend Setup

```bash
cd backend
npm install
npm start
```

Server will start on http://localhost:3000

### Frontend Setup

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

### Testing the Payment Flow

1. Start backend server
2. Launch frontend app
3. Navigate to Send Money page
4. Enter recipient wallet URL: ilp.interledger-test.dev/humberto
5. Enter amount: 1.00
6. Click "Send Money"
7. Click "Authorize" when dialog appears
8. Approve payment in browser
9. Return to app and click "Complete Payment"
10. Verify success message

For detailed testing instructions, see TESTING_GUIDE.md

## Accessibility Features

### Current Implementation

- High contrast color schemes
- Large touch targets for easy interaction
- Clear visual feedback for all actions
- Simplified navigation flow
- Screen reader compatibility
- Sign language video integration

### Planned Enhancements

- Complete sign language implementation throughout the app
- Voice command integration
- Haptic feedback for transaction confirmations
- Customizable font sizes
- Audio descriptions for all visual elements

## Project Status

- Frontend: Active development (Flutter/Dart)
- Backend: Implemented with Interledger Open Payments
- Integration: Complete and functional
- Testing: Active testing on Interledger testnet

## Next Steps

- Expand sign language mode implementation
- Add voice command support
- Implement biometric authentication
- Enhance transaction history features
- Add multi-language support
- Production deployment preparation

## Documentation

- README.md: Project overview (this file)
- INTEGRATION_GUIDE.md: Technical integration details
- TESTING_GUIDE.md: Step-by-step testing instructions
- TROUBLESHOOTING.md: Common issues and solutions
- AMOUNT_FORMAT.md: Currency amount formatting reference
- FLUTTER_SETUP.md: Flutter installation guide
- backend/README.md: Backend-specific documentation
- frontend/README.md: Frontend-specific documentation

## Contributing

We welcome contributions that enhance accessibility and financial inclusion. Please ensure all changes maintain or improve accessibility features.

## License

This project is part of an academic initiative focused on technological accessibility and financial inclusion.

---

For technical details about the current frontend implementation, see the README in the /frontend folder.
For backend API documentation and Interledger integration details, see the README in the /backend folder.
