Class {
	#name : #BaselineOfSagan,
	#superclass : #BaselineOf,
	#category : #BaselineOfSagan
}

{ #category : #initialization }
BaselineOfSagan >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ 
			spec preLoadDoIt: #lockDependenciesIn:.
			self
				setUpDependencies: spec;
				setUpPackages: spec.
			spec
				group: 'Deployment' with: #('Core' 'RDBMS');
				group: 'CI' with: 'Tests';
				group: 'Tools' with: 'Buoy-Tools';
				group: 'Development' with: #('Tests' 'Tools')
			]
]

{ #category : #initialization }
BaselineOfSagan >> glorpRepository [

	^ 'github://ba-st-dependencies/Glorp:release-candidate/'
]

{ #category : #initialization }
BaselineOfSagan >> lockDependenciesIn: spec [

	Metacello new
		baseline: 'Glorp';
		repository: self glorpRepository;
		onLock: [ :lock | lock honor ];
		onConflictUseLoaded;
		lock
]

{ #category : #accessing }
BaselineOfSagan >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfSagan >> setUpDependencies: spec [

	spec
		baseline: 'Kepler' with: [ spec repository: 'github://ba-st/Kepler:v5/source' ];
		project: 'Kepler-Core' copyFrom: 'Kepler' with: [ spec loads: 'Core' ].

	spec
		baseline: 'ObjectPool' with: [ spec repository: 'github://pharo-ide/ObjectPool:v1.0.1' ];
		project: 'ObjectPool-Core' copyFrom: 'ObjectPool' with: [ spec loads: 'Core' ].

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v6/source' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].

	spec
		baseline: 'Glorp' with: [ spec repository: self glorpRepository ];
		project: 'Glorp-Core' copyFrom: 'Glorp' with: [ spec loads: 'Core' ].

	spec baseline: 'GarageGlorp' with: [ spec repository: 'github://pharo-rdbms/glorp-garage:master/' ].

	spec
		baseline: 'P3'
			with: [ spec
				repository: 'github://svenvc/P3:v1.2/';
				loads: #('glorp')
			];
		import: 'P3'.

	spec
		baseline: 'Garage' with: [ spec repository: 'github://pharo-rdbms/garage:master' ];
		project: 'MySQL-Driver' copyFrom: 'Garage' with: [ spec loads: #('mysql') ].

	spec
		baseline: 'SQLite3'
			with: [ spec repository: 'github://ba-st-dependencies/Pharo-SQLite3:release-candidate' ];
		project: 'Glorp SQLite3' copyFrom: 'SQLite3' with: [ spec loads: 'glorp' ]
]

{ #category : #initialization }
BaselineOfSagan >> setUpPackages: spec [

	spec
		package: 'Sagan-Core' with: [ spec requires: 'Kepler-Core' ];
		group: 'Core' with: 'Sagan-Core'.

	spec
		package: 'Sagan-Kepler' with: [ spec requires: 'Kepler-Core' ];
		group: 'Core' with: 'Sagan-Kepler'.

	spec
		package: 'Sagan-Core-Tests' with: [ spec requires: #('Sagan-Core' 'Buoy-SUnit') ];
		group: 'Tests' with: 'Sagan-Core-Tests'.

	spec
		package: 'Sagan-RDBMS' with: [ spec requires: #('Glorp-Core' 'Core' 'ObjectPool-Core') ];
		group: 'RDBMS' with: #('Sagan-RDBMS').

	spec package: 'Sagan-Kepler-Tests' with: [ spec requires: #('Sagan-Kepler') ].

	spec group: 'PostgreSQL' with: #('RDBMS' 'P3').
	spec group: 'MySQL' with: #('RDBMS' 'MySQL-Driver' 'GarageGlorp').
	spec group: 'SQLite' with: #('RDBMS' 'Glorp SQLite3').

	spec
		package: 'Sagan-RDBMS-Tests'
			with: [ spec requires: #('PostgreSQL' 'MySQL' 'SQLite' 'Sagan-Core-Tests' 'Sagan-Kepler-Tests') ];
		group: 'Tests' with: 'Sagan-RDBMS-Tests'
]
