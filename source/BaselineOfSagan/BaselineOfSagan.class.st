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
		do: [ self
				setUpDependencies: spec;
				setUpPackages: spec.
			spec
				group: 'Deployment' with: #('Core' 'RDBMS');
				group: 'CI' with: 'Tests';
				group: 'Tools' with: 'Buoy-Tools';
				group: 'Development' with: #('Tests' 'Tools')
			]
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
		baseline: 'ObjectPool' with: [ spec repository: 'github://pharo-ide/ObjectPool:v1.0.2' ];
		project: 'ObjectPool-Core' copyFrom: 'ObjectPool' with: [ spec loads: 'Core' ].

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v6/source' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].

	spec
		baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:v9.0.4'  ];
		project: 'Glorp-Core' copyFrom: 'Glorp' with: [ spec onLock: [ :ex | ex honor ]; loads: 'Core' ].

	spec
		baseline: 'P3'
			with: [ spec repository: 'github://ba-st-dependencies/P3:v1.4.1'];
			project: 'Glorp P3' copyFrom: 'P3' with: [ spec loads: 'glorp' ].

	spec
		baseline: 'SQLite3'
			with: [ spec repository: 'github://pharo-rdbms/Pharo-SQLite3:v2.2.0' ];
		project: 'Glorp SQLite3' copyFrom: 'SQLite3' with: [ spec loads: 'glorp' ]. 
		
	spec 
		baseline: 'Launchpad' with: [ spec repository: 'github://ba-st/Launchpad:v4' ];
		project: 'Launchpad-Logging' copyFrom: 'Launchpad' with: [ spec loads: 'Deployment' ]
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

	spec group: 'PostgreSQL' with: #('RDBMS' 'Glorp P3').
	spec group: 'SQLite' with: #('RDBMS' 'Glorp SQLite3').

	spec
		package: 'Sagan-RDBMS-Tests'
			with: [ spec requires: #('PostgreSQL' 'SQLite' 'Sagan-Core-Tests' 'Sagan-Kepler-Tests') ];
		group: 'Tests' with: 'Sagan-RDBMS-Tests'
]
