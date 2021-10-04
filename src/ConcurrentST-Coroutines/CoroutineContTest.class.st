Class {
	#name : #CoroutineContTest,
	#superclass : #CoroutineTest,
	#category : #'ConcurrentST-Coroutines'
}

{ #category : #test }
CoroutineContTest >> coroutineOn: aBlock [

	^ CoroutineCont on: aBlock
]
