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

- **Message ID:** A unique identifier for each message, allowing proper response matching.
- **Message Type:** Indicates whether the message is a **CALL** (requesting a procedure execution) or a **REPLY** (responding to a previous request).
- **RPC Version Number:** Specifies the version of the RPC library being used.
- **Remote Program:** The name of the program on the server that the procedure call is intended for.
- **Remote Program Version:** The specific version of the program being targeted.
- **Remote Procedure:** The name of the specific procedure being invoked on the server.
- **Procedure Arguments (CALL):** The data sent to the server for the procedure execution (only present in CALL messages).
- **Procedure Results (REPLY):** The data returned by the server after executing the procedure (only present in REPLY messages).

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

  ```go
  Message ID: 1234 (matching the original CALL message ID)
  Message Type: REPLY
  RPC Version Number: 2
  Remote Program: "DateService"
  Remote Program Version: 1
  Remote Procedure: "GetCurrentDate"
  Procedure Results: "2024-03-05" (the current date)
  ```

## 4.8. RPC Language

The easiest way to define and generate the protocol is to use a protocol compiler such as **rpcgen**.

rpcgen generates code (stubs) that hides the network communication details from both the client and server code. These stubs can be compiled and linked with the developer's code to create a functional RPC program. The client calls the local stubs as if they were local procedures, and the server procedures are linked with the server stub to handle remote calls.

The **rpcgen** command generates C code to implement a Remote Procedure Call (RPC) protocol. The **input** to the **rpcgen** command is a language similar to C language known as **RPC Language**. The first syntax structure is the most commonly used form for the **rpcgen** command where it takes an input file and generates four output files.

For example, if the InputFile parameter is named `proto.x`, then the rpcgen command generates the following:

| File         | Description                                                                    |
| ------------ | ------------------------------------------------------------------------------ |
| proto.h      | A header file of definitions common to the server and the client               |
| proto_xdr.c  | A set of XDR routines that translate each data type defined in the header file |
| proto_svc.c  | A stub program for the server                                                  |
| proto_clnt.c | A stub program for the client                                                  |

## 4.9 Practical application

### 4.9.1. Sun Java RMI

**RMI**, short for Remote Method Invocation, is a **mechanism** that allows objects residing in separate Java Virtual Machines (JVMs) to access and invoke methods on each other.
This capability is particularly useful for building distributed applications, as it facilitates remote communication between Java programs. **RMI** functionality is provided within the `java.rmi` package.

**Architecture of an RMI Application**

In an **RMI** application, we write two programs,

- A **server** program (resides on the server).
- A **client** program (resides on the client).

Inside the server program, a remote object is created and reference of that object is made available for the client (using the registry).

The client program requests the remote objects on the server and tries to invoke its methods.

---

The following diagram shows the architecture of an RMI application.

:::columns

::::{.column width=55%}

- **Transport Layer**: This layer connects the client and the server. It manages the existing connection and also sets up new connections.

- **Stub**: A stub is a representa on (proxy) of the remote object at client. It resides in the client system; it acts as a gateway for the client program.

- **Skeleton**: This is the object which resides on the server side. stub communicates with this skeleton to pass request to the remote object.

- **RRL (Remote Reference Layer)**: It is the layer which manages the references made by the client to the remote object.

::::

::::{.column width=45%}

![RMI application](./imgs/rmi-java.png){width=200px}

::::

:::

---

**Working of an RMI Application**

When the client makes a call to the remote object, it is received by the stub which eventually passes this request to the RRL.

When the client-side RRL receives the request, it invokes a method called invoke() of the object remoteRef. It passes the request to the RRL on the server side.

The RRL on the server side passes the request to the Skeleton (proxy on the server) which finally invokes the required object on the server.

The result is passed all the way back to the client.

---

**Marshalling and Unmarshalling**

Whenever a client invokes a method that accepts parameters on a remote object, the parameters are bundled into a message before being sent over the network.

These parameters may be of primitive type or objects. In case of primitive type, the parameters are put together and a header is attached to it. In case the parameters are objects, then they are serialized.

This process is known as marshalling. At the server side, the packed parameters are unbundled and then the required method is invoked. This process is known as unmarshalling.

---

**RMI Registry**

:::columns

::::{.column width=60%}

RMI registry is a namespace on which all server objects are placed. Each time the server creates an object, it registers this object with the RMI registry (using bind() or reBind() methods).

