Extension { #name : #LeftistHeapEmpty }

{ #category : #'*ConcurrentST-Channels' }
LeftistHeapEmpty >> receiveFromSendQueueOnChannel: aChannel [
	^ aChannel receiveFromEmptySendQueue
]

{ #category : #'*ConcurrentST-Channels' }
LeftistHeapEmpty >> send: msg toReceiveQueueOnChannel: aChannel [
	^ aChannel sendToEmptyReceiveQueue: msg
]
