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

{ #category : #accessing }
CSTChannel >> next [
	^ self next: 1
]

{ #category : #accessing }
CSTChannel >> next: n [
	^ (1 to: n) collect: [ :_ | self receive ]
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
		(aBlock value: i) ifTrue: [ self halt. channel send: i ] ] repeat ].
	^ channel
]

{ #category : #'as yet unclassified' }
CSTChannel >> send: anObject [
	self subclassResponsibility
]
