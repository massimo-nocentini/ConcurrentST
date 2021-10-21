Class {
	#name : #CSTChannel,
	#superclass : #CSTObject,
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannel >> delay: outChannel init: anObject [
	loop
		repeat: [ :aMaybe | 
		aMaybe delay: outChannel init: anObject channel: self ]
		init: (Maybe just: anObject)
]

{ #category : #accessing }
CSTChannel >> event [

	^ loop event channel: self
]

{ #category : #'stream protocol' }
CSTChannel >> next [
	^ self receive
]

{ #category : #'stream protocol' }
CSTChannel >> next: n [
	^ (1 to: n) collect: [ :_ | self next ]
]

{ #category : #'stream protocol' }
CSTChannel >> next: n on: aStream [
	n timesRepeat: [ aStream nextPut: self receive ]
]

{ #category : #'stream protocol' }
CSTChannel >> nextPut: anObject [
	^ self send: anObject
]

{ #category : #'as yet unclassified' }
CSTChannel >> receive [
	self subclassResponsibility
]

{ #category : #enumerating }
CSTChannel >> select: aBlock on: channel [

	loop spawnPreemptive: [ 
		[ 
		| i |
		i := self receive.
		(aBlock value: i) ifTrue: [ channel send: i ] ] repeat ].

	^ channel
]

{ #category : #'as yet unclassified' }
CSTChannel >> send: anObject [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
CSTChannel >> tee: aCollectionOfChannels [
	loop repeat: [ 
		| v |
		v := self receive.
		aCollectionOfChannels do: [ :aChannel | aChannel send: v ] ]
]

{ #category : #'as yet unclassified' }
CSTChannel >> zip: aChannel with: aBlock on: oChannel [

	loop repeat: [ 
		| events assoc |
		events := { 
			          ((loop event channel: self) receive wrap: [ :a | 
				           (loop event channel: aChannel) receive wrap: [ :b | 
					           Array with: a with: b ] ]).
			          ((loop event channel: aChannel) receive wrap: [ :a | 
				           (loop event channel: self) receive wrap: [ :b | 
					           Array with: a with: b ] ]) }.

		assoc := (loop choose: events) sync.

		oChannel send: (aBlock valueWithArguments: assoc) ]
]

{ #category : #'as yet unclassified' }
CSTChannel >> zipChannels: aCollectionOfChannels with: aBlock on: oChannel [

	loop repeat: [ 
		| args v |
		args := Array
			        with: self receive
			        withAll:
			        (aCollectionOfChannels collect: [ :aChannel | 
				         aChannel receive ]).
		v := aBlock valueWithArguments: args.
		oChannel send: v ]
]
