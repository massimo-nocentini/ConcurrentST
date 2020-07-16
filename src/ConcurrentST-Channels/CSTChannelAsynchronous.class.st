Class {
	#name : #CSTChannelAsynchronous,
	#superclass : #CSTChannel,
	#instVars : [
		'sendQueue',
		'receiveQueue'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #initialization }
CSTChannelAsynchronous >> initialize [
	super initialize.
	sendQueue := LeftistHeap empty.
	receiveQueue := LeftistHeap empty
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> receive [
	^ sendQueue isEmpty
		  ifTrue: [ 
			  co withThreadDo: [ :thread | 
				  receiveQueue := receiveQueue add: thread.
				  co dispatch: nil ] ]
		  ifFalse: [ 
			  | msg |
			  msg := sendQueue min.
			  sendQueue := sendQueue pop.
			  msg ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> send: msg [
	co withThreadDo: [ :thread | 
		co pushThread: thread.
		receiveQueue isEmpty
			ifTrue: [ 
				sendQueue := sendQueue add: msg.
				co dispatch: nil ]
			ifFalse: [ 
				| recvThread |
				recvThread := receiveQueue min.
				receiveQueue := receiveQueue pop.
				recvThread throw: msg ] ]
]
