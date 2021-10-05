Extension { #name : #BlockClosure }

{ #category : #'*ConcurrentST' }
BlockClosure >> concurrentST [
	^ CSTCoroutine block: self
]
