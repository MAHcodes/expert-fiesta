I.

1. What is the purpose of the PUT http method?
a. To create a new resource or replace an existing resource completely.
b. To submit data to a server to create a new resource.
c. To retrieve data from a server.
d. To delete a resource from the server.

2. Middleware operates between
a. Clients and servers
b. Databases and servers
c. Operating systems and applications
d. All of the above

3. What is the three-way handshake used for in TCP communication?
a. To encrypt the data being transmitted
b. To authenticate the client and server
c. To establish a reliable connection between the client and server
d. To send and receive data packets

4. Which type of socket is more reliable for data transfer between clients and servers?
a. Datagram sockets (UDP)
b. Stream sockets (TCP)
c. Both UDP and TCP are equally reliable
d. Depends on the specific application requirements

5. What is the correct way to create an InetAddress object for the IP address 192.168.1.100?
a. InetAddress addr = InetAddress.getByName("192.168.1.100");
b. InetAddress addr = InetAddress.getByAddress("192.168.1.100");
c. InetAddress addr = new InetAddress("192.168.1.100");
d. InetAddress addr = InetAddress.getLocalHost("192.168.1.100");

6. How does a server distinguish between multiple clients connecting to the same port?
a. It relies on the client's port number
b. It relies on the client's IP address
c. It uses the combination of client IP address and source port number
d. It requires the client to identify itself in the message

7. Which of the following was the main technology used in the first generation of client-server architecture?
a. Database servers
b. Personal computers and file servers
c. Mainframes and dumb terminals
d. Web servers

8. Why is the server considered a weak link in client-server architecture?
a. It is often the target of cyberattacks
b. Its performance can bottleneck the entire network
c. If it fails, the entire network is affected
d. It requires regular maintenance and updates

9. In what environment does the called remote procedure execute?
a. Within the environment of the calling process
b. Within the environment of the server process
c. In a shared memory space between the client and server
d. In a virtual machine environment independent of the client and server

10. What does the acronym URN stand for in the context of computer networks?
a. Universal Resource Number
b. Uniform Resource Node
c. Unified Record Name
d. Uniform Resource Name

II.

1. List four differences between TCP and UDP protocols. (1 point)
2. Define RPC (Remote Procedure Call), explain briefly how it works. (1 point)
3. Explain how middleware acts between client and server, and discuss three benefits (features) of it. (1.5 points)
4. Explain how does TCP establish connection between the client and the server, describe each step of the three-way handshake. (1.5 point)

III.

Write a JAVA program that implements a Server and client communication using Sockets. Create a server socket listening to port 6789 and when a client connect it accepts the connection and replies a capitalized one of the message sent from client. (5 points)
