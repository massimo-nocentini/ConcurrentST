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
CSTChannelAsynchronous >> popMessage [
	| msg |
	msg := sendQueue min.
	sendQueue := sendQueue pop.
	^ msg
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> popThread [
	| recvThread |
	recvThread := receiveQueue min.
	receiveQueue := receiveQueue pop.
	^ recvThread
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> pushMessage: msg [
	sendQueue := sendQueue add: msg
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> pushThread: thread [
	receiveQueue := receiveQueue add: thread
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> receive [
	^ sendQueue receiveFromSendQueueOnChannel: self
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> receiveFromEmptySendQueue [
	^ co withThreadDo: [ :thread | 
		  self pushThread: thread.
		  co dispatch: thread ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> receiveFromNonEmptySendQueue [
	^ self popMessage
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> send: msg [
	receiveQueue send: msg toReceiveQueueOnChannel: self
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> sendToEmptyReceiveQueue: msg [
	co withThreadDo: [ :thread | 
		co pushThread: thread.
		self pushMessage: msg.
		co dispatch: thread ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> sendToNonEmptyReceiveQueue: msg [
	co withThreadDo: [ :thread | 
		co pushThread: thread.
		self popThread throw: msg ]
]
