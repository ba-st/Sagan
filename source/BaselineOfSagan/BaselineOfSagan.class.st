Class {
	#name : 'BaselineOfSagan',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSagan',
	#package : 'BaselineOfSagan'
}

{ #category : 'initialization' }
BaselineOfSagan >> baseline: spec [

	<baseline>
	spec for: #pharo do: [
		self
			setUpDependencies: spec;
			setUpPackages: spec.
		spec
			group: 'Deployment' with: #( 'Core' 'RDBMS' );
			group: 'CI' with: 'Tests';
			group: 'Tools' with: #( 'Core' 'Buoy-Tools' );
			group: 'Development' with: #( 'Tests' 'Tools' ).
		spec postLoadDoIt: #postLoadInitialization ]
]

{ #category : 'post load' }
BaselineOfSagan >> postLoadInitialization [

	RepositoryProviderSystem registerInterfaces
]

{ #category : 'accessing' }
BaselineOfSagan >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : 'initialization' }
BaselineOfSagan >> setUpDependencies: spec [

	spec
		baseline: 'Kepler' with: [ spec repository: 'github://ba-st/Kepler:v6/source' ];
		project: 'Kepler-Core' copyFrom: 'Kepler' with: [ spec loads: 'Core' ].

	spec
		baseline: 'ObjectPool' with: [ spec repository: 'github://pharo-ide/ObjectPool:v1.0.3' ];
		project: 'ObjectPool-Core' copyFrom: 'ObjectPool' with: [ spec loads: 'Core' ].

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v7/source' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].

	spec
		baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:v9.0.6' ];
		project: 'Glorp-Core' copyFrom: 'Glorp' with: [ spec loads: 'Core' ].

	spec
		baseline: 'P3' with: [ spec repository: 'github://ba-st-dependencies/P3:v1.4.2' ];
		project: 'Glorp P3' copyFrom: 'P3' with: [ spec loads: 'glorp' ].

	spec
		baseline: 'SQLite3' with: [ spec repository: 'github://pharo-rdbms/Pharo-SQLite3:v2.2.6' ];
		project: 'Glorp SQLite3' copyFrom: 'SQLite3' with: [ spec loads: 'glorp' ].

	spec
		baseline: 'Bell' with: [ spec repository: 'github://ba-st/Bell:v2' ];
		project: 'Bell-Core' copyFrom: 'Bell' with: [ spec loads: 'Deployment' ];
		project: 'Bell-SUnit' copyFrom: 'Bell' with: [ spec loads: 'Dependent-SUnit-Extensions' ].

	spec
		baseline: 'Hyperspace' with: [ spec repository: 'github://ba-st/Hyperspace:v5' ];
		project: 'Hyperspace-Deployment' copyFrom: 'Hyperspace' with: [ spec loads: 'Deployment' ]
]

{ #category : 'initialization' }
BaselineOfSagan >> setUpPackages: spec [

	spec
		package: 'Sagan-Core' with: [ spec requires: 'Kepler-Core' ];
		group: 'Core' with: 'Sagan-Core'.

	spec
		package: 'Sagan-Extensions';
		group: 'Core' with: 'Sagan-Extensions'.

	spec
		package: 'Sagan-Kepler' with: [ spec requires: 'Kepler-Core' ];
		group: 'Core' with: 'Sagan-Kepler'.

	spec
		package: 'Sagan-Core-Tests' with: [ spec requires: #( 'Sagan-Core' 'Buoy-SUnit' ) ];
		group: 'Tests' with: 'Sagan-Core-Tests'.

	spec
		package: 'Sagan-RDBMS'
		with: [
			spec requires: #( 'Glorp-Core' 'Core' 'ObjectPool-Core' 'Bell-Core' 'Hyperspace-Deployment' ) ];
		group: 'RDBMS' with: #( 'Sagan-RDBMS' ).

	spec package: 'Sagan-Kepler-Tests' with: [ spec requires: #( 'Sagan-Kepler' ) ].

	spec group: 'PostgreSQL' with: #( 'RDBMS' 'Glorp P3' ).
	spec group: 'SQLite' with: #( 'RDBMS' 'Glorp SQLite3' ).

	spec
		package: 'Sagan-RDBMS-Tests'
		with: [
			spec requires: #( 'PostgreSQL' 'SQLite' 'Sagan-Core-Tests' 'Sagan-Kepler-Tests'
				   'Bell-SUnit' ) ];
		group: 'Tests' with: 'Sagan-RDBMS-Tests'
]
