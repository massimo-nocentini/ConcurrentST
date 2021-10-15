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

	^ CSTChannelAsynchronous new
		  loop: self;
		  yourself
]

{ #category : #'as yet unclassified' }
CSTLoop >> channel [

	^ CSTChannelSynchronous new
		  loop: self;
		  yourself
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
	self spawnPreemptive: [ 
		| current |
		current := anObject.
		[ current := aBlock value: current ] repeat ]
]

{ #category : #'as yet unclassified' }
CSTLoop >> spawnNotPreemptive: aBlock [

	^ self
		  spawnNotPreemptive: aBlock
		  on: Exception
		  do: [ :e | e raiseUnhandledError ]
]

{ #category : #'as yet unclassified' }
CSTLoop >> spawnNotPreemptive: aBlock on: aClass do: hBlock [

	"
.. code: sml

	fun fork f = 
					let
						val newThread = callcc (fn k1 => (
															callcc (fn k2 => (throw k1 k2)); 
															(f ()) handle _ => ();
															exit ()))
					in 
						Q.enqueue (rdyQ, newThread)
					end
	"

	| thread |
	thread := self withThreadDo: [ :thread1 | 
		          self withThreadDo: [ :thread2 | thread1 throw: thread2 ].
		          [ 
		          aBlock
			          on: aClass
			          do: hBlock ] ensure: [ self dispatch: thread1 ] ].

	self pushThread: thread.

	^ thread
]

{ #category : #'as yet unclassified' }
CSTLoop >> spawnPreemptive: aBlock [

	^ self spawnPreemptive: aBlock on: Exception do: [ :e | e raiseUnhandledError ]
]

{ #category : #'as yet unclassified' }
CSTLoop >> spawnPreemptive: aBlock on: aClass do: hBlock [

	^ self withThreadDo: [ :thread | 
		  self pushThread: thread.
		
		  [ 
		  aBlock
			  on: aClass
			  do: hBlock ] ensure: [ self dispatch: thread ].

		  thread ]
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
