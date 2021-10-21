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

{ #category : #'as yet unclassified' }
CSTEventWithChannel >> receive [

	^ loop event
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

	^ loop event
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