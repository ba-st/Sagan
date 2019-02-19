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
				baselineSagan: spec.
			spec
				group: 'Deployment' with: #('Core' 'RDBMS');
				group: 'CI' with: 'Tests';
				group: 'Tools' with: 'Buoy-Tools';
				group: 'Development' with: #('Tests' 'Tools')
			]
]

{ #category : #initialization }
BaselineOfSagan >> baselineSagan: spec [

	spec
		package: 'Sagan-Core' with: [ spec requires: 'Kepler-Core' ];
		group: 'Core' with: 'Sagan-Core'.

	spec
		package: 'Sagan-Core-Tests' with: [ spec requires: #('Sagan-Core' 'Buoy-SUnit') ];
		group: 'Tests' with: 'Sagan-Core-Tests'.

	spec
		package: 'Sagan-RDBMS' with: [ spec requires: #('Glorp' 'Core') ];
		group: 'RDBMS' with: #('Sagan-RDBMS').

	spec group: 'PostgreSQL' with: #('RDBMS' 'P3').
	spec group: 'MySQL' with: #('RDBMS' 'MySQL-Driver' 'GarageGlorp').
	spec group: 'SQlite' with: #('RDBMS' 'GlorpSQLite').

	spec
		package: 'Sagan-RDBMS-Tests'
			with: [ spec requires: #('PostgreSQL' 'MySQL' 'SQlite' 'Sagan-Core-Tests') ];
		group: 'Tests' with: 'Sagan-RDBMS-Tests'
]

{ #category : #accessing }
BaselineOfSagan >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfSagan >> setUpDependencies: spec [

	spec
		baseline: 'Kepler' with: [ spec repository: 'github://ba-st/Kepler:v4/source' ];
		project: 'Kepler-Core' copyFrom: 'Kepler' with: [ spec loads: 'Core' ].

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v5/source' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].

	spec baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:master/' ].
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

	spec baseline: 'GlorpSQLite' with: [ spec repository: 'github://pharo-rdbms/glorp-sqlite3:master' ]
]