These are registered using a unique name known as bind name.

To invoke a remote object, the client needs a reference of that object. At that time, the client fetches the object from the registry using its bind name (using lookup() method).

The following illustration explains the entire process

::::

::::{.column width=30%}

![Registry](./imgs/rmi-registry.png)

::::

:::

---

**Goals of RMI**

- To minimize the complexity of the application.
- To preserve type safety.
- Distributed garbage collection.
- Minimize the difference between working with local and remote objects.

---

**Write RMI Java Application**

To write an RMI Java application, you would have to follow the steps given below

- Define the remote interface
- Develop the implementation class (remote object)
- Develop the server program
- Develop the client program
- Compile the application
- Execute the application
- Defining the Remote Interface

A remote interface provides the description of all the methods of a particular remote object. The client communicates with this remote interface.

---

**To create a remote interface:**

- Create an interface that extends the predefined interface Remote which belongs to the package.
- Declare all the business methods that can be invoked by the client in this interface.

Since there is a chance of network issues during remote calls, an exception named RemoteException may occur; throw it.

Following is an example of a remote interface. Here we have defined an interface with the name Hello and it has a method called printMsg().

```java
import java.rmi.Remote;
import java.rmi.RemoteException;
// Creating Remote interface for our application
public interface Hello extends Remote {
void printMsg() throws RemoteException;
}
```

---

**Developing the Implementation Class (Remote Object)**

We need to implement the remote interface created in the earlier step. (We can write an implementation class separately or we can directly make the server program implement this interface.)

To develop an implementation class:

- Implement the interface created in the previous step.
- Provide implementation to all the abstract methods of the remote interface.

Following is an implementation class. Here, we have created a class named ImplExample and implemented the interface Hello created in the previous step and provided body for this method which prints a message.

```java
// Implementing the remote interface
public class ImplExample implements Hello {
// Implementing the interface method
public void printMsg() {
System.out.println("This is an example RMI program");
}
```

---

**Developing the Server Program**

An RMI server program should implement the remote interface or extend the implementation class. Here, we should create a remote object and bind it to the RMIregistry.

**To develop a server program:**

- Create a client class from where you want invoke the remote object.
- Create a remote object by instantiating the implementation class as shown below.
- Export the remote object using the method exportObject() of the class named UnicastRemoteObject which belongs to the package java.rmi.server.
- Get the RMI registry using the getRegistry() method of the LocateRegistry class which belongs to the package java.rmi.registry.
- Bind the remote object created to the registry using the bind() method of the class named Registry. To this method, pass a string representing the bind name and the object exported, as parameters.

---

**Following is an example of an RMI server program.**

```java
import java.rmi.registry.Registry;
import java.rmi.registry.LocateRegistry;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class Server extends ImplExample {
    public Server() {}
```

---

```java
    public static void main(String args[]) {
        try {
            // Instantiating the implementation class
            ImplExample obj = new ImplExample();
            // Exporting the object of implementation class
            // (here we are exporting the remote object to the stub)
            Hello stub = (Hello) UnicastRemoteObject.exportObject(obj, 0);
            // Binding the remote object (stub) in the registry
            Registry registry = LocateRegistry.getRegistry();
            registry.bind("Hello", stub);
            System.err.println("Server ready");
        } catch (Exception e) {
            System.err.println("Server exception: " + e.toString());
            e.printStackTrace();
        }
    }
}
```

---

**Developing the Client Program**

Write a client program in it, fetch the remote object and invoke the required method using this object.

To develop a client program:

- Create a client class from where your intended to invoke the remote object.
- Get the RMI registry using the getRegistry() method of the LocateRegistry class which belongs to the package java.rmi.registry.
- Fetch the object from the registry using the method lookup() of the class Registry which belongs to the package java.rmi.registry.
  To this method, you need to pass a string value representing the bind name as a parameter. This will return you the remote object.
- The lookup() returns an object of type remote, down cast it to the type Hello.
- Finally invoke the required method using the obtained remote object.

---

**Following is an example of an RMI client program.**

```java
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class Client {
    private Client() {}
    public static void main(String[] args) {
        try {
            // Getting the registry
            Registry registry = LocateRegistry.getRegistry(null);
            // Looking up the registry for the remote object
            Hello stub = (Hello) registry.lookup("Hello");
            // Calling the remote method using the obtained object
            stub.printMsg();
            // System.out.println("Remote method invoked");
        } catch (Exception e) {
            System.err.println("Client exception: " + e.toString());
            e.printStackTrace();
        }
    }
}
```

