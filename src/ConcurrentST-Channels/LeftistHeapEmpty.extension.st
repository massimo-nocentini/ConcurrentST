Extension { #name : #LeftistHeapEmpty }

{ #category : #'*ConcurrentST-Channels' }
LeftistHeapEmpty >> receiveOnChannel: aChannel [
	^ aChannel receiveOnEmptyQueue: self
]
