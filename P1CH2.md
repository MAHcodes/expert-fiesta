---
section-titles: false
---

# Table of Contents

<!--toc:start-->

- [Table of Contents](#table-of-contents)
- [2. Client/server architecture](#2-clientserver-architecture)
  - [2.1 Client/server dialogue techniques](#21-clientserver-dialogue-techniques)
    - [2.1.1 Request-response](#211-request-response)
    - [2.1.1 Basic notions: Client, Server, Request, Response.](#211-basic-notions-client-server-request-response)
  - [2.2 Practical Application](#22-practical-application)
    - [2.2.1 InetAddress Class](#221-inetaddress-class)
    - [2.2.2 Using Sockets](#222-using-sockets)
    - [2.2.2.1 TCP Sockets](#2221-tcp-sockets)
  - [TCP Example:](#tcp-example) - [2.2.2.2 UDP Sockets](#2222-udp-sockets)
  <!--toc:end-->

# 2. Client/server architecture

## 2.1 Client/server dialogue techniques

Client-server dialogue techniques are methods used to manage the flow of communication between a client and a server in a distributed system. These techniques ensure that the client and server can exchange information efficiently and reliably.

### 2.1.1 Request-response

This is the **simplest** and **most common** technique. The client sends a request to the server, and the server sends a response back to the client. This technique is used for many different types of requests, such as retrieving data, submitting data, and invoking operations. This pattern is typically implemented in a synchronous fashion, as in web service calls over HTTP, which holds a connection open and waits until the response is delivered or the timeout period expires.

The most common protocol request/response pattern used on a network is the HTTP (Hypertext Transfer Protocol), which is a stateless protocol that operates over the TCP (Transmission Control Protocol). By default, it uses port 80 for unencrypted connections and port 443 for encrypted connections (using HTTPS).

---

**Key components:**

1. **Uniform Resource Identifier (URI):**

   The client includes a **URI** in the request to specify the desired resource.

   The **URI** (Uniform Resource Identifiers) can be one of two things, a **URL** (Uniform Resource Locator) or a **URN** (Uniform Resource Name).

   ![URI vs URL vs URN](./imgs/uri-url-urn.jpg){width=300px}

---

2. **HTTP Methods:**

   HTTP defines several methods that specify the desired action to be performed on the server.

   The most commonly used methods are:

   - **GET:** Retrieves a representation of a resource.
   - **POST:** Submits data to be processed by the server, often used for form submissions.
   - **PUT:** Updates or replaces a resource with the provided data.
   - **DELETE:** Removes a specified resource.

   ![CRUD](./imgs/crud.png){width=300px}

---

3. Headers:

   The client can include additional headers in the request to provide information to the server. Headers can specify things like the client’s user agent, accepted content types, authentication credentials, and more.

   **Example:** `User-Agent: Mozilla/5.0` , `Accept: text/html`

   The server includes headers in the response to provide information back to the client. Headers can specify things like the content type of the response, caching directives, cookies, and more.

   **Example:** `Content-Type: application/json` , `Cache-Control: max-age=3600`

---

4. **Body:**

   For methods like **POST** and **PUT,** the client can include a request body that contains additional data to be sent to the server. The format of the request body depends on the data being transmitted (e.g., form data, JSON payload). The response body contains the actual data returned by the server, format depends on the requested resource.

---

**Structure of HTTP request:**

A request typically includes some form of input or data payload that is needed by the server to perform the requested action.

![HTTP communication diagram](./imgs/httprequestexample.jpg){width=300px}

---

```http
POST /api/v1/users HTTP/1.1
Host: example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c

{
    "name": "Alice",
    "email": "alice@example.com",
    "password": "secret123"
}
```

In this example, the request uses the **HTTP POST** method to create a new user resource on the server. The **URI** or endpoint is `/api/v1/users`, and the request includes several headers, such as `Content-Type` and `Authorization`. Finally, the request body includes a JSON object with data for the new user, including their name, email, and password.

---

**The response would look like this:**

```http
HTTP/1.1 201 Created
Content-Type: application/json

{
"id": "1234567890",
"name": "Alice",
"email": "alice@example.com",
"createdAt": "2023-05-25T10:15:30Z"
}
```

### 2.1.1 Basic notions: Client, Server, Request, Response.

- **Server:**

  A server is a piece of computer hardware or software (computer program) that provides functionality for other programs or devices, called **"clients"**. Servers can provide various functionalities, often called **"services"**, such as sharing data or resources among multiple clients or performing computations for a client. A single server can serve multiple clients, and a single client can use multiple servers. A client process may run on the same device or may connect over a network to a server on a different device. Typical servers are database servers, file servers, mail servers, print servers, web servers, game servers, and application servers.

- **Client:**

  A client is a piece of computer hardware or software (computer program) that consumes functionality from other programs or devices, called **"servers"**. Clients can consume various functionalities, often called **"services"**, such as accessing data or resources, performing computations, or displaying information. A single client can request services from multiple servers, and a single server can serve multiple clients. A client process may run on the same device or may connect over a network to a server on a different device.

---

- **Request:**

  An HTTP request is made by a client, to a named host, which is located on a server. The aim of the request is to access a resource on the server.

- **Response:**

  An HTTP response is made by a server to a client. The aim of the response is to provide the client with the resource it requested, or inform the client that the action it requested has been carried out; or else to inform the client that an error occurred in processing its request.

## 2.2 Practical Application

### 2.2.1 InetAddress Class

Java **InetAddress** class represents an IP address. The `java.net.InetAddress` class provides methods to get the IP of any host name e.g. `www.javatpoint.com`.

An IP address is represented by **32-bit** or **128-bit** unsigned number.

- **IPv4:** 32 bits long and represented by four decimal numbers separated by dots e.g. 192.168.1.1
- **IPv6:** This is a newer version of the IP address format designed to accommodate the growing number of devices connected to the internet. It is 128 bits long and represented by eight groups of four hexadecimal digits separated by colons e.g. 2001:0db8:85a3:0000:0000:8a2e:0370:7334.

---

```java
    InetAddress address = InetAddress.getByName("www.javatpoint.com");
    System.out.println(address); // www.javatpoint.com/172.67.196.82
```

An instance of **InetAddress** represents the IP address with its corresponding host name. There are two types of addresses: **Unicast** and **Multicast.**

- **Unicast:** An identifier for a single interface. A packet sent to a unicast address is delivered to the interface identified by that address.
- **Multicast:** An identifier for a set of interfaces (typically belonging to different nodes). A packet sent to a multicast address is delivered to all interfaces identified by that address.

---

Example of Java InetAddress Class

```java
import java.net.Inet4Address;
import java.util.Arrays;
import java.net.InetAddress;
public class InetDemo2
{
    public static void main(String[] arg) throws Exception
{
    InetAddress addr =  Inet4Address.getByName("www.javatpoint.com");
    InetAddress addr =  Inet4Address.getByName("172.217.19.142");
    InetAddress addr =  Inet4Address.getByAddress(new byte[] {172, 217, 19, 142});
    InetAddress addr =  Inet4Address.getByAddress("www.javatpoint.com",
            new byte[] {172, 217, 19, 142});

    System.out.println(InetAddress.getAllByName("www.javatpoint.com"));
    System.out.println(InetAddress.getLocalHost());
    System.out.println(InetAddress.getLoopbackAddress());
```

---

```java
    System.out.println(addr.isReachable(5000));
    System.out.println(addr.getHostName());
    System.out.println(addr.getCanonicalHostName());
    System.out.println(addr.toString());
    System.out.println(addr.getAddress());
    System.out.println(addr.getHostAddress());
    System.out.println(addr.isAnyLocalAddress());
    System.out.println(addr.isLinkLocalAddress());
    System.out.println(addr.isLoopbackAddress());
    System.out.println(addr.isMulticastAddress());
    System.out.println(addr.isSiteLocalAddress());
    System.out.println(addr.hashCode());
    System.out.println(addr.equals(addr2));
    }
}
```

---

| Method                                     | Description                                                                    |
| ------------------------------------------ | ------------------------------------------------------------------------------ |
| - `getByName(String host)`                 | - Returns an `InetAddress` object for the given host name.                     |
| - `getByAddress(byte[] addr)`              | - Returns an `InetAddress` object for the given IP address.                    |
| - `getByAddress(String host, byte[] addr)` | - Creates an `InetAddress` object based on the given host name and IP address. |
| - `getAllByName(String host)`              | - Returns all the IP addresses for the given host name.                        |
| - `getLocalHost()`                         | - Returns the `InetAddress` of the local host.                                 |
| - `getLoopbackAddress()`                   | - Returns the `InetAddress` of the loopback network interface.                 |
| - `isReachable(int timeout)`               | - Tests whether this IP address is reachable.                                  |
| - `getHostName()`                          | - Returns the host name for this IP address.                                   |
| - `getCanonicalHostName()`                 | - Returns the fully qualified domain name for this IP address.                 |
| - `toString()`                             | - Returns a string representation of this IP address.                          |
| - `getAddress()`                           | - Returns the IP address of this `InetAddress` object.                         |
| - `getHostAddress()`                       | - Returns the IP address string in textual presentation.                       |
| - `isAnyLocalAddress()`                    | - Tests whether this IP address is a wildcard address.                         |
| - `isLinkLocalAddress()`                   | - Tests whether this IP address is a link-local address.                       |
| - `isMulticastAddress()`                   | - Tests whether this IP address is a multicast address.                        |
| - `isSiteLocalAddress()`                   | - Tests whether this IP address is a site-local address.                       |
| - `hashCode()`                             | - Returns the hash code value for this IP address.                             |
| - `equals(Object obj)`                     | - Compares this object against the specified object.                           |

### 2.2.2 Using Sockets

![socket](./imgs/socket.jpg){width=300px}

A **network socket** is a software structure within a network node of a computer network that serves as an endpoint for sending and receiving data across the network. The structure and properties of a socket are defined by an **application programming interface** (API) for the networking architecture. Sockets are created only during the lifetime of a process of an application running in the node.

---

Because of the standardization of the **TCP/IP** protocols in the development of the Internet, the term **network socket** is most commonly used in the context of the **Internet protocol** suite, and is therefore often also referred to as **Internet socket**. In this context, a socket is externally identified to other hosts by its socket address, which is the triad of transport protocol, **IP address**, and **port number**.

The term socket is also used for the software endpoint of node-internal inter-process communication (IPC), which often uses the same API as a network socket.

---

![TCP UDP Socket](./imgs/tcp-udp-sockets.png){width=450px}

---

**What makes each connection unique? How does the server know which source port 49888 is who?**

- Connection is defined by the **pair** of numbers, known as sockets:
  - **Source** IP address, **Source** port.
  - **Destination** IP address, **Destination** port.
- Different connections can use the same destination port on server host as long as the source ports or source IPs are different.
- Combining the transport layer port number and the network layer IP address uniquely identifies a particular application process running on an individual host device. This combination is called a **socket**.
- A **socket pair**, consisting of the source and destination IP addresses and port numbers, is also unique and identifies the specific conversation between the two hosts.
- A client socket might look like this, representing the source IP address and source port number: **192.168.1.102:49888**
- A socket on a web server might be, representing the destination IP address and destination port number: **198.12.15.14:80**
- Together, these two sockets combine to form a socket pair: **192.168.1.102:49888, 198.12.15.14:80**

---

```
~ netstat -n
Proto    Local Address           Foreign Address         State
tcp      192.168.0.102:37558     157.240.195.174:443     ESTABLISHED
tcp      192.168.0.102:53410     172.217.21.1:443        ESTABLISHED
tcp      192.168.0.102:34712     213.204.105.42:80       SYN_SENT
tcp      192.168.0.102:41182     34.107.243.93:443       ESTABLISHED
tcp      192.168.0.102:33972     140.82.114.25:443       ESTABLISHED
```

### 2.2.2.1 TCP Sockets

::::columns

:::{.column width=60%}
The **Transmission Control Protocol** (TCP) is one of the main protocols of the **Internet protocol** suite. It originated in the initial network implementation in which it complemented the **Internet Protocol** (IP). Therefore, the entire suite is commonly referred to as **TCP/IP**. TCP provides reliable, ordered, and error-checked delivery of a stream of octets (bytes) between applications running on hosts communicating via an IP network. Major internet applications such as the World Wide Web, email, remote administration, and file transfer rely on TCP, which is part of the Transport Layer of the **TCP/IP** suite. **SSL/TLS** often runs on top of TCP.
:::

:::{.column width=35%}
![Transmission Control Protocol](./imgs/TCP-1.png){width=200px}
:::

::::

---

**TCP** is **connection-oriented**, and a connection between **client** and **server** is established before data can be sent. The server must be listening (passive open) for connection requests from clients before a connection is established. **Three-way handshake** (active open), retransmission, and error detection adds to reliability but lengthens latency.

Applications that do not require reliable data stream service may use the **User Datagram Protocol** (UDP) instead, which provides a **connectionless datagram** service that prioritizes time over reliability. TCP employs network congestion avoidance. However, there are vulnerabilities in TCP, including denial of service, connection hijacking, TCP veto, and reset attack.

The `java.net.Socket` class represents a socket, and the `java.net.ServerSocket` class provides a mechanism for the server program to listen for clients and establish connections with them.

---

**Connection establishment:**

Before a client attempts to connect with a server, the server must first bind to and listen at a port to open it up for connections: this is called a **passive open**. Once the passive open is established, a client may establish a connection by initiating an **active open** using the three-way (or 3-step) handshake:

1. **SYN:** The active open is performed by the client sending a **SYN** to the server. The client sets the segment's sequence number to a random value **A**.
2. **SYN-ACK:** In response, the server replies with a **SYN-ACK**. The acknowledgment number is set to one more than the received sequence number i.e. **A+1**, and the sequence number that the server chooses for the packet is another random number, **B**.
3. **ACK:** Finally, the client sends an **ACK** back to the server. The sequence number is set to the received acknowledgment value i.e. **A+1**, and the acknowledgment number is set to one more than the received sequence number i.e. **B+1**.

Steps 1 and 2 establish and acknowledge the sequence number for one direction (client to server). Steps 2 and 3 establish and acknowledge the sequence number for the other direction (server to client). Following the completion of these steps, both the client and server have received acknowledgments and a full-duplex communication is established.

---

The following steps occur when establishing a TCP connection between two computers using sockets

1. The server instantiates a ServerSocket object, denoting which port number communication is to occur on.
2. The server invokes the accept() method of the ServerSocket class. This method waits until a client connects to the server on the given port.
3. After the server is waiting, a client instantiates a Socket object, specifying the server name and the port number to connect to.
4. The constructor of the Socket class attempts to connect the client to the specified server and the port number. If communication is established, the client now has a Socket object capable of communicating with the server.
5. On the server side, the accept() method returns a reference to a new socket on the server that is connected to the client's socket.
6. After the connections are established, communication can occur using I/O streams. Each socket has both an OutputStream and an InputStream. The client's OutputStream is connected to the server's InputStream, and the client's InputStream is connected to the server's OutputStream.

TCP is a two-way communication protocol, hence data can be sent across both streams at the same time.

---

- **Creating a Server Side Socket:**

  ```java
  // Creates a Server Socket that listens to port 6789.
  // you don’t specify an IP address for server socket.
  ServerSocket welcomeSocket = new ServerSocket(6789);
  ```

- **Listening to socket:**

  ```java
  Socket connectionSocket = welcomeSocket.accept();
  ```

- **Creating a Client Socket:**

  ```java
  // connects to the server with IP address 172.217. 22.14 on port 6789.
  Socket socket = new Socket("172.217.22.14", 6789);

  // You can also use a domain name instead of an IP address, like this:
  Socket socket = new Socket("domainname.com", 6789);
  ```

---

- **Writing to a Socket (Server or Client):**

  ```java
  BufferedReader inFrom_X = new BufferedReader(
      new InputStreamReader(X_Socket.getInputStream()));
  // X represents Server or Client Socket
  X_Sentence = inFrom_X.readLine();
  ```

- **Reading from a Socket:**

  ```java
  DataOutputStream outTo_X = new DataOutputStream(X_Socket.getOutputStream());
  // X represents Server or Client Socket
  outTo_X.writeBytes(X_Sentence);
  ```

- **Closing a Socket:**

  ```java
  X_socket.close();
  ```

## TCP Example:

The following example implements a Server and client communication using Sockets. the example will create a server socket listening to port 6789 and when a client connect it accepts the connection and replies a capitalized one of the message sent from client

```java
// TCPServer.java
import java.io.*;
import java.net.*;

public class TCPServer {
    public static void main(String args[]) throws Exception {
        String clientSentence;
        String capitalizedSentence;
        ServerSocket welcomeSocket = new ServerSocket(6789);
```

---

```java
        while(true) {
            Socket connectionSocket = welcomeSocket.accept();
            BufferedReader inFromClient =
                new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
            DataOutputStream outToClient =
                new DataOutputStream(connectionSocket.getOutputStream());
            clientSentence = inFromClient.readLine();
            capitalizedSentence = clientSentence.toUpperCase() + '\n';
            outToClient.writeBytes(capitalizedSentence);
        }
    }
}
```

---

```java
// TCPClient.java
import java.io.*;
import java.net.*;

public class TCPClient {
    public static void main(String argv[]) throws Exception {
        String sentence;
        String modifiedSentence;
        BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));

        Socket clientSocket = new Socket("localhost", 6789);
        DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
        BufferedReader inFromServer = new BufferedReader(
            new InputStreamReader(clientSocket.getInputStream()));

        sentence = inFromUser.readLine();
        outToServer.writeBytes(sentence + '\n');
        modifiedSentence = inFromServer.readLine();
        System.out.println(modifiedSentence); clientSocket.close();
    }
}
```

### 2.2.2.2 UDP Sockets

::::columns

:::{.column width=60%}
The **User Datagram Protocol** (UDP) is one of the core communication protocols of the **Internet protocol** suite used to send messages (transported as datagrams in packets) to other hosts on an **Internet Protocol** (IP) network. Within an IP network, **UDP** does not require prior communication to set up communication channels or data paths.
:::

:::{.column width=35%}
![User Datagram Protocol](./imgs/TCP-2.png){width=200px}
:::

::::

---

**UDP** uses a simple **connectionless communication** model with a minimum of protocol mechanisms. UDP provides **checksums** for data integrity, and port numbers for addressing different functions at the source and destination of the datagram. It has no handshaking dialogues and thus exposes the user's program to any unreliability of the underlying network; there is **no guarantee** of delivery, **ordering**, or **duplicate protection**. If error-correction facilities are needed at the network interface level, an application may instead use **Transmission Control Protocol** (TCP) which is designed for this purpose.

**UDP** is suitable for purposes where error checking and correction are either **not** necessary or are performed in the application; **UDP** avoids the overhead of such processing in the protocol stack. Time-sensitive applications often use **UDP** because dropping packets is preferable to waiting for packets delayed due to retransmission, which may not be an option in a real-time system.

---

The **UDP** protocol provides a mode of network communication whereby applications send packets of data, called **datagrams,** to one another. A **datagram** is an independent, self-contained message sent over the network whose arrival, arrival time, and content are not guaranteed. The **DatagramPacket** and **DatagramSocket** classes in the `java.net` package implement system-independent **datagram** communication using **UDP**.

The `java.net` package contains three classes to help you write Java programs that use **datagrams** to send and receive packets over the network: **DatagramSocket**, **DatagramPacket**, and **MulticastSocket** An application can send and receive **DatagramPackets** through a **DatagramSocket**. In addition, **DatagramPackets** can be broadcast to multiple recipients all listening to a **MulticastSocket**.

---

To send data via Java's **DatagramSocket** you must first create a **DatagramPacket**. Here is how that is done:

```java
byte[] buffer = new byte[65508];
InetAddress address = InetAddress.getByName("domainname");
DatagramPacket packet = new DatagramPacket(buffer, buffer.length, address, p);
```

The byte buffer (the byte array) is the data that is to be sent in the UDP datagram. The length of the above buffer, 65508 bytes, is the maximum amount of data you can send in a single UDP packet.

The length given to the DatagramPacket constructor is the length of the data in the buffer to send. All data in the buffer after that amount of data is ignored.

The InetAddress instance contains the address of the node (e.g. server) to send the UDP packet to.

---

The InetAddress class represents an IP address (Internet Address). The getByName() method returns an InetAddress instance with the IP address matching the given host name.

The port parameter is the UDP port the server to receiver the data is listeing on. UDP and TCP ports are not the same. A computer can have different processes listening on e.g. port 80 in UDP and in TCP at the same time.

To send the DatagramPacket you must create a DatagramSocket targeted at sending data. Here is how that is done:

```java
DatagramSocket datagramSocket = new DatagramSocket();
```

To send data you call the send() method, like this:

```java
datagramSocket.send(packet);
```

---

Here is a full example:

```java
DatagramSocket datagramSocket = new DatagramSocket();
byte[] buffer = "0123456789".getBytes();
InetAddress receiverAddress = InetAddress.getLocalHost();
DatagramPacket packet = new DatagramPacket(buffer, buffer.length, receiverAddress, 80);
datagramSocket.send(packet);
```

Receiving data via a DatagramSocket is done by first creating a DatagramPacket and then receiving data into it via the DatagramSocket's receive() method. Here is an example:

```java
DatagramSocket datagramSocket = new DatagramSocket(80);
byte[] buffer = new byte[10];
DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
datagramSocket.receive(packet);
```

---

Notice how the **DatagramSocket** is instantiated with the parameter value 80 passed to its constructor. This parameter is the UDP port the **DatagramSocket** is to receive **UDP** packets on. As mentioned earlier, **TCP** and **UDP** ports are not the same, and thus do not overlap. You can have two different processes listening on both **TCP** and **UDP** port 80, without any conflict.

Second, a byte buffer and a **DatagramPacket** is created. Notice how the **DatagramPacket** has no information about the node to send data to, as it does when creating a **DatagramPacket** for sending data. This is because we are going to use the **DatagramPacket** for receiving data, not sending it. Thus no destination address is needed.

Finally the **DatagramSocket's** `receive()` method is called. This method blocks until a **DatagramPacket** is received.

---

### TCP VS UDP

| TCP                                                                     | UDP                                                                       |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| - Requires an established connection before transmitting data           | - No connection is needed to start and end a data transfer                |
| - Can sequence data (send in a specific order)                          | - Cannot sequence or arrange data                                         |
| - Can retransmit data if packets fail to arrive                         | - No data retransmitting. Lost data can’t be retrieved                    |
| - Delivery is guaranteed                                                | - Delivery is not guaranteed                                              |
| - Thorough error-checking guarantees data arrives in its intended state | - Minimal error-checking covers the basics but may not prevent all errors |
| - Slow, but complete data delivery                                      | - Fast, but at risk of incomplete data delivery                           |
