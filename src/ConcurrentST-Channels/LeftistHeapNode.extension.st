Extension { #name : #LeftistHeapNode }

{ #category : #'*ConcurrentST-Channels' }
LeftistHeapNode >> receiveOnChannel: aChannel [
	^ aChannel receiveOnNonEmptyQueue: self
]
