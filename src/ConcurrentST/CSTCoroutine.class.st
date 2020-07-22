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
CSTCoroutine >> asynchronousSelectiveChannel [
	^ CSTChannel asynchronousSelective: self
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
CSTCoroutine >> repeat: aBlock [
	self repeat: [ :_ | aBlock value ] init: nil
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> repeat: aBlock init: anObject [
	self spawn: [ 
		| current |
		current := anObject.
		[ current := aBlock value: current ] repeat ]
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock [
	^ self spawn: aBlock on: nil do: nil
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock on: aClass do: hBlock [
	^ self withThreadDo: [ :thread | 
		  | handledBlock |
		  self pushThread: thread.
		  handledBlock := aClass ifNil: [ aBlock ] ifNotNil: [ 
			                  [ 
			                  aBlock
				                  on: aClass
				                  do: hBlock ] ].
		  handledBlock ensure: [ self dispatch: thread ] ]
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawnTracingErrors: aBlock [
	^ self spawn: aBlock on: Error do: [ :e | e traceCr ]
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
