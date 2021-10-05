Class {
	#name : #CSTLoop,
	#superclass : #Object,
	#instVars : [
		'readyQueue',
		'threadsCount'
	],
	#category : #ConcurrentST
}

{ #category : #'as yet unclassified' }
CSTLoop class >> block: aFullBlockClosure [
	^ aFullBlockClosure value: self new
]

{ #category : #'as yet unclassified' }
CSTLoop >> asynchronousChannel [
	^ CSTChannel asynchronous: self
]

{ #category : #'as yet unclassified' }
CSTLoop >> channel [
	^ CSTChannel synchronous: self
]

{ #category : #initialization }
CSTLoop >> dispatch: aValue [
	^ self popThread throw: aValue
]

{ #category : #initialization }
CSTLoop >> initialize [
	super initialize.
	readyQueue := CTLinkedStoragePool queue new.
	threadsCount := 0
]

{ #category : #initialization }
CSTLoop >> popThread [
	^ readyQueue pop
]

{ #category : #initialization }
CSTLoop >> pushThread: aThread [
	readyQueue push: aThread
]

{ #category : #'as yet unclassified' }
CSTLoop >> repeat: aBlock [
	self repeat: [ :_ | aBlock value ] init: nil
]

{ #category : #'as yet unclassified' }
CSTLoop >> repeat: aBlock init: anObject [
	self spawn: [ 
		| current |
		current := anObject.
		[ current := aBlock value: current ] repeat ]
]

{ #category : #'as yet unclassified' }
CSTLoop >> spawn: aBlock [

	^ self spawn: aBlock on: Exception do: [ :e | e raiseUnhandledError ]
]

{ #category : #'as yet unclassified' }
CSTLoop >> spawn: aBlock on: aClass do: hBlock [

	^ self withThreadDo: [ :thread | 
		  self pushThread: thread.
		  [ 
		  aBlock
			  on: aClass
			  do: hBlock ] ensure: [ self dispatch: thread ] ]
]

{ #category : #'as yet unclassified' }
CSTLoop >> spawnTracingErrors: aBlock [
	^ self spawn: aBlock on: Error do: [ :e | e traceCr ]
]

{ #category : #enumerating }
CSTLoop >> withThreadDo: aBlock [

	^ Coroutine currentDo: [ :k | 
		  | thread |
		  threadsCount := threadsCount + 1.
		  thread := CSTThread new
			            id: threadsCount;
			            continuation: k;
			            yourself.
		  aBlock value: thread ]
]
