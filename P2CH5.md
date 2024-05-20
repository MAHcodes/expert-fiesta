---
section-titles: false
---

# Table of Contents

<!--toc:start-->
- [Table of Contents](#table-of-contents)
- [5. Security through encryption](#5-security-through-encryption)
  - [5.1. General principles](#51-general-principles)
    - [5.1.1. Vocabulary](#511-vocabulary)
    - [5.1.2. Encryption algorithms and keys](#512-encryption-algorithms-and-keys)
  - [5.2. Main cryptographic systems](#52-main-cryptographic-systems)
    - [5.2.1. Symmetric encryption system](#521-symmetric-encryption-system)
    - [5.2.2. Asymmetric encryption system](#522-asymmetric-encryption-system)
    - [5.2.3. Some considerations on cryptanalysis](#523-some-considerations-on-cryptanalysis)
    - [5.2.4. Quantum cryptography](#524-quantum-cryptography)
  - [5.3. Services offered by implementing encryption](#53-services-offered-by-implementing-encryption)
    - [5.3.1. Optimizing encryption with a session key](#531-optimizing-encryption-with-a-session-key)
    - [5.3.2. Check data integrity](#532-check-data-integrity)
    - [5.3.3.Authenticate and sign](#533authenticate-and-sign)
    - [5.3.4. Make confidential and authenticate](#534-make-confidential-and-authenticate)
  - [5.4. Key management infrastructure](#54-key-management-infrastructure)
    - [5.4.1. Secret keys](#541-secret-keys)
    - [5.4.2. Objectives of a key management infrastructure](#542-objectives-of-a-key-management-infrastructure)
    - [5.4.3. Digital certificate](#543-digital-certificate)
    - [5.4.4. Example of a secure transaction via PKI](#544-example-of-a-secure-transaction-via-pki)
    - [5.4.5. Special case of private certification authority](#545-special-case-of-private-certification-authority)
<!--toc:end-->

# 5. Security through encryption

## 5.1. General principles

### 5.1.1. Vocabulary

- **Plaintext:** The original, unencrypted data.
- **Ciphertext:** The scrambled, unreadable data after encryption.
- **Encryption:** The process of transforming plaintext into ciphertext using an encryption algorithm and a key.
- **Decryption:** The process of transforming ciphertext back into plaintext using the same or a related key.
- **Encryption Algorithm:** A set of instructions that defines how plaintext is transformed into ciphertext and vice versa.
- **Cryptographic Key:** A secret value used by the encryption algorithm to scramble and unscramble data.

### 5.1.2. Encryption algorithms and keys

- Encryption algorithms come in two main categories: symmetric and asymmetric.
- **Symmetric Encryption:** Uses a single secret key for both encryption and decryption. This is like having a padlock where the same key opens and locks it.
- **Asymmetric Encryption:** Uses a pair of mathematically linked keys: a public key and a private key. The public key is used for encryption, and the private key is used for decryption. This is like having a mailbox with two slots: one for anyone to put things in (public key), and a special key only you have to retrieve them (private key).
- The choice of encryption algorithm and key management strategy depends on the specific security requirements of the application.

## 5.2. Main cryptographic systems

### 5.2.1. Symmetric encryption system

In a symmetric system, the same secret key is shared between the sender and receiver. The sender encrypts the plaintext with the key, and the receiver uses the same key to decrypt the ciphertext.

- **Advantages:**

  - Efficient for large amounts of data due to simpler algorithms.
  - Faster encryption and decryption compared to asymmetric systems.

- **Disadvantages:**

  - Key distribution is a challenge. Both parties need the same secret key securely exchanged, which can be difficult to manage.
  - Compromising a single key can expose all data encrypted with that key.

### 5.2.2. Asymmetric encryption system

In an asymmetric system, a public key pair is used. The public key is widely distributed, while the private key is kept secret. Anyone can encrypt data with the public key, but only the holder of the private key can decrypt it.

- **Advantages:**

  - Public key distribution is simpler. The public key can be made readily available without compromising security.
  - Offers benefits like digital signatures and non-repudiation.

- **Disadvantages:**

  - Slower encryption and decryption compared to symmetric systems.
  - Not suitable for encrypting large amounts of data due to performance limitations.

### 5.2.3. Some considerations on cryptanalysis

Cryptanalysis is the art of breaking encryption. It's important to consider the strength of the encryption algorithm and key length to resist potential cryptanalytic attacks.

- **Strong Encryption Algorithms:** Advanced Encryption Standard (AES) and Rivest-Shamir-Adleman (RSA) are widely used and considered secure with appropriate key lengths.
- **Key Length:** Longer key lengths offer greater security but can also impact performance.

### 5.2.4. Quantum cryptography

Quantum cryptography uses the strangeness of quantum mechanics to create unbreakable encryption. It exploits properties like superposition (existing in multiple states) and entanglement (linked particles) to encode and transmit data in a way that classical computers can't crack.

- Protects sensitive data in finance, government, and healthcare.
- Still in early stages, but research is making strides.
- Future-proof solution for the encryption challenges posed by quantum computers.
- Expensive and complex, with limitations in distance and integration.

## 5.3. Services offered by implementing encryption

Encryption offers a variety of benefits beyond just data confidentiality. Here are some key services:

### 5.3.1. Optimizing encryption with a session key

- **Session key:** A temporary key used to encrypt data for a single session or transmission.
- **Improves efficiency for large data:** Symmetric encryption with a session key is faster for encrypting large data volumes compared to asymmetric encryption.
- **Reduces risk of key exposure:** Compromised session key only impacts the current data transfer, not past or future sessions.

### 5.3.2. Check data integrity

- **Combined with hashing algorithms:** Encryption can be used alongside hashing algorithms (e.g., SHA-256) to verify data integrity during transmission or storage.
- **Hashing generates a unique fingerprint of the data.**
- **If the data is tampered with, the hash will not match the original, indicating a security breach.**

### 5.3.3.Authenticate and sign

- **Digital signatures:** Asymmetric encryption can be used to create digital signatures, which authenticate the sender of a message.
- **The sender uses their private key to sign the data, and the receiver uses the sender's public key to verify the signature.**
- **This ensures the message originated from the claimed sender and has not been altered in transit.**

### 5.3.4. Make confidential and authenticate

- Combining techniques: Encryption can be combined with digital signatures to achieve both confidentiality and authentication.
- **Data is encrypted with a symmetric key for confidentiality.**
- **The symmetric key itself is then encrypted with the receiver's public key for secure transmission.**
- **The receiver uses their private key to decrypt the symmetric key and then decrypt the data.**

This combined approach offers a robust layer of security for sensitive communications.

## 5.4. Key management infrastructure

Managing encryption keys securely is crucial for the effectiveness of encryption. This is where Key Management Infrastructure (KMI) comes in.

### 5.4.1. Secret keys

- **Symmetric encryption relies on secret keys that must be kept confidential.**
- **KMI provides secure storage, generation, distribution, and rotation of secret keys.**

### 5.4.2. Objectives of a key management infrastructure

- **Secure key storage:** KMI stores keys in a tamper-proof and highly secure environment.
- **Controlled key access:** Only authorized users and systems can access specific keys.
- **Key lifecycle management:** KMI facilitates key generation, distribution, rotation, and secure destruction throughout their lifecycle.

### 5.4.3. Digital certificate

- **Asymmetric encryption uses key pairs (public and private).**
- **Digital certificates bind a public key to a specific entity (e.g., person, website).**
- **Certificates are issued by a trusted Certificate Authority (CA) and contain information for validation.**

### 5.4.4. Example of a secure transaction via PKI

- **Public Key Infrastructure (PKI):** A framework that relies on digital certificates and CAs for secure communication.
- **Example:** In a secure online transaction, the website's public key certificate is verified by the user's browser using a trusted CA.
- **The user's browser then uses the website's public key to encrypt sensitive data (e.g., credit card information) for secure transmission.**

### 5.4.5. Special case of private certification authority

- **Public CAs are trusted entities that issue certificates to the public.**
- **Private CAs are used within an organization for issuing certificates to internal users or systems.**
- **Private CAs offer more control over certificate issuance and management within a closed environment.**
