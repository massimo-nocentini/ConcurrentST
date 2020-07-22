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
	signedMessage := co withThreadDo: [ :thread | 
		                 | signed |
		                 signed := thread digest: Object new.
		                 self pushThread: signed.
		                 co dispatch: signed ].
	^ signedMessage msg
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronousSelective >> remove: choices ids: ids signedMessage: signedMessage [
	| digest |
	digest := signedMessage digest.
	choices with: ids do: [ :aChannel :id | 
		id == digest
			ifTrue: [ aChannel throw: signedMessage msg ]
			ifFalse: [  ] ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronousSelective >> select: aCollectionOfChannels [
	| choices |
	choices := Array with: self withAll: aCollectionOfChannels.
	^ choices
		  detect: [ :aChannel | aChannel isSendQueueEmpty not ]
		  ifFound: [ :aChannel | aChannel popMessage ]
		  ifNone: [ 
			  | ids signedMessage |
			  ids := choices collect: [ :_ | Object new ].
			  signedMessage := co withThreadDo: [ :aThread | 
				                   self wait: choices ids: ids thread: aThread ].
			  self remove: choices ids: ids signedMessage: signedMessage ]
]

{ #category : #'as yet unclassified' }
CSTChannelAsynchronousSelective >> wait: choices ids: ids thread: aThread [
	choices
		with: ids
		do: [ :aChannel :id | self pushThread: (aThread digest: id) ].
	^ co dispatch: aThread
]
