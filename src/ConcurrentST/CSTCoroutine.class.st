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

{ #category : #initialization }
CSTCoroutine >> yield: aValue [
	^ Continuation currentDo: [ :k | 
		  | thread |
		  thread := CSTThread new
			            continuation: k;
			            yourself.
		  self
			  pushThread: thread;
			  dispatch: aValue ]
]
