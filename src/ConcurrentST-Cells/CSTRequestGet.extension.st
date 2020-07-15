Extension { #name : #CSTRequestGet }

{ #category : #'*ConcurrentST-Cells' }
CSTRequestGet >> loop: anObject forCSTCellRequestsReplyChannels: aCell [
	aCell loop: anObject requestGet: self
]
