Extension { #name : #ContinuationTest }

{ #category : #'*ConcurrentST-Extensions' }
ContinuationTest >> testEnsureIsCalledAfterCallccNotThrown [
	| v flag |
	flag := nil.
	v := [ :k | [ 3 ] ensure: [ flag := #ensured ] ]
		     callWithCurrentContinuation.
	self
		assert: flag equals: #ensured;
		assert: v equals: 3
]

{ #category : #'*ConcurrentST-Extensions' }
ContinuationTest >> testEnsureIsCalledAfterThrowing [
	| flag v |
	flag := nil.
	v := [ :k | [ 1 + (k value: 3) ] ensure: [ flag := #ensured ] ]
		     callWithCurrentContinuation.
	self
		assert: v equals: 3;
		assert: flag equals: nil
]

{ #category : #'*ConcurrentST-Extensions' }
ContinuationTest >> testPrependBlock [
	self
		assert: (Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | v + 1 ] <- k.
				 2 + (kk value: 3) ])
		equals: 4.
	self
		assert: (Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | v + 1 ] <- k.
				 (k value: 2) + (kk value: 3) ])
		equals: 2.
	self
		assert: (Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | v + 1 ] <- k.
				 (kk value: 3) + (k value: 2) ])
		equals: 4
]

{ #category : #'*ConcurrentST-Extensions' }
ContinuationTest >> testPrependBlockRaisingException [
	self
		assert: ([ 
			 Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | Error signal ] <- k.
				 2 + (kk value: 3) ] ]
				 on: Error
				 do: [ 0 ])
		equals: 0.
	self
		assert: ([ 
			 Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | Error signal ] <- k.
				 (k value: 2) + (kk value: 3) ] ]
				 on: Error
				 do: [ 0 ])
		equals: 2
]
