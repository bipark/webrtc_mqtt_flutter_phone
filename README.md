# Flutter WebRTC Phone 

Using a MQTT client and a Flutter, an example source of WebRTC bidirectional video communication.

## WebRTC

WebRTC를 이용한 화상/데이터 통신은 기본적으로 시그널 서버가 필요하다. 일반적으로 Websocket을 많이 사용하는데 서버는 클라이언트에서 전송되는 SDP, Candidate를 릴레이 하여 클라이언트가 연결할 상대방의 IP와 Port 정보를 주고 받은 다음 받은 정보를 이용하여 P2p 접속을 시도한다.

WebRTC image/data transmission necessitates the use of a signal server. Websocket is commonly used, however the server relays SDP and Candidate from the client to exchange port information with the other party's IP to which the client will connect, and then tries to connect to P2P using the received information.

## MQTT

MQTT는 발행/구독 기반으로 일대일, 일대다 데이터 통신에 적합하고 구독 채널을 트리구조로 구성 할 수 있기 때문에 Websocket에서 채팅방-서브 채팅방을 구현하는 기능을 아주 간단하게 구현 할 수 있다.

MQTT is suitable for one-to-one and one-to-many data communication based on issuance/subscription, and it can configure subscription channels in a tree structure, making chatroom-subchatroom in websocket very simple to implement.

## IDEA

WebRTC 화상통신앱을 만들며 처음부터 이 생각을 했다. WebSocket으로 채팅방을 만들지 않고 MQTT를 이용하면 안될까? Mosquitto 서버라면 보안성 문제도 쉽게 해결 할 수 있고 성능도 우수한 시그널 서버로 활용할 수 있지 않을까? 그래서 한번 해봤다.

While developing a WebRTC video communication software, I had this in mind from the start. Is it possible to use MQTT without using WebSocket to create a chat room? Wouldn't Mosquitto servers be able to simply overcome security issues and function as high-performance signal servers? So I gave it a shot.

![](http://practical.kr/wp-content/uploads/2021/12/1638688086230-1.jpg)

결론적으로 이 프로젝트에서 WebRTC 통신을 하기 위한 시그널 서버는 만들지않았다.

Finally, no signal server for WebRTC communication was established in this project.

## ETCS

P2p연결을 위해 Google Stun 서버를 사용하며 3G, LTE에서 연결이 되지 않을수도 있다. Stun 서버를 통한 P2p 연결이 불가능한 경우는 Turn 서버를 개별적으로 설치하고 운영해야 하는데 오픈소스인 Coturn을 활용하여 운용이 가능하다. WebRTC와 관련한 코드는 시그널 기능에 따른 많은 코드들이 요구되지만 셈플에서는 가장 기본적인 통신 기능만을 구현 했다.

For P2P connections, a Google Stun server is utilized, which may or may not be connected through 3G or LTE. If a P2P connection through the Stun server is not available, the Turn server must be installed and operated separately, however it can be done with the open source Coturn.
WebRTC code necessitates a large number of codes depending on the signal function, but the sample only performed the most basic communication function.

[http://practical.kr/?p=521](http://practical.kr/?p=521)