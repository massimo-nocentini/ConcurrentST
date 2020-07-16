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
CSTCoroutine >> channel [
	^ CSTChannel asynchronous: self
]

{ #category : #initialization }
CSTCoroutine >> dispatch: aValue [
	^ self popThread continuation value: aValue
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
	thread_id := thread_id - 1.
	thread := readyQueue min.
	readyQueue := readyQueue pop.
	^ thread
]

{ #category : #initialization }
CSTCoroutine >> pushThread: aThread [
	readyQueue := readyQueue add: aThread.
	thread_id := thread_id + 1
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock [
	^ self spawn: aBlock on: Exception do: [ self ]
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock on: aClass do: hBlock [
	^ Continuation currentDo: [ :parentK | 
		  | thread d |
		  thread := self threadForContinuation: parentK.
		  self pushThread: thread.
		  d := aBlock
			       on: aClass
			       do: hBlock.
		  self dispatch: d ]
]

{ #category : #initialization }
CSTCoroutine >> threadForContinuation: k [
	^ CSTThread new
		  id: thread_id;
		  continuation: k;
		  yourself
]

{ #category : #enumerating }
CSTCoroutine >> withThreadDo: aBlock [
	^ Continuation currentDo: [ :k | 
		  | thread |
		  thread := self threadForContinuation: k.
		  aBlock cull: thread ]
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
