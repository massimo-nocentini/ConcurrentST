"
A CSTChannelTest is a test class for testing the behavior of CSTChannel
"
Class {
	#name : #CSTChannelTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Tests'
}

{ #category : #tests }
CSTChannelTest >> head: natsChannel primes: primesChannel loop: loop [

	| nats |
	nats := natsChannel.
	[ 
	| p |
	p := nats receive.
	primesChannel send: p.
	nats := nats select: [ :i | i \\ p ~= 0 ] on: loop channel ] repeat
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
CSTChannelTest >> swapChannel: channel outChannel: outChannel string: name loop: loop [

	loop spawnPreemptive: [ 
		| s |
		s := name.
		[ 
		outChannel send: name , ':' , s.
		s := (channel event swap: s channel: loop channel withEvents) sync ]
			repeat ]
]

{ #category : #tests }
CSTChannelTest >> testFibonacciNumbers [

	100 in: [ :n | 
		self
			assert: [ :co | 
				| c1 c2 c3 c4 c5 outChannel |
				c1 := co channel.
				c2 := co channel.
				c3 := co channel.
				c4 := co channel.
				c5 := co channel.
				outChannel := co channel.

				"Network topology."
				c4 delay: c5 init: 1.
				c2 tee: { 
						c3.
						c4 }.
				c3 zipChannels: { c5 } with: [ :a :b | a + b ] on: c1.
				c1 tee: { 
						c2.
						outChannel }.
				c1 send: 0.
				outChannel next: n ] concurrentST
			equals:
				#( 0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181
				   6765 10946 17711 28657 46368 75025 121393 196418 317811 514229
				   832040 1346269 2178309 3524578 5702887 9227465 14930352
				   24157817 39088169 63245986 102334155 165580141 267914296
				   433494437 701408733 1134903170 1836311903 2971215073 4807526976
				   7778742049 12586269025 20365011074 32951280099 53316291173
				   86267571272 139583862445 225851433717 365435296162 591286729879
				   956722026041 1548008755920 2504730781961 4052739537881
				   6557470319842 10610209857723 17167680177565 27777890035288
				   44945570212853 72723460248141 117669030460994 190392490709135
				   308061521170129 498454011879264 806515533049393 1304969544928657
				   2111485077978050 3416454622906707 5527939700884757
				   8944394323791464 14472334024676221 23416728348467685
				   37889062373143906 61305790721611591 99194853094755497
				   160500643816367088 259695496911122585 420196140727489673
				   679891637638612258 1100087778366101931 1779979416004714189
				   2880067194370816120 4660046610375530309 7540113804746346429
				   12200160415121876738 19740274219868223167 31940434634990099905
				   51680708854858323072 83621143489848422977 135301852344706746049
				   218922995834555169026 ) ]
]

{ #category : #tests }
CSTChannelTest >> testFibonacciNumbersAsynchronousChannels [

	100 in: [ :n | 
		self
			assert: [ :co | 
				| c1 c2 c3 c4 c5 outChannel |
				c1 := co asynchronousChannel.
				c2 := co asynchronousChannel.
				c3 := co asynchronousChannel.
				c4 := co asynchronousChannel.
				c5 := co asynchronousChannel.
				outChannel := co asynchronousChannel.

				"Network topology."
				c4 delay: c5 init: 1.
				c2 tee: { 
						c4.
						c3 }. "The order of the following two is swapped wrt the test case that uses synchronous channels."
				c3 zipChannels: { c5 } with: [ :a :b | a + b ] on: c1.
				c1 tee: { 
						c2.
						outChannel }.
				c1 send: 0.
				outChannel next: n ] concurrentST
			equals:
				#( 0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181
				   6765 10946 17711 28657 46368 75025 121393 196418 317811 514229
				   832040 1346269 2178309 3524578 5702887 9227465 14930352
				   24157817 39088169 63245986 102334155 165580141 267914296
				   433494437 701408733 1134903170 1836311903 2971215073 4807526976
				   7778742049 12586269025 20365011074 32951280099 53316291173
				   86267571272 139583862445 225851433717 365435296162 591286729879
				   956722026041 1548008755920 2504730781961 4052739537881
				   6557470319842 10610209857723 17167680177565 27777890035288
				   44945570212853 72723460248141 117669030460994 190392490709135
				   308061521170129 498454011879264 806515533049393 1304969544928657
				   2111485077978050 3416454622906707 5527939700884757
				   8944394323791464 14472334024676221 23416728348467685
				   37889062373143906 61305790721611591 99194853094755497
				   160500643816367088 259695496911122585 420196140727489673
				   679891637638612258 1100087778366101931 1779979416004714189
				   2880067194370816120 4660046610375530309 7540113804746346429
				   12200160415121876738 19740274219868223167 31940434634990099905
				   51680708854858323072 83621143489848422977 135301852344706746049
				   218922995834555169026 ) ]
]

{ #category : #tests }
CSTChannelTest >> testFibonacciNumbersWithEventChannels [

	100 in: [ :n | 
		self
			assert: [ :co | 
				| c1 c2 c3 c4 c5 outChannel |
				c1 := co channel withEvents.
				c2 := co channel withEvents.
				c3 := co channel withEvents.
				c4 := co channel withEvents.
				c5 := co channel withEvents.
				outChannel := co channel withEvents.

				"Network topology."
				c4 delay: c5 init: 1.
				c2 tee: { 
						c3.
						c4 }.
				c3 zipChannels: { c5 } with: [ :a :b | a + b ] on: c1.
				c1 tee: { 
						c2.
						outChannel }.
				c1 send: 0.
				outChannel next: n ] concurrentST
			equals:
				#( 0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181
				   6765 10946 17711 28657 46368 75025 121393 196418 317811 514229
				   832040 1346269 2178309 3524578 5702887 9227465 14930352
				   24157817 39088169 63245986 102334155 165580141 267914296
				   433494437 701408733 1134903170 1836311903 2971215073 4807526976
				   7778742049 12586269025 20365011074 32951280099 53316291173
				   86267571272 139583862445 225851433717 365435296162 591286729879
				   956722026041 1548008755920 2504730781961 4052739537881
				   6557470319842 10610209857723 17167680177565 27777890035288
				   44945570212853 72723460248141 117669030460994 190392490709135
				   308061521170129 498454011879264 806515533049393 1304969544928657
				   2111485077978050 3416454622906707 5527939700884757
				   8944394323791464 14472334024676221 23416728348467685
				   37889062373143906 61305790721611591 99194853094755497
				   160500643816367088 259695496911122585 420196140727489673
				   679891637638612258 1100087778366101931 1779979416004714189
				   2880067194370816120 4660046610375530309 7540113804746346429
				   12200160415121876738 19740274219868223167 31940434634990099905
				   51680708854858323072 83621143489848422977 135301852344706746049
				   218922995834555169026 ) ]
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbers [

	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel |
				natsChannel := co channel.
				co spawnPreemptive: [ self naturals: 0 channel: natsChannel ].
				natsChannel next: n ] concurrentST
			equals: (0 to: n - 1) ]
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbersRecursionSlow [

	self skip.
	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel |
				natsChannel := co channel.
				co spawnPreemptive: [ 
					self recursiveNaturals: 0 channel: natsChannel ].
				natsChannel next: n ] concurrentST
			equals: (0 to: n - 1) ]
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbersSpawn [
	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel |
				natsChannel := co asynchronousChannel.
				co spawnPreemptive: [ self naturals: 0 channel: natsChannel ].
				Array streamContents: [ :aStream | 
					natsChannel next: n on: aStream ] ] concurrentST
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
					spawnPreemptive: [ self naturals: 2 channel: natsChannel ];
					spawnPreemptive: [ 
						self head: natsChannel primes: primesChannel loop: co ].
				primesChannel next: n ] concurrentST
			equals:
				#( 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79
				   83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163
				   167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251
				   257 263 269 271 277 281 283 293 307 311 313 317 331 337 347 349
				   353 359 367 373 379 383 389 397 401 409 419 421 431 433 439 443
				   449 457 461 463 467 479 487 491 499 503 509 521 523 541 ) ]
]

{ #category : #tests }
CSTChannelTest >> testSwapChannel [

	| loop channel o array |
	loop := CSTLoop new.

	channel := loop channel withEvents.
	o := loop channel.

	self
		swapChannel: channel
		outChannel: o
		string: 'first'
		loop: loop.
	self
		swapChannel: channel
		outChannel: o
		string: 'second'
		loop: loop.
	self
		swapChannel: channel
		outChannel: o
		string: 'third'
		loop: loop.
	self
		swapChannel: channel
		outChannel: o
		string: 'fourth'
		loop: loop.

	array := #( 'first:first' 'second:second' 'third:third' 'fourth:fourth'
	            'second:first' 'fourth:third' 'first:second'
	            'third:fourth' 'fourth:first' 'third:second'
	            'second:third' 'first:fourth' 'third:first' 'first:third'
	            'fourth:second' 'second:fourth' ).

	self assert: (o next: array size double) equals: array , array
]
