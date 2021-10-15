Class {
	#name : #CSTChannelWithEvent,
	#superclass : #CSTChannelAsynchronous,
	#instVars : [
		'event'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #accessing }
CSTChannelWithEvent >> event: anObject [

	event := anObject
]

{ #category : #'as yet unclassified' }
CSTChannelWithEvent >> pollQueue: aQueue [

	^ aQueue ifEmpty: [ false ] ifNotEmpty: [ 
		  aQueue head key
			  ifTrue: [ 
				  aQueue pop.
				  self pollQueue: aQueue ]
			  ifFalse: [ true ] ]
]

{ #category : #'as yet unclassified' }
CSTChannelWithEvent >> receive [

	^ event
		  poll: [ self pollQueue: sendQueue ] do: [ 
			  | assoc |
			  assoc := sendQueue pop.
			  assoc key: true.
			  loop pushThread: assoc value thread.
			  assoc value msg ]
		  block: [ :anAssoc | receiveQueue push: anAssoc ];
		  yourself
]

{ #category : #'as yet unclassified' }
CSTChannelWithEvent >> send: msg [

	^ event
		  poll: [ self pollQueue: receiveQueue ] do: [ 
			  loop withThreadDo: [ :thread | 
					  | assoc |
					  assoc := receiveQueue pop.
					  assoc key: true.
					  loop pushThread: thread.
					  assoc value throw: msg ] ]
		  block: [ :anAssoc | 
			  sendQueue push: anAssoc key -> (CSTMessageWithThread new
							   msg: msg;
							   thread: anAssoc value;
							   yourself) ];
		  yourself
]
