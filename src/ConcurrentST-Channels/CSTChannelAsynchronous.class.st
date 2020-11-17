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
	sendQueue := CTLinkedStoragePool queue new.
	receiveQueue := CTLinkedStoragePool queue new
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> popMessage [
	^ sendQueue pop
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> popThread [
	^ receiveQueue pop
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> pushMessage: msg [
	sendQueue push: msg
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> pushThread: thread [
	receiveQueue push: thread
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> receive [
	^ sendQueue
		  ifEmpty: [ self receiveFromEmptySendQueue ]
		  ifNotEmpty: [ self receiveFromNonEmptySendQueue ]
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
	receiveQueue
		ifEmpty: [ self sendToEmptyReceiveQueue: msg ]
		ifNotEmpty: [ self sendToNonEmptyReceiveQueue: msg ]
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
