Class {
	#name : #CSTChannelWithEvent,
	#superclass : #CSTChannelAsynchronous,
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannelWithEvent >> pollQueue: aQueue [

	^ aQueue ifEmpty: [ false ] ifNotEmpty: [ 
		  aQueue head key content
			  ifTrue: [ 
				  aQueue pop.
				  self pollQueue: aQueue ]
			  ifFalse: [ true ] ]
]

{ #category : #'as yet unclassified' }
CSTChannelWithEvent >> receive [

	^ loop event
		  poll: [ self pollQueue: sendQueue ] do: [ 
			  | assoc |
			  assoc := sendQueue pop.
			  assoc key content: true.
			  loop pushThread: assoc value thread.
			  assoc value msg ]
		  block: [ :anAssoc | receiveQueue push: anAssoc ];
		  yourself
]

{ #category : #'as yet unclassified' }
CSTChannelWithEvent >> send: msg [

	^ loop event
		  poll: [ self pollQueue: receiveQueue ] do: [ 
			  loop withThreadDo: [ :thread | 
					  | assoc |
					  assoc := receiveQueue pop.
					  assoc key content: true.
					  loop pushThread: thread.
					  assoc value throw: msg ] ]
		  block: [ :anAssoc | 
			  sendQueue push: anAssoc key -> (CSTMessageWithThread new
							   msg: msg;
							   thread: anAssoc value;
							   yourself) ];
		  yourself
]
