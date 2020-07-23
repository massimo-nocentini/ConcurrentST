Class {
	#name : #CSTChannel,
	#superclass : #Object,
	#instVars : [
		'co'
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
		  coroutine: co;
		  initialize;
		  yourself
]

{ #category : #'as yet unclassified' }
CSTChannel >> coroutine: aCoroutine [
	co := aCoroutine
]

{ #category : #'as yet unclassified' }
CSTChannel >> delay: outChannel init: anObject [
	co
		repeat: [ :aMaybe | 
		aMaybe delay: outChannel init: anObject channel: self ]
		init: anObject
]

{ #category : #accessing }
CSTChannel >> next [
	^ self next: 1
]

{ #category : #accessing }
CSTChannel >> next: n [
	^ (1 to: n) collect: [ :_ | self receive ]
]

{ #category : #accessing }
CSTChannel >> next: n on: aStream [
	n timesRepeat: [ aStream nextPut: self receive ]
]

{ #category : #'as yet unclassified' }
CSTChannel >> receive [
	self subclassResponsibility
]

{ #category : #enumerating }
CSTChannel >> select: aBlock [
	| channel |
	channel := self clone.
	co spawn: [ 
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
	co repeat: [ 
		| v |
		v := self receive.
		aCollectionOfChannels do: [ :aChannel | aChannel send: v ] ]
]

{ #category : #'as yet unclassified' }
CSTChannel >> zip: aCollectionOfChannels with: aBlock output: oChannel [
	co repeat: [ 
		| args v |
		args := Array
			        with: self receive
			        withAll:
			        (aCollectionOfChannels collect: [ :aChannel | 
				         aChannel receive ]).
		v := aBlock valueWithArguments: args.
		oChannel send: v ]
]
