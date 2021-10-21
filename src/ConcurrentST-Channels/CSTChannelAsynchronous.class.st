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
CSTChannelAsynchronous >> pollMessages [

	^ self pollQueue: sendQueue
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> pollQueue: aQueue [

	^ aQueue ifEmpty: [ false ] ifNotEmpty: [ 
		  aQueue head key content
			  ifTrue: [ 
				  aQueue pop.
				  self pollQueue: aQueue ]
			  ifFalse: [ true ] ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> pollThreads [

	^ self pollQueue: receiveQueue
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

	^ loop withThreadDo: [ :thread | 
		  self pushThread: thread.
		  loop dispatchThread: thread ]
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

	loop withThreadDo: [ :thread | 
		loop pushThread: thread.
		self pushMessage: msg.
		loop dispatchThread: thread ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> sendToNonEmptyReceiveQueue: msg [
	loop withThreadDo: [ :thread | 
		loop pushThread: thread.
		self popThread throw: msg ]
]
