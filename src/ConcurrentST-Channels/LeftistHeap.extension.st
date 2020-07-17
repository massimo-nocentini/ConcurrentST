Extension { #name : #LeftistHeap }

{ #category : #'*ConcurrentST-Channels' }
LeftistHeap >> receiveFromSendQueueOnChannel: aChannel [
	self subclassResponsibility
]

{ #category : #'*ConcurrentST-Channels' }
LeftistHeap >> send: msg toReceiveQueueOnChannel: aChannel [
	self subclassResponsibility
]
