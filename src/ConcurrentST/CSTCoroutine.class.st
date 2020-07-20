Class {
	#name : #CSTCoroutine,
	#superclass : #Object,
	#instVars : [
		'readyQueue',
		'thread_id'
	],
	#category : #ConcurrentST
}

{ #category : #'as yet unclassified' }
CSTCoroutine class >> block: aFullBlockClosure [
	^ aFullBlockClosure value: self new
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> asynchronousChannel [
	^ CSTChannel asynchronous: self
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> channel [
	^ CSTChannel synchronous: self
]

{ #category : #initialization }
CSTCoroutine >> dispatch: aValue [
	^ self popThread throw: aValue
]

{ #category : #initialization }
CSTCoroutine >> initialize [
	super initialize.
	readyQueue := LeftistHeap empty.
	thread_id := 0
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
	^ self spawn: aBlock on: Exception do: [ :e | e traceCr ]
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock on: aClass do: hBlock [
	^ self withThreadDo: [ :thread | 
		  self pushThread: thread.
		  "aBlock
			  on: aClass
			  do: hBlock."
		  aBlock ensure: [ self dispatch: thread ] ]
]

{ #category : #enumerating }
CSTCoroutine >> withThreadDo: aBlock [
	^ Continuation currentDo: [ :k | 
		  | thread |
		  thread_id := thread_id + 1.
		  thread := CSTThread new
			            id: thread_id;
			            continuation: k;
			            yourself.
		  aBlock value: thread ]
]

{ #category : #initialization }
CSTCoroutine >> yield: aValue [
	^ self withThreadDo: [ :thread | 
		  self
			  pushThread: thread;
			  dispatch: aValue ]
]
