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

	^ CSTChannelWithEvent new
		  loop: loop;
		  event: (CSTEvent new
				   loop: loop;
				   yourself);
		  yourself
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
		| channels ev assoc |
		channels := { 
			            (self event receive wrap: [ :a | a -> aChannel receive ]).
			            (aChannel event receive wrap: [ :a | a -> self receive ]) }.

		ev := loop choose: channels.

		assoc := ev sync.

		oChannel send: assoc key + assoc value ]
]

{ #category : #'as yet unclassified' }
CSTChannel >> zipChannels: aCollectionOfChannels with: aBlock on: oChannel [

	loop repeat: [ 
		| channels v |
		channels := Array with: self withAll: aCollectionOfChannels.
		
		channels collect: [ :each  ].
		
		v := aBlock valueWithArguments: channels.
		oChannel send: v ]
]
