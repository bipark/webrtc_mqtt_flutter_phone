# Flutter WebRTC Phone 

Using a MQTT client and a Flutter, an example source of WebRTC bidirectional video communication.

## WebRTC

WebRTC image/data transmission necessitates the use of a signal server. Websocket is commonly used, however the server relays SDP and Candidate from the client to exchange port information with the other party's IP to which the client will connect, and then tries to connect to P2P using the received information.

## MQTT

MQTT is suitable for one-to-one and one-to-many data communication based on issuance/subscription, and it can configure subscription channels in a tree structure, making chatroom-subchatroom in websocket very simple to implement.

## IDEA

While developing a WebRTC video communication software, I had this in mind from the start. Is it possible to use MQTT without using WebSocket to create a chat room? Wouldn't Mosquitto servers be able to simply overcome security issues and function as high-performance signal servers? So I gave it a shot.

![](http://practical.kr/wp-content/uploads/2021/12/1638688086230-1.jpg)

Finally, no signal server for WebRTC communication was established in this project.

## ETCS

For P2P connections, a Google Stun server is utilized, which may or may not be connected through 3G or LTE. If a P2P connection through the Stun server is not available, the Turn server must be installed and operated separately, however it can be done with the open source Coturn.
WebRTC code necessitates a large number of codes depending on the signal function, but the sample only performed the most basic communication function.