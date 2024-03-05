---
section-titles: false
---

# Table of Contents

<!--toc:start-->

- [Table of Contents](#table-of-contents)
- [4. Remote Procedure Call (RPC)](#4-remote-procedure-call-rpc)
  - [Introduction](#introduction)
  <!--toc:end-->

# 4. Remote Procedure Call (RPC)

## 4.1 Introduction

![RPC Model](./imgs/operating-system-remote-procedure-call-1.png){width=300px}

---

A remote procedure call (RPC) is when a computer program causes a procedure (subroutine) to execute in a different address space (commonly on another computer on a shared network), which is written as if it were a normal (local) procedure call, without the programmer explicitly writing the details for the remote interaction. That is, the programmer writes essentially the same code whether the subroutine is local to the executing program, or remote. This is a form of client–server interaction (caller is client, executor is server), typically implemented via a request–response message-passing system.

## 4.2. RPC model

RPC is a request–response protocol. An RPC is initiated by the client, which sends a request message to a known remote server to execute a specified procedure with supplied parameters. The remote server sends a response to the client, and the application continues its process. While the server is processing the call, the client is blocked (it waits until the server has finished processing before resuming execution), unless the client sends an asynchronous request to the server, such as an XMLHttpRequest. There are many variations and subtleties in various implementations, resulting in a variety of different (incompatible) RPC protocols.

An important difference between remote procedure calls and local calls is that remote calls can fail because of unpredictable network problems. Also, callers generally must deal with such failures without knowing whether the remote procedure was actually invoked. Idempotent procedures (those that have no additional effects if called more than once) are easily handled, but enough difficulties remain that code to call remote procedures is often confined to carefully written low-level subsystems.

### Sequence of events

1. The client calls the client stub. The call is a local procedure call, with parameters pushed on to the stack in the normal way.
2. The client stub packs the parameters into a message and makes a system call to send the message. Packing the parameters is called marshalling.
3. The client's local operating system sends the message from the client machine to the server machine.
4. The local operating system on the server machine passes the incoming packets to the server stub.
5. The server stub unpacks the parameters from the message. Unpacking the parameters is called unmarshalling.
6. Finally, the server stub calls the server procedure. The reply traces the same steps in the reverse direction.

### 4.3. Identifying remote procedures

Each RPC procedure is uniquely identified by a program number, version number, and procedure number.

The program number identifies a group of related remote procedures, each of which has a different procedure number. Program numbers are given out in groups of hexadecimal 20000000.

0 - 1ﬀﬀﬀf deﬁned by Sun  
20000000 - 3ﬀﬀﬀf deﬁned by user  
40000000 - 5ﬀﬀﬀf transient  
60000000 - 7ﬀﬀﬀf reserved  
80000000 - 9ﬀﬀﬀf reserved  
a0000000 - bfffffff reserved  
c0000000 - dfffffff reserved  
e0000000 - ffffffff reserved

---

Each program also has a version number, so when a minor change is made to a remote service (adding a new procedure, for example), a new program number does not have to be assigned.

The first implementation of a program will most likely have version number 1. Because most new protocols evolve into better, stable, and mature protocols, a version field of the call message identifies the version of the protocol the caller is using. Version numbers make speaking old and new protocols through the same server process possible.

Version numbers are incremented when functionality is changed in the remote program. Existing procedures can be changed or new ones can be added. More than one version of a remote program can be defined and a version can have more than one procedure defined. The procedure number identifies the procedure to be called. These numbers are documented in the specific program's protocol specification.

### 4.4. Dynamic allocation of transport ports to RPC programs

**Mapping A Remote Program To A Protocol Port**

In RPC programs, dynamic allocation of transport ports refers to the process where servers don't have predefined port numbers.
Instead, they request available ports from the operating system during startup. This approach offers several advantages compared to static port allocation  

**Benefits:**

:::columns

::::{.column width=65%}

- **Flexibility:** RPC servers don't need to be tied to specific, predefined port numbers. This avoids conflicts if multiple RPC servers run on the same machine.
- **Security:** Not using well-known ports can slightly obscure the services running on a machine, providing a minor layer of security through obscurity.
- **Firewall Compatibility:** In some network setups, firewalls might be configured to only allow traffic for specific ports. Dynamic allocation helps you get around potential restrictions.

::::

::::{.column width=35%}

![Portmapper](./imgs/portmapper.jpg){width=80%}

::::

:::
---

**Why Standard/Static Ports Aren't Used?**

One of the challenges in **RPC** is that the number of potential **RPC** programs can far exceed the available port numbers.
Since both **TCP** and **UDP** use 16-bit port numbers, offering only 65,536 possibilities, while program numbers can represent over 4 billion (2^32) programs.
This makes it **impossible** to directly map a program number to a port number. To overcome this limitation, **RPC** utilizes **dynamic port allocation**. Here's how it works:

1. **Server Startup:** When an RPC server starts, it requests an available port from the operating system. This assigned port is temporary and might change with each server restart.
2. **Portmapper/RPCBIND Registration:** The server registers its program number, version number, and the dynamically assigned port with a special service called **portmapper** or **RPCBIND**. This service acts like a phonebook, mapping program information to their assigned ports.
3. **Client Inquiry:** When a client wants to use an RPC service, it:
    - Contacts the portmapper/RPCBIND on a well-known port (usually 111).
    - Provides the desired program number and version information.
4. **Portmapper Lookup:** The portmapper/RPCBIND searches its registry and retrieves the corresponding dynamically assigned port for the requested program.
5. **Client Connection:** The client then establishes a direct connection to the server using the retrieved port number and communicates using the chosen protocol (TCP/UDP).

---

**Example of Dynamic Port Allocation in RPC**

:::columns

::::{.column width=70%}

1. **Server:** An RPC server for a "File Sharing" program starts and dynamically requests a port from the operating system. Let's say it receives port number **45678**.
2. **Server Registration:** The server registers its program information (program name: "File Sharing", version: 1.0) and the assigned port (45678) with the **portmapper/RPCBIND** service (usually on port 111).

3. **Client:** A client program wants to access the "File Sharing" service.
     - _Client cannot directly connect:_ The client doesn't know the server's dynamically assigned port.
     - _Client Inquiry:_ The client contacts the portmapper/RPCBIND on port 111 and asks for information about the "File Sharing" program (version 1.0).
::::

::::{.column width=30%}

![Portmapper](./imgs/rpc-dynamic-port.jpg){width=150px}

::::

:::

4. **Portmapper Lookup:** The portmapper searches its registry and finds the program information. It retrieves the corresponding dynamically assigned port (45678).
5. **Client Connection:** The client now knows the server's port (45678) and can establish a direct connection to the server using that port to access the "File Sharing" service.

## 4.5. Semantics of transport for RPC

Imagine you're calling a friend on the phone, but sometimes the call gets dropped and you need to call again. due to traffic or network issues, the message might be delivered multiple times.
This can be problematic when working with Remote Procedure Calls (RPCs), where we want to ensure the remote procedure executes as intended.

There are three choices of call semantics, which define how RPC systems handle situations where the request might be sent multiple times:

1. **Exactly once:** This is the ideal scenario, guaranteeing the procedure runs only once even if the request is sent multiple times. It's crucial for sensitive operations like financial transactions to avoid duplicate actions. However, achieving this is the most challenging.
2. **At most once:** A successful response from the remote computer confirms the procedure was executed at most once. However, if there's an error or the response is lost, the system can't guarantee execution. This might be suitable for situations where retries are acceptable.
3. **At least once:** This ensures the procedure runs at least once. The client might resend the request until it receives a successful response. This can lead to multiple executions, which might be undesirable in some cases, but it's often used for idempotent procedures.

## 4.6. RPC Authentication

To ensure **secure** communication, **RPC** defines various authentication methods. These range from a simple scheme using UNIX credentials to a more robust approach using **Data Encryption Standard** (DES).
Here's an overview of the common authentication types:

- **NULL Authentication:** No authentication is performed. Neither the client nor the server verifies each other's identity. This is suitable for low-risk situations like accessing a public time server.
- **UNIX Style Authentication:** This method relies on the client providing its hostname, user ID, local timestamp, and group information. The server uses this information to grant or deny access. However, this method is considered weak as anyone can impersonate a user by knowing their credentials on the client machine. It's primarily used in NFS (Network File System).
- **Data Encryption Standard (DES):** This method offers stronger security. The client sends a password to the server in an encrypted format using a shared secret key. This makes it significantly harder for unauthorized users to eavesdrop and impersonate legitimate users.
- **SHORT:** This method is primarily used for subsequent messages after the initial connection is established. After initial authentication, the client receives a "handle" used for future communication, eliminating the need to repeatedly send credentials. This enhances security as an attacker cannot easily forge the handle.

## 4.7. RPC Message Format

The RPC protocol uses a specific format for messages exchanged between clients and servers. It consists of several key elements:

-   **Message ID:**  A unique identifier for each message, allowing proper response matching.
-   **Message Type:**  Indicates whether the message is a  **CALL**  (requesting a procedure execution) or a  **REPLY**  (responding to a previous request).
-   **RPC Version Number:**  Specifies the version of the RPC library being used.
-   **Remote Program:**  The name of the program on the server that the procedure call is intended for.
-   **Remote Program Version:**  The specific version of the program being targeted.
-   **Remote Procedure:**  The name of the specific procedure being invoked on the server.
-   **Procedure Arguments (CALL):**  The data sent to the server for the procedure execution (only present in CALL messages).
-   **Procedure Results (REPLY):**  The data returned by the server after executing the procedure (only present in REPLY messages).

### Example:

- **Client sends a CALL message to a server to get the current date:**

    ```
    Message ID: 1234 (unique identifier)
    Message Type: CALL
    RPC Version Number: 2 (version of the RPC library)
    Remote Program: "DateService"
    Remote Program Version: 1
    Remote Procedure: "GetCurrentDate"
    Procedure Arguments: (empty, as no arguments are needed)
    ```

- **Server replies with a REPLY message:**

    ```
    Message ID: 1234 (matching the original CALL message ID)
    Message Type: REPLY
    RPC Version Number: 2
    Remote Program: "DateService"
    Remote Program Version: 1
    Remote Procedure: "GetCurrentDate"
    Procedure Results: "2024-03-05" (the current date)
    ```
