Extension { #name : #Object }

{ #category : #'*ConcurrentST-Extensions' }
Object >> prependBlock: aFullBlockClosure [
	^ aFullBlockClosure value: self
]
