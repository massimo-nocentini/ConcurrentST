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

{ #category : #'as yet unclassified' }
CSTEventWithChannel >> tee: aCollectionOfChannels [

	^ self receive wrap: [ :v | 
		  | events |
		  events := aCollectionOfChannels withIndexCollect: [ :each :i | 
			            (each event send: v) wrap: [ :useless | 
				            | block pool |
				            pool := IdentitySet new.
				            block := [ :j | 
				                     | w |
				                     w := nil.
				                     w := ((aCollectionOfChannels at: j) event 
					                           send: v) wrap: [ :_ | pool remove: w ].
				                     pool add: w ].

				            1 to: i - 1 do: block.
				            i + 1 to: aCollectionOfChannels size do: block.

				            [ pool isEmpty ] whileFalse: [ 
					            (loop event choose: pool) sync ] ] ].

		  (loop event choose: events) sync.

		  v ]
]

{ #category : #'as yet unclassified' }
CSTEventWithChannel >> zipChannels: aCollectionOfChannels with: aBlock on: oChannel [

	| pool args |
	pool := IdentitySet new.

	args := Array new: aCollectionOfChannels size.

	aCollectionOfChannels withIndexDo: [ :each :i | 
		| ev |
		ev := nil.
		ev := each event receive wrap: [ :v | 
			      pool remove: ev.
			      args at: i put: v ].
		pool add: ev ].

	[ pool isNotEmpty ] whileTrue: [ (self event choose: pool) sync ].

	^ oChannel event send: (aBlock valueWithArguments: args)
]
