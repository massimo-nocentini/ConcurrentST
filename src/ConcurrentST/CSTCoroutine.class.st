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
	^ self spawn: aBlock exceptionHandler: [ self ]
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock exceptionHandler: hBlock [
	^ Continuation currentDo: [ :parentK | 
		  | thread d |
		  thread := self threadForContinuation: parentK.
		  self pushThread: thread.
		  d := aBlock
			       on: Exception
			       do: hBlock.
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
