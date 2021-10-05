Class {
	#name : #CSTCoroutine,
	#superclass : #Object,
	#instVars : [
		'readyQueue',
		'threadsCount'
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
	readyQueue := CTLinkedStoragePool queue new.
	threadsCount := 0
]

{ #category : #initialization }
CSTCoroutine >> popThread [
	^ readyQueue pop
]

{ #category : #initialization }
CSTCoroutine >> pushThread: aThread [
	readyQueue push: aThread
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

	^ self spawn: aBlock on: Exception do: [ :e | e raiseUnhandledError ]
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawn: aBlock on: aClass do: hBlock [

	^ self withThreadDo: [ :thread | 
		  self pushThread: thread.
		  [ 
		  aBlock
			  on: aClass
			  do: hBlock ] ensure: [ self dispatch: thread ] ]
]

{ #category : #'as yet unclassified' }
CSTCoroutine >> spawnTracingErrors: aBlock [
	^ self spawn: aBlock on: Error do: [ :e | e traceCr ]
]

{ #category : #enumerating }
CSTCoroutine >> withThreadDo: aBlock [

	^ Coroutine currentDo: [ :k | 
		  | thread |
		  threadsCount := threadsCount + 1.
		  thread := CSTThread new
			            id: threadsCount;
			            continuation: k;
			            yourself.
		  aBlock value: thread ]
]
