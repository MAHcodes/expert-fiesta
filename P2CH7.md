---
section-titles: false
---

# Table of Contents

<!--toc:start-->

- [Table of Contents](#table-of-contents)
- [7. Wireless network security](#7-wireless-network-security)
  - [7.2. Network security GSM](#72-network-security-gsm)
    - [7.2.1. Subscriber Identity Confidentiality](#721-subscriber-identity-confidentiality)
    - [7.2.2. Subscriber Identity Authentication](#722-subscriber-identity-authentication)
    - [7.2.3. Privacy of user and signaling data](#723-privacy-of-user-and-signaling-data)
    - [7.2.4. Limits of GSM security](#724-limits-of-gsm-security)
  - [7.3. Wireless LANs and Personal Area Networks](#73-wireless-lans-and-personal-area-networks)
  <!--toc:end-->

# 7. Wireless network security

The very nature of wireless communication, where data travels through the airwaves, makes it inherently more susceptible to interception compared to data traveling over physical cables. Here's why securing wireless networks is critical:

- **Eavesdropping:** Unsecured wireless networks can be easily accessed by anyone within the radio frequency range, allowing them to intercept sensitive data like passwords or confidential communications.
- **Man-in-the-Middle Attacks:** Attackers can position themselves between wireless devices and legitimate access points, intercepting and potentially altering data traffic.
- **Unauthorized Access:** Wireless networks without proper access controls can be easily infiltrated by unauthorized devices, gaining access to the network resources.

## 7.2. Network security GSM

GSM is a widely used cellular network technology. Here are some security features implemented in GSM to protect user privacy and data integrity:

### 7.2.1. Subscriber Identity Confidentiality

GSM protects a user's phone number, a crucial piece of subscriber identity information. This is achieved through:

- **Temporary Identity Number (TMSI):** A temporary identifier assigned to the mobile device during communication. This masks the actual phone number from eavesdroppers.
- **Authentication Triplet:** A set of temporary keys used for user authentication during calls or data sessions. These keys are dynamically generated and discarded after each use, enhancing security.

### 7.2.2. Subscriber Identity Authentication

GSM employs a challenge-response mechanism to verify the legitimacy of a mobile device attempting to connect to the network:

- **Authentication Center (AuC):** A central database that stores subscriber identities and corresponding secret keys.
- **Challenge and Response:** During authentication, the network sends a random challenge to the mobile device. The device uses its secret key and an algorithm to generate a response. The network verifies the response with the AuC to confirm the device's identity.

### 7.2.3. Privacy of user and signaling data

GSM offers some level of privacy for user data and signaling information (messages about call setup and routing):

- **A5/A8 Encryption Algorithms:** These algorithms (varying by network generation) encrypt voice communication to prevent eavesdropping on call content.
- **Ciphering Key Generation:** Ciphering keys used for encryption are dynamically generated for each communication session, improving security.

**It's important to note that the encryption algorithms used in older GSM generations (like A5/1) have been shown to be vulnerable.** Newer generations (like GSM-A with A5/3) offer improved encryption strength.

### 7.2.4. Limits of GSM security

While GSM offers security features, it's not foolproof. Here are some limitations to consider:

- **Vulnerability of Older Encryption:** As mentioned earlier, weaknesses have been identified in older encryption algorithms.
- **Focus on Voice Privacy:** GSM primarily focuses on voice communication encryption. Data transmission (e.g., internet browsing) may not be encrypted by default.
- **Signaling Data Interception:** While user data may be encrypted, signaling information can still be intercepted, potentially revealing user location and call activities.

## 7.3. Wireless LANs and Personal Area Networks

WLANs (Wi-Fi) and PANs (Bluetooth) are popular wireless technologies for connecting devices within a limited range. Here's a brief overview of their security considerations:

- **WLAN Security Protocols:** WPA (Wi-Fi Protected Access) and WPA2 are the primary security protocols for WLANs, offering encryption and authentication mechanisms. WEP (Wired Equivalent Privacy), an older protocol, is considered weak and should be avoided.
- **PAN Security:** Bluetooth technology has evolved to include security features like pairing and encryption to protect data transmission. However, Bluetooth connections can be susceptible to short-range eavesdropping if not properly secured.
