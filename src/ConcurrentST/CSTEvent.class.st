"
The representation of base-event values reflects the phases of a selective communica- tion. A base-event value is represented as a triple of functions: the pollFn tests an event to see if it is enabled, the doFn is used to execute an enabled event immediately, and the blockFn is used to log an event value. To support choice, we represent an event as a list, with one item per base event. Listing 10.15 gives the datatype declarations for this representation of event values. The bool ref argument to the blockFn is used to support unlogging in a lazy fashion.
"
Class {
	#name : #CSTEvent,
	#superclass : #CSTObject,
	#instVars : [
		'components',
		'syncRandom'
	],
	#category : #ConcurrentST
}

{ #category : #adding }
CSTEvent >> addComponentsInEvent: anEvent [

	components do: [ :each | 
		anEvent
			poll: (self pollOf: each)
			do: (self doOf: each)
			block: (self blockOf: each) ].

	^ anEvent
]

{ #category : #'as yet unclassified' }
CSTEvent >> always: anObject [

	^ self event
		  poll: [ true ]
		  do: [ anObject ]
		  block: [ :anAssoc :aWitness | aWitness ];
		  yourself
]

{ #category : #initialization }
CSTEvent >> blockOf: aComponent [

	^ aComponent third
]

{ #category : #accessing }
CSTEvent >> channel: aChannel [

	^ CSTEventWithChannel new
		  loop: loop;
		  channel: aChannel;
		  yourself
]

{ #category : #events }
CSTEvent >> choose: events [

	^ events
		  inject: self event
		  into: [ :ev :each | each addComponentsInEvent: ev ]
]

{ #category : #initialization }
CSTEvent >> doOf: aComponent [

	^ aComponent second
]

{ #category : #'as yet unclassified' }
CSTEvent >> event [

	^ loop event
]

{ #category : #'as yet unclassified' }
CSTEvent >> guard: aBlock [

	^ self event
		  poll: [ true ]
		  do: [ aBlock value sync ]
		  block: [ :anAssoc :aWitness | aWitness ];
		  yourself
]

{ #category : #initialization }
CSTEvent >> initialize [

	super initialize.

	syncRandom := Random seed: 541.
	components := OrderedCollection new
]

{ #category : #'events construction' }
CSTEvent >> never [

	^ self event
]

{ #category : #initialization }
CSTEvent >> poll: pBlock do: dBlock block: aBlock [

	"Here we fix the ordering to represent base events."

	components add: { 
			pBlock.
			dBlock.
			aBlock }
]

{ #category : #initialization }
CSTEvent >> pollOf: aComponent [

	^ aComponent first
]

{ #category : #public }
CSTEvent >> sync [

	^ (components select: [ :each | (self pollOf: each) value ])
		  ifEmpty: [ 
			  loop withThreadDo: [ :thread | 
				  | ref witness |
				  ref := Maybe just: false.
				  witness := Object new.
				  components do: [ :each | 
					  (self blockOf: each) value: ref -> thread value: witness ].

				  loop dispatchThread: thread ] ]
		  ifNotEmpty: [ :selectedComponents | 
			  (self doOf: (selectedComponents shuffleBy: syncRandom) anyOne)
				  value ]
]

{ #category : #'instance creation' }
CSTEvent >> wrap: aBlock [

	| ev |
	ev := self event.

	components do: [ :each | 
		ev
			poll: (self pollOf: each)
			do: [ aBlock value: (self doOf: each) value ]
			block: [ :anAssoc :aWitness | 
				| v |
				v := loop withThreadDo: [ :thread | 
					     (self blockOf: each)
						     value: anAssoc key -> thread
						     value: aWitness ].

				v == aWitness
					ifTrue: [ v ]
					ifFalse: [ anAssoc value throw: (aBlock value: v) ] ] ].

	^ ev
]
