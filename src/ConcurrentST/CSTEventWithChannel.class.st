"
I am a variant that collaborates with a channel.
"
Class {
	#name : #CSTEventWithChannel,
	#superclass : #CSTEvent,
	#instVars : [
		'channel'
	],
	#category : #ConcurrentST
}

{ #category : #accessing }
CSTEventWithChannel >> channel: anObject [

	channel := anObject
]

{ #category : #accessing }
CSTEventWithChannel >> event [

	^ super event channel: channel
]

{ #category : #'as yet unclassified' }
CSTEventWithChannel >> poll [

	^ self event choose: { 
			  (loop event always: Maybe nothing).
			  (self receive wrap: [ :anObj | Maybe just: anObj ]) }
]

{ #category : #'as yet unclassified' }
CSTEventWithChannel >> receive [

	^ self event
		  poll: [ channel pollMessages ] do: [ 
			  | assoc |
			  assoc := channel popMessage.
			  assoc key content: true.
			  loop pushThread: assoc value thread.
			  assoc value msg ]
		  block: [ :anAssoc | channel pushThread: anAssoc ];
		  yourself
]

{ #category : #'as yet unclassified' }
CSTEventWithChannel >> send: msg [

	^ self event
		  poll: [ channel pollThreads ] do: [ 
			  loop withThreadDo: [ :thread | 
					  | assoc |
					  assoc := channel popThread.
					  assoc key content: true.
					  loop pushThread: thread.
					  assoc value throw: msg ] ]
		  block: [ :anAssoc | 
			  channel pushMessage: anAssoc key -> (CSTMessageWithThread new
							   msg: msg;
							   thread: anAssoc value;
							   yourself) ];
		  yourself
]

{ #category : #'as yet unclassified' }
CSTEventWithChannel >> swap: anObject channel: inChannel [

	^ self guard: [ 
		  loop event choose: { 
				  (channel event receive wrap: [ :anAssoc | 
					   anAssoc value send: anObject.
					   anAssoc key ]).
				  ((channel event send: anObject -> inChannel) wrap: [ :useless | 
					   inChannel receive ]) } ]
]
