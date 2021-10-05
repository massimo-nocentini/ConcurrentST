Class {
	#name : #CSTChannel,
	#superclass : #Object,
	#instVars : [
		'loop'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannel class >> asynchronous: co [
	^ CSTChannelAsynchronous basicNew
		  coroutine: co;
		  initialize;
		  yourself
]

{ #category : #'as yet unclassified' }
CSTChannel class >> synchronous: co [
	^ CSTChannelSynchronous basicNew
		  coroutine: co;
		  initialize;
		  yourself
]

{ #category : #enumerating }
CSTChannel >> clone [
	^ self class basicNew
		  coroutine: loop;
		  initialize;
		  yourself
]

{ #category : #'as yet unclassified' }
CSTChannel >> coroutine: aCoroutine [
	loop := aCoroutine
]

{ #category : #'as yet unclassified' }
CSTChannel >> delay: outChannel init: anObject [
	loop
		repeat: [ :aMaybe | 
		aMaybe delay: outChannel init: anObject channel: self ]
		init: (Maybe just: anObject)
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
CSTChannel >> select: aBlock [
	| channel |
	channel := self clone.
	loop spawn: [ 
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
