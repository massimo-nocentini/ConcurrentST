Extension { #name : #CSTRequestGet }

{ #category : #'*ConcurrentST-Cells' }
CSTRequestGet >> value: anObject forCSTCellRequestsReplyChannels: aCell [
	aCell value: anObject requestGet: self
]
