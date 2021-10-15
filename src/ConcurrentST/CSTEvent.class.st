"
The representation of base-event values reflects the phases of a selective communica- tion. A base-event value is represented as a triple of functions: the pollFn tests an event to see if it is enabled, the doFn is used to execute an enabled event immediately, and the blockFn is used to log an event value. To support choice, we represent an event as a list, with one item per base event. Listing 10.15 gives the datatype declarations for this representation of event values. The bool ref argument to the blockFn is used to support unlogging in a lazy fashion.
"
Class {
	#name : #CSTEvent,
	#superclass : #CSTObject,
	#instVars : [
		'components'
	],
	#category : #ConcurrentST
}

{ #category : #adding }
CSTEvent >> addComponentsInEvent: anEvent [

	components do: [ :each | 
		anEvent
			poll: (self pollOf: each)
			do: (self doOf: each)
			block: (self blockOf: each) ]
]

{ #category : #initialization }
CSTEvent >> blockOf: aComponent [

	^ aComponent third
]

{ #category : #accessing }
CSTEvent >> components: anObject [

	components := anObject
]

{ #category : #initialization }
CSTEvent >> doOf: aComponent [

	^ aComponent second
]

{ #category : #initialization }
CSTEvent >> initialize [

	super initialize.

	self components: OrderedCollection new
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
				  components do: [ :each | 
					  (self blockOf: each) value: false -> thread ].
				  loop dispatch: thread ] ]
		  ifNotEmpty: [ :selectedComponents | 
		  (self doOf: selectedComponents anyOne) value ]
]

{ #category : #'instance creation' }
CSTEvent >> wrap: aBlock [

	| newComponents |
	newComponents := components collect: [ :each | 
		                 Array
			                 with: (self pollOf: each)
			                 with: [ aBlock value: (self doOf: each) value ]
			                 with: [ :anAssoc | 
				                 | v |
				                 v := loop withThreadDo: [ :thread | 
					                      (self blockOf: each) value:
						                      anAssoc key -> thread.
					                      Error signal: 'Never get here.' ].
				                 anAssoc value throw: (aBlock value: v) ] ].

	^ self class new
		  loop: loop;
		  components: newComponents;
		  yourself
]
