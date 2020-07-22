Class {
	#name : #CSTChannelSynchronous,
	#superclass : #CSTChannelAsynchronous,
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannelSynchronous >> receiveFromNonEmptySendQueue [
	| synchronousMessage |
	synchronousMessage := self popMessage.
	co pushThread: synchronousMessage thread.
	^ synchronousMessage msg
]

{ #category : #'as yet unclassified' }
CSTChannelSynchronous >> sendToEmptyReceiveQueue: msg [
	co withThreadDo: [ :thread | 
		self pushMessage: (CSTMessageWithThread new
				 msg: msg;
				 thread: thread;
				 yourself).
		co dispatch: thread ]
]
