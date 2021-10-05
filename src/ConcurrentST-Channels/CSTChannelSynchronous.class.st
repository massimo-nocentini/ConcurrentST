Class {
	#name : #CSTChannelSynchronous,
	#superclass : #CSTChannelAsynchronous,
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannelSynchronous >> receiveFromNonEmptySendQueue [
	| synchronousMessage |
	synchronousMessage := self popMessage.
	loop pushThread: synchronousMessage thread.
	^ synchronousMessage msg
]

{ #category : #'as yet unclassified' }
CSTChannelSynchronous >> sendToEmptyReceiveQueue: msg [
	loop withThreadDo: [ :thread | 
		self pushMessage: (CSTMessageWithThread new
				 msg: msg;
				 thread: thread;
				 yourself).
		loop dispatch: thread ]
]
