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
	^ sendQueue receiveOnChannel: self
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> receiveOnEmptyQueue: aQueue [
	^ co withThreadDo: [ :thread | 
		  self pushThread: thread.
		  co dispatch: thread ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> receiveOnNonEmptyQueue: aQueue [
	^ self popMessage
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> send: msg [
	co withThreadDo: [ :thread | 
		co pushThread: thread.
		receiveQueue isEmpty
			ifTrue: [ 
				self pushMessage: msg.
				co dispatch: thread ]
			ifFalse: [ self popThread throw: msg ] ]
]
