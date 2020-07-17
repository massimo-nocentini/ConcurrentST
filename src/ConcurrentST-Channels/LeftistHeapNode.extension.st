Extension { #name : #LeftistHeapNode }

{ #category : #'*ConcurrentST-Channels' }
LeftistHeapNode >> receiveFromSendQueueOnChannel: aChannel [
	^ aChannel receiveFromNonEmptySendQueue
]

{ #category : #'*ConcurrentST-Channels' }
LeftistHeapNode >> send: msg toReceiveQueueOnChannel: aChannel [
	^ aChannel sendToNonEmptyReceiveQueue: msg
]
