# 🚀 NFT Collection – ERC-721 Smart Contract

This repository contains a **production-ready ERC-721 NFT smart contract** with a **complete automated test suite** and a **Dockerized environment** for one-command evaluation.

The project is designed to demonstrate **secure smart contract development**, **test-driven development**, and **reproducible builds**.

---

## 📌 Features

- ✅ ERC-721 compatible NFT implementation  
- ✅ Unique token ownership tracking  
- ✅ Admin-only minting  
- ✅ Maximum supply enforcement  
- ✅ Secure transfers with authorization checks  
- ✅ Token approvals & operator approvals  
- ✅ Metadata support via `tokenURI`  
- ✅ Required ERC-721 events  
- ✅ Automated tests (Hardhat)  
- ✅ Fully Dockerized (single command execution)

---


## 🛠️ Tech Stack

- **Solidity** `^0.8.20`
- **Hardhat** `v2.x`
- **Ethers.js**
- **Chai**
- **Node.js**
- **Docker**

---

## 🧠 Smart Contract Overview

### 🔐 Minting
- Only the admin can mint NFTs
- Duplicate token IDs are prevented
- Maximum supply is strictly enforced

### 🔄 Transfers
- Tokens can be transferred by:
  - Owner
  - Approved address
  - Approved operator
- Approvals are cleared after transfer

### 📝 Approvals
- Single-token approvals supported
- Operator approvals for all tokens supported

### 🖼️ Metadata
- Metadata handled via `tokenURI`
- Base URI + tokenId concatenation
- Reverts for non-existent tokens

---

## 🧪 Run Tests Locally

### 1️⃣ Install dependencies
```bash
npm install
2️⃣ Compile contracts
npx hardhat compile

3️⃣ Run tests
npx hardhat test


Expected output:

7 passing

🐳 Run Tests Using Docker (Recommended)
1️⃣ Build Docker image
docker build -t nft-collection .

2️⃣ Run container
docker run nft-collection


Expected output:

7 passing


This runs:

Dependency installation

Contract compilation

Full automated test suite
inside an isolated Docker container.

🔒 Security & Reliability

Strict access control for admin operations

Clear revert messages for invalid actions

Atomic state updates

Unauthorized transfers are blocked

Tests cover both success and failure cases

📦 Submission Notes

No external services required

Fully reproducible environment

One-command Docker execution

Designed for automated evaluation

👤 Author
Anusha Pavani Venneti



