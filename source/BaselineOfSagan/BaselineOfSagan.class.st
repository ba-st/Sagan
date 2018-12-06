Class {
	#name : #BaselineOfSagan,
	#superclass : #BaselineOf,
	#category : #BaselineOfSagan
}

{ #category : #initialization }
BaselineOfSagan >> baseline: spec [

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec
				package: 'Sagan-Core' with: [ spec requires: #('Kepler') ];
				group: 'Core' with: #('Sagan-Core').

			spec package: 'Sagan-Core-Tests' with: [ spec requires: #('Core') ].

			spec
				group: 'Deployment' with: 'Core';
				group: 'Tests' with: 'Sagan-Core-Tests';
				group: 'CI' with: 'Tests';
				group: 'Development' with: #('Deployment' 'Tests');
				group: 'default' with: #('Deployment')
			]
]

{ #category : #initialization }
BaselineOfSagan >> setUpDependencies: spec [

	spec
		baseline: 'Kepler'
		with: [ spec
				repository: 'github://ba-st/Kepler:v3/source';
				loads: #('Core')
			]
]
