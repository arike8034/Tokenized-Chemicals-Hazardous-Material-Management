# Tokenized Chemicals Hazardous Material Management System

A comprehensive blockchain-based system for managing hazardous materials using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a complete solution for tracking, managing, and ensuring compliance with hazardous material handling protocols. It consists of five interconnected smart contracts that work together to provide transparency, accountability, and safety in chemical management.

## Smart Contracts

### 1. Chemical Handler Verification (`chemical-handler-verification.clar`)
- **Purpose**: Manages certification and verification of hazardous material handlers
- **Key Features**:
    - Register certified handlers with expiration dates
    - Verify active certifications
    - Deactivate handlers when necessary
    - Track certification levels and dates

### 2. Material Tracking (`material-tracking.clar`)
- **Purpose**: Tracks hazardous materials throughout their lifecycle
- **Key Features**:
    - Register new hazardous materials with detailed information
    - Update material locations with full audit trail
    - Track material movement history
    - Monitor material status and quantities

### 3. Safety Protocol (`safety-protocol.clar`)
- **Purpose**: Manages hazardous material safety protocols and compliance
- **Key Features**:
    - Create safety protocols for different hazard classes
    - Define required PPE and handling instructions
    - Record compliance with safety protocols
    - Track emergency procedures

### 4. Incident Reporting (`incident-reporting.clar`)
- **Purpose**: Reports and tracks hazardous material incidents
- **Key Features**:
    - Report incidents with severity levels
    - Add follow-up actions and assign responsibilities
    - Track incident resolution status
    - Maintain incident history for analysis

### 5. Disposal Coordination (`disposal-coordination.clar`)
- **Purpose**: Coordinates hazardous material disposal processes
- **Key Features**:
    - Register certified disposal facilities
    - Create disposal requests with scheduling
    - Track disposal status and completion
    - Manage facility certifications

## System Architecture

\`\`\`
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│  Handler            │    │  Material           │    │  Safety             │
│  Verification       │◄──►│  Tracking           │◄──►│  Protocol           │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
│                          │                          │
│                          │                          │
▼                          ▼                          ▼
┌─────────────────────┐    ┌─────────────────────┐
│  Incident           │    │  Disposal           │
│  Reporting          │    │  Coordination       │
└─────────────────────┘    └─────────────────────┘
\`\`\`

## Key Features

### 🔐 **Security & Compliance**
- Blockchain-based immutable records
- Handler certification verification
- Safety protocol enforcement
- Incident tracking and reporting

### 📊 **Transparency**
- Complete audit trail for all materials
- Public verification of handler certifications
- Transparent incident reporting
- Disposal process tracking

### 🔄 **Integration**
- Interconnected contracts for comprehensive management
- Cross-contract data validation
- Unified material lifecycle tracking

### 📈 **Scalability**
- Modular contract design
- Efficient data structures
- Optimized for high-volume operations

## Getting Started

### Prerequisites
- Stacks blockchain node
- Clarity development environment
- Node.js for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd hazmat-management
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts in the following order:
1. `chemical-handler-verification.clar`
2. `material-tracking.clar`
3. `safety-protocol.clar`
4. `incident-reporting.clar`
5. `disposal-coordination.clar`

## Usage Examples

### Register a Chemical Handler
\`\`\`clarity
(contract-call? .chemical-handler-verification register-handler
"John Doe"
"Level 3"
u1000
u2000)
\`\`\`

### Register Hazardous Material
\`\`\`clarity
(contract-call? .material-tracking register-material
"Sulfuric Acid"
"H2SO4"
"Corrosive"
u100
"L"
"Warehouse A"
u1)
\`\`\`

### Report an Incident
\`\`\`clarity
(contract-call? .incident-reporting report-incident
u1
u1
"Spill"
u3
"Warehouse A"
"Small chemical spill during transfer"
"Area evacuated, spill contained")
\`\`\`

## Testing

The system includes comprehensive tests using Vitest:

- **Handler Verification Tests**: Test certification management
- **Material Tracking Tests**: Test material lifecycle tracking
- **Safety Protocol Tests**: Test protocol compliance
- **Incident Reporting Tests**: Test incident management
- **Disposal Coordination Tests**: Test disposal processes

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Data Models

### Handler
- ID, Principal, Name, Certification Level
- Certification Date, Expiry Date, Active Status

### Material
- ID, Name, Chemical Formula, Hazard Class
- Quantity, Unit, Location, Handler ID
- Creation Date, Last Updated, Status

### Safety Protocol
- ID, Name, Hazard Class, Required PPE
- Handling Instructions, Emergency Procedures
- Creation Date, Active Status

### Incident
- ID, Material ID, Reporter ID, Incident Type
- Severity Level, Location, Description
- Immediate Actions, Status, Resolution Date

### Disposal Request
- ID, Material ID, Requester ID, Disposal Method
- Facility, Scheduled Date, Quantity
- Special Instructions, Status, Completion Date

## Security Considerations

- **Access Control**: Contract owner restrictions for critical functions
- **Data Validation**: Input validation and error handling
- **Immutable Records**: Blockchain-based audit trail
- **Certification Verification**: Automated expiry checking

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the repository or contact the development team.

## Roadmap

- [ ] Integration with IoT sensors for real-time monitoring
- [ ] Mobile application for field operations
- [ ] Advanced analytics and reporting dashboard
- [ ] Integration with regulatory compliance systems
- [ ] Multi-language support for international operations
  \`\`\`
