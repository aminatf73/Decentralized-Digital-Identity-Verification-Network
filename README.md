# Decentralized Digital Identity Verification Network

A blockchain-based identity verification system built with Clarity smart contracts that enables secure, user-controlled identity management.

## Overview

This project implements a decentralized identity verification network with the following components:

1. **Identity Provider Verification Contract**: Validates and registers credential issuers
2. **Attribute Attestation Contract**: Records verified identity claims
3. **Verification Request Contract**: Manages identity verification requests
4. **Consent Management Contract**: Controls data sharing permissions
5. **Audit Trail Contract**: Records identity verification activities

## Architecture

The system uses a set of interconnected smart contracts to manage different aspects of identity verification:

- Identity providers are registered and verified before they can issue credentials
- Users control their identity attributes through consent management
- All verification activities are recorded in an immutable audit trail
- Verification requests can be created and fulfilled through the network

## Smart Contracts

### Identity Provider Verification
Validates and registers entities that can issue identity credentials.

### Attribute Attestation
Records verified identity claims that have been attested by verified providers.

### Verification Request
Manages requests for identity verification between requesters and identity holders.

### Consent Management
Enables users to control permissions for sharing their identity data.

### Audit Trail
Records all identity verification activities for transparency and compliance.

## Testing

Tests are implemented using Vitest. Run tests with:

```bash
npm test
