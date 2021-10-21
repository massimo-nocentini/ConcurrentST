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

{ #category : #channels }
CSTLoop >> asynchronousChannel [

	^ CSTChannelAsynchronous new
		  loop: self;
		  yourself
]

{ #category : #channels }
CSTLoop >> channel [

	^ CSTChannelSynchronous new
		  loop: self;
		  yourself
]

{ #category : #threading }
CSTLoop >> dispatchThread: aValue [

	^ self popThread throw: aValue
]

{ #category : #events }
CSTLoop >> event [

	^ CSTEvent new
		  loop: self;
		  yourself
]

{ #category : #initialization }
CSTLoop >> initialize [
	super initialize.
	readyQueue := CTLinkedStoragePool queue new.
	threadsCount := 0
]

{ #category : #threading }
CSTLoop >> popThread [
	^ readyQueue pop
]

{ #category : #threading }
CSTLoop >> pushThread: aThread [
	readyQueue push: aThread
]

{ #category : #API }
CSTLoop >> repeat: aBlock [
	self repeat: [ :_ | aBlock value ] init: nil
]

{ #category : #API }
CSTLoop >> repeat: aBlock init: anObject [
	self spawnPreemptive: [ 
		| current |
		current := anObject.
		[ current := aBlock value: current ] repeat ]
]

{ #category : #API }
CSTLoop >> spawnNotPreemptive: aBlock [

	^ self
		  spawnNotPreemptive: aBlock
		  on: Exception
		  do: [ :e | e raiseUnhandledError ]
]

{ #category : #API }
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
			          do: hBlock ] ensure: [ self dispatchThread: thread1 ] ].

	self pushThread: thread.

	^ thread
]

{ #category : #API }
CSTLoop >> spawnPreemptive: aBlock [

	^ self spawnPreemptive: aBlock on: Exception do: [ :e | e raiseUnhandledError ]
]

{ #category : #API }
CSTLoop >> spawnPreemptive: aBlock on: aClass do: hBlock [

	^ self withThreadDo: [ :thread | 
		  self pushThread: thread.

		  [ 
		  aBlock
			  on: aClass
			  do: hBlock ] ensure: [ self dispatchThread: thread ].

		  thread ]
]

{ #category : #threading }
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