---

**Compiling the Application**

To compile the application:

- Compile the Remote interface.
- Compile the implementation class.
- Compile the server program.
- Compile the client program.

  ```sh
  javac *.java
  ```

---

**Executing the Application**

1. Start the rmi registry using the following command.

   ```sh
   rmiregistry
   ```

   This will start an rmi registry on a separate window.

2. Run the server class file as shown below.

   ```sh
   java Server
   ```

3. Run the client class ﬁle as shown below.

   ```sh
   java Client
   ```

---

**RMI Example:** Calculator Program

**Interface**

```java
public interface Calculator extends java.rmi.Remote {
    public long add(long a, long b) throws java.rmi.RemoteException;
    public long sub(long a, long b) throws java.rmi.RemoteException;
    public long mul(long a, long b) throws java.rmi.RemoteException;
    public long div(long a, long b) throws java.rmi.RemoteException;
}
```

---

```java
Interface Implementation:
public class CalculatorImpl extends
    java.rmi.server.UnicastRemoteObject implements Calculator {
    // Implementations must have an explicit constructor in order to declare the
    // RemoteException exception
    public CalculatorImpl() throws java.rmi.RemoteException {
        super();
    }
    public long add(long a, long b) throws java.rmi.RemoteException {
        return a + b;
    }
    public long sub(long a, long b) throws java.rmi.RemoteException {
        return a - b;
    }
    public long mul(long a, long b) throws java.rmi.RemoteException {
        return a * b;
    }
}
```

---

**Server Program:**

```java
import java.rmi.Naming;

public class CalculatorServer {
    public CalculatorServer() {
        try {
            Calculator c = new CalculatorImpl();
            Naming.rebind("rmi://localhost:1099/CalculatorService", c);
        } catch (Exception e) {
            System.out.println("Trouble: " + e);
        }
    }

    public static void main(String args[]) {
        new CalculatorServer();
    }
}
```

---

**Client Program:**

```java
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.net.MalformedURLException;
import java.rmi.NotBoundException;

public class CalculatorClient {
    public static void main(String[] args) {
        try {
            Calculator c = (Calculatr)Naming.lookup( "rmi://localhost/CalculatorService");
            System.out.println(c.sub(4, 3));
            System.out.println(c.add(4, 5));
            System.out.println(c.mul(3, 6));
            System.out.println(c.div(9, 3));
        }
        catch (MalformedURLException murle) {
            System.out.println();
            System.out.println("MalformedURLException");
            System.out.println(murle);
        }
```

---

```java
        catch (RemoteException re) {
            System.out.println();
            System.out.println("RemoteException");
            System.out.println(re);
        }
        catch (NotBoundException nbe) {
            System.out.println();
            System.out.println("NotBoundException");
            System.out.println(nbe);
        }
        catch (java.lang.ArithmeticException ae) {
            System.out.println();
            System.out.println("java.lang.ArithmeticException");
            System.out.println(ae);
        }
    }
}
```

### 4.9.2. RMI Security

The java application must first obtain information regarding its privileges.

It can obtain the security policy through a policy file.

Example, we allow Java code to have all permissions, the contains of the policy file policy.all is:

```java
grant {
    permission java.security.AllPermission;
};
```

Now, we given an example for assigning resource permissions:

```java
grant {
    permission java.io.filePermission "/tmp/*", "read","write";
    permission java.net.SocketPermission "host.domain.com:999","connect";
    permission java.net.SocketPermission "*:1024-65535","connect,request";
    permission java.net.SocketPermission "*:80","connect";
};
```

---

1. Allow the Java code to read/write any files only under the `/tmp` directory, includes any subdirectories.
2. Allow all java classes to establish a network connection with the host “host.domain.com” on port 999.
3. Allows classes to connection to or accept connections on unprivileged ports greater than 1024 , on any host.
4. Allows all classes to connect to the HTTP port 80 on any host.

If the text file containing our security policy is called (for example) policy.all, the original AdditionClient example might now be run as follows:

```sh
java –Djava.security.policy=policy.all AdditionClient
```

Alternatively this property can be set inside the program using

```java
System.setProperty().
```
