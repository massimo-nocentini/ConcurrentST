Extension { #name : #BlockClosure }

{ #category : #'*ConcurrentST' }
BlockClosure >> concurrentST [
	^ CSTLoop block: self
]
