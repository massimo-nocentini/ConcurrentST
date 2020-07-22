Class {
	#name : #CSTChannelAsynchronousSelective,
	#superclass : #CSTChannelAsynchronous,
	#category : #'ConcurrentST-Channels'
}

{ #category : #testing }
CSTChannelAsynchronousSelective >> isSendQueueEmpty [
	^ sendQueue isEmpty
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronousSelective >> receiveFromEmptySendQueue [
	| signedMessage |
	self halt.
	signedMessage := co withThreadDo: [ :thread | 
		                 | signed |
		                 signed := thread digest: Object new.
		                 self pushThread: signed.
		                 co dispatch: signed ].
	^ signedMessage msg
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronousSelective >> zip: aChannel with: aBlock output: outChannel [
	| selected |
	selected := [ :a | aBlock value: a value: aChannel receive ] <- self
	            |
	            ([ :a | aBlock value: self receive value: a ] <- aChannel).
	outChannel send: selected
]
