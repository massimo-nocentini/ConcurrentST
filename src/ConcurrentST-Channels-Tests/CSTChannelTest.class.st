"
A CSTChannelTest is a test class for testing the behavior of CSTChannel
"
Class {
	#name : #CSTChannelTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Channels-Tests'
}

{ #category : #tests }
CSTChannelTest >> head: natsChannel primes: primesChannel [
	| nats |
	nats := natsChannel.
	[ 
	| p |
	p := nats receive.
	primesChannel send: p.
	nats := nats select: [ :i | i \\ p ~= 0 ] ] repeat
]

{ #category : #tests }
CSTChannelTest >> naturals: s channel: channel [
	| i |
	i := s.
	[ 
	channel send: i.
	i := i + 1 ] repeat
]

{ #category : #tests }
CSTChannelTest >> recursiveNaturals: s channel: channel [
	channel send: s.
	^ self recursiveNaturals: s + 1 channel: channel
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbers [
	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel |
				natsChannel := co channel.
				co spawn: [ self naturals: 0 channel: natsChannel ].
				natsChannel next: n ] coroutine
			equals: (0 to: n - 1) ]
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbersRecursionSlow [
	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel |
				natsChannel := co channel.
				co spawn: [ self recursiveNaturals: 0 channel: natsChannel ].
				natsChannel next: n ] coroutine
			equals: (0 to: n - 1) ]
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbersSpawn [
	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel |
				natsChannel := co asynchronousChannel.
				co spawn: [ self naturals: 0 channel: natsChannel ].
				Array streamContents: [ :aStream | 
					natsChannel next: n on: aStream ] ] coroutine
			equals: (0 to: n - 1) ]
]

{ #category : #tests }
CSTChannelTest >> testPrimeNumbers [
	100 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel primesChannel |
				natsChannel := co channel.
				primesChannel := co channel.
				co
					spawn: [ self naturals: 2 channel: natsChannel ];
					spawn: [ self head: natsChannel primes: primesChannel ].
				primesChannel next: n ] coroutine
			equals:
				#( 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79
				   83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163
				   167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251
				   257 263 269 271 277 281 283 293 307 311 313 317 331 337 347 349
				   353 359 367 373 379 383 389 397 401 409 419 421 431 433 439 443
				   449 457 461 463 467 479 487 491 499 503 509 521 523 541 ) ]
]
