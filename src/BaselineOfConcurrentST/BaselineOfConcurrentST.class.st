Class {
	#name : #BaselineOfConcurrentST,
	#superclass : #BaselineOf,
	#category : #BaselineOfConcurrentST
}

{ #category : #baselines }
BaselineOfConcurrentST >> baseline: spec [
	<baseline>
	spec for: #common do: [ "The following also install Roassal3."
		spec
			baseline: 'dsst'
			with: [ spec repository: 'github://massimo-nocentini/dsst/' ].
		spec
			package: 'ConcurrentST-Extensions';
			package: 'ConcurrentST';
			package: 'ConcurrentST-Tests'
			with: [ spec requires: #( 'ConcurrentST' ) ];
			package: 'ConcurrentST-Cells';
			package: 'ConcurrentST-Cells-Tests'
			with: [ spec requires: #( 'ConcurrentST-Cells' ) ];
			package: 'ConcurrentST-Channels';
			package: 'ConcurrentST-Channels-Tests'
			with: [ spec requires: #( 'ConcurrentST-Channels' ) ] ]
]
