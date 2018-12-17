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

			spec package: 'Sagan-Core-Tests' with: [ spec requires: #('Core' 'Buoy') ].

			spec
				package: 'Sagan-RDBMS' with: [ spec requires: #('Glorp' 'Core') ];
				group: 'RDBMS' with: #('Sagan-RDBMS').

			spec group: 'PostgreSQL' with: #('RDBMS' 'P3').
			spec group: 'MySQL' with: #('RDBMS' 'MySQL-Driver' 'GarageGlorp').

			spec package: 'Sagan-RDBMS-Tests' with: [ spec requires: #('PostgreSQL' 'MySQL' 'Sagan-Core-Tests') ].


			spec
				group: 'Deployment' with: #('Core' 'RDBMS');
				group: 'Tests' with: #('Sagan-Core-Tests' 'Sagan-RDBMS-Tests');
				group: 'CI' with: 'Tests';
				group: 'Development' with: #('Deployment' 'Tests');
				group: 'default' with: #('Development')
			]
]

{ #category : #initialization }
BaselineOfSagan >> setUpDependencies: spec [

	spec
		baseline: 'Kepler'
			with: [ spec
				repository: 'github://ba-st/Kepler:v3/source';
				loads: #('Core')
			];
		import: 'Kepler'.

	spec
		baseline: 'Buoy'
			with: [ spec
				repository: 'github://ba-st/Buoy:v4/source';
				loads: #('SUnit')
			];
		import: 'Buoy'.

	spec baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:master/' ].
	spec baseline: 'GarageGlorp' with: [ spec repository: 'github://pharo-rdbms/glorp-garage:master/' ].
	
	spec
		baseline: 'P3'
			with: [ spec
				repository: 'github://ba-st/P3:master/';
				loads: #('glorp')
			];
		import: 'P3'.

	spec
		baseline: 'Garage' with: [ spec repository: 'github://pharo-rdbms/garage:master' ];
		project: 'MySQL-Driver' copyFrom: 'Garage' with: [ spec loads: #('mysql') ]
]
