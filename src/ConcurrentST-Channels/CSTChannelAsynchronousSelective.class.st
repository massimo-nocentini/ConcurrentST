Class {
	#name : #CSTChannelAsynchronousSelective,
	#superclass : #CSTChannelAsynchronous,
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannelAsynchronousSelective >> receiveFromEmptySendQueue [
	| signedMessage |
	signedMessage := co withThreadDo: [ :thread | 
		                 | signed |
		                 signed := thread digest: Object new.
		                 self pushThread: signed.
		                 co dispatch: signed ].
	^ signedMessage msg
]
