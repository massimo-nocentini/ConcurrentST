Class {
	#name : #CSTCoroutine,
	#superclass : #Object,
	#instVars : [
		'readyQueue'
	],
	#category : #ConcurrentST
}

{ #category : #'as yet unclassified' }
CSTCoroutine class >> block: aFullBlockClosure [
	^ aFullBlockClosure value: self new
]

{ #category : #initialization }
CSTCoroutine >> dispatch: aValue [
	^ self popThread continuation value: aValue
]

{ #category : #initialization }
CSTCoroutine >> initialize [
	super initialize.
	readyQueue := LeftistHeap empty
]

{ #category : #initialization }
CSTCoroutine >> popThread [
	| thread |
	thread := readyQueue min.
	readyQueue := readyQueue pop.
	^ thread
]

{ #category : #initialization }
CSTCoroutine >> pushThread: aThread [
	readyQueue := readyQueue add: aThread
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock [
	^ Continuation currentDo: [ :parentK | 
		  | thread v o d |
		  thread := self threadForContinuation: parentK.
		  self pushThread: thread.
		  o := Object new.
		  v := aBlock ensure: [ o ].
		  d := v == o
			       ifTrue: [ self ]
			       ifFalse: [ v ].
		  self dispatch: d ]
]

{ #category : #initialization }
CSTCoroutine >> threadForContinuation: k [
	^ CSTThread new
		  id: Random new next;
		  continuation: k;
		  yourself
]

{ #category : #initialization }
CSTCoroutine >> yield: aValue [
	^ Continuation currentDo: [ :k | 
		  | thread |
		  thread := self threadForContinuation: k.
		  self
			  pushThread: thread;
			  dispatch: aValue ]
]
