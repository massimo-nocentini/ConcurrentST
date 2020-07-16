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
			  Continuation currentDo: [ :k | 
				  | thread |
				  thread := co threadForContinuation: k.
				  receiveQueue := receiveQueue add: thread.
				  co dispatch: nil ] ]
		  ifFalse: [ 
			  | msg |
			  msg := sendQueue min.
			  sendQueue := sendQueue pop.
			  msg ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronous >> send: anObject [
	receiveQueue isEmpty
		ifTrue: [ sendQueue := sendQueue add: anObject ]
		ifFalse: [ 
			co withThreadDo: [ 
				| thread |
				thread := receiveQueue min.
				receiveQueue := receiveQueue pop.
				thread continuation value: anObject ] ]
]
