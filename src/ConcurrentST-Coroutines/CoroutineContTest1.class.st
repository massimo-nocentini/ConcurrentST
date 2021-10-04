Class {
	#name : #CoroutineContTest1,
	#superclass : #CoroutineTest,
	#category : #'ConcurrentST-Coroutines'
}

{ #category : #test }
CoroutineContTest1 >> coroutineOn: aBlock [

	^ CoroutineCont on: aBlock
]
