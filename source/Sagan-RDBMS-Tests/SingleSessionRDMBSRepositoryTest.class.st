"
Unit test for RDMBSRepository
"
Class {
	#name : 'SingleSessionRDMBSRepositoryTest',
	#superclass : 'RepositoryBasedTest',
	#instVars : [
		'provider'
	],
	#classVars : [
		'DefaultLogin'
	],
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'configuring' }
SingleSessionRDMBSRepositoryTest class >> defaultLogin [

	<ignoreForCoverage>
	^ self postgreSQLLogin
]

{ #category : 'initialize' }
SingleSessionRDMBSRepositoryTest class >> initialize [

	<ignoreForCoverage>
	DefaultLogin := OSEnvironment current
		at: 'RDBMS'
		ifPresent: [ :variable | self loginFor: variable ]
		ifAbsent: [ self defaultLogin ]
]

{ #category : 'private protocol' }
SingleSessionRDMBSRepositoryTest class >> login [

	^ DefaultLogin
]

{ #category : 'configuring' }
SingleSessionRDMBSRepositoryTest class >> loginFor: anEnvironmentVariable [

	<ignoreForCoverage>
	( anEnvironmentVariable beginsWith: 'PostgreSQL' )
		ifTrue: [ ^ self postgreSQLLogin ].
	anEnvironmentVariable = 'SQLite3'
		ifTrue: [ ^ self sqlite3Login ].
	^ self defaultLogin
]

{ #category : 'configuring' }
SingleSessionRDMBSRepositoryTest class >> postgreSQLLogin [

	<ignoreForCoverage>
	self useP3Driver.
	^ Login new
		database: PostgreSQLPlatform new;
		username: 'postgres';
		password: 'secret';
		host: 'localhost';
		port: 5432;
		databaseName: 'test';
		setSSL;
		yourself
]

{ #category : 'configuring' }
SingleSessionRDMBSRepositoryTest class >> sqlite3Login [

	<ignoreForCoverage>
	DatabaseAccessor classForThisPlatform DefaultDriver: SQLite3Driver.
	^ Login new
		database: UDBCSQLite3Platform new;
		username: '';
		password: '';
		host: SmalltalkImage current imagePath asFileReference parent fullName , FileSystem disk delimiter asString;
		port: '';
		databaseName: 'test.db';
		yourself
]

{ #category : 'configuring' }
SingleSessionRDMBSRepositoryTest class >> useP3Driver [

	<ignoreForCoverage>
	DatabaseAccessor classForThisPlatform DefaultDriver: P3DatabaseDriver
]

{ #category : 'initialization' }
SingleSessionRDMBSRepositoryTest >> configureSpaceshipMappings [

	ships configureWith: [ :rdbmsRepository |
		rdbmsRepository
			beAwareOfTableDefinedBy: ( RealTableDefinition
					  named: 'Spaceship'
					  fieldsDefinedBy: {
							  SequentialNumberFieldDefinition new.
							  ( CharacterFieldDefinition named: 'name' sized: 100 ).
							  ( DecimalFieldDefinition nullableNamed: 'firepower' ) }
					  indexesDefinedBy: { ( IndexDefinition forFieldNamed: 'name' ) } );
			beAwareOfClassModelDefinedBy: ( ClassModelDefinition for: Spaceship attributesDefinedBy: {
							  ( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							  ( BasicAttributeDefinition named: #name ).
							  ( BasicAttributeDefinition named: #firepower ) } );
			beAwareOfDescriptorDefinedBy:
				( ConcreteDescriptorDefinition for: Spaceship onTableNamed: 'Spaceship' mappingsDefinedBy: {
							  ( SequentialNumberMappingDefinition onTableNamed: 'Spaceship' ).
							  ( DirectMappingDefinition
								    fromAttributeNamed: #name
								    toFieldNamed: 'name'
								    onTableNamed: 'Spaceship' ).
							  ( AdHocMappingDefinition
								    forNullableAttributeNamed: #firepower
								    toMapSingleAssociationTo: 'firepower'
								    on: 'Spaceship'
								    convertingFromDatabaseToSmalltalkUsing: [ :number | number asFloat ]
								    fromSmalltalkToDatabaseUsing: [ :number | number asScaledDecimal ]
								    consideringNullAs: Spaceship unlimitedFirepower ) } )
		]
]

{ #category : 'utility' }
SingleSessionRDMBSRepositoryTest >> do: aBlock unlessSQLiteIsBeingUsedInWhichCaseDo: aSQLiteBeingUsedBlock [

	DatabaseAccessor classForThisPlatform DefaultDriver = SQLite3Driver
		then: aSQLiteBeingUsedBlock
		otherwise: aBlock
]

{ #category : 'initialization' }
SingleSessionRDMBSRepositoryTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	provider := RDBMSRepositoryProvider usingSingleSessionWith: self class login
		            configuredBy: [ :options | options at: #logDatabaseEvents put: true ].
	extraterrestrials := provider createRepositoryStoringObjectsOfType: Extraterrestrial
		                     checkingConflictsAccordingTo: aConflictCheckingStrategy.
	ExtraterrestrialMappingConfiguration new cull: extraterrestrials.
	ships := provider createRepositoryStoringObjectsOfType: Spaceship
		         checkingConflictsAccordingTo: aConflictCheckingStrategy.
	self configureSpaceshipMappings.
	provider prepareForInitialPersistence
]

{ #category : 'running' }
SingleSessionRDMBSRepositoryTest >> tearDown [

	provider
		destroyRepositories;
		reset.
	super tearDown
]

{ #category : 'tests - querying' }
SingleSessionRDMBSRepositoryTest >> testLogging [

	self
		do: [ 
			self withLoggingAsserterDo: [ :asserter | 
				asserter
					runMemoryLoggerDuring: [ self extraterrestrials store: self silvesterStallone ];
					assertLogRecordsMatchInTheFollowingOrder: #( '[DEBUG] Glorp event received {"detail":"Login"}'
						   '[DEBUG] Glorp event received {"detail":"Login finished"}'
						   '[DEBUG] Glorp event received {"detail":"Begin Transaction"}'
						   '[DEBUG] Glorp event received {"detail":"INSERT INTO Extraterrestrial (sequential_number,first_name,last_name,birth_date,race_name)  VALUES (1,''Silvester'',''Stallone'',''1946-07-06'',''Human'')"}'
						   '[DEBUG] Glorp event received {"detail":"Commit Transaction"}' )
				]
			]
		unlessSQLiteIsBeingUsedInWhichCaseDo: [ 
			self withLoggingAsserterDo: [ :asserter | 
				asserter
					runMemoryLoggerDuring: [ self extraterrestrials store: self silvesterStallone ];
					assertLogRecordsMatchInTheFollowingOrder: #( '[DEBUG] Glorp event received {"detail":"Login"}'
						   '[DEBUG] Glorp event received {"detail":"Login finished"}'
						   '[DEBUG] Glorp event received {"detail":"Begin Transaction"}'
						   '[DEBUG] Glorp event received {"detail":"INSERT INTO Extraterrestrial (first_name,last_name,birth_date,race_name)  VALUES (?,?,?,?)  an Array(''Silvester'' ''Stallone'' 6 July 1946 ''Human'')"}'
						   '[DEBUG] Glorp event received {"detail":"Commit Transaction"}' )
				]
			]
]

{ #category : 'tests - querying' }
SingleSessionRDMBSRepositoryTest >> testMoreThanOneRepository [

	self extraterrestrials store: self silvesterStallone.
	self assert: self extraterrestrials findAll size equals: 1.
	self assertRepositoryIncludesSilvesterStallone.

	ships store: ( Spaceship named: 'UFO 54-40' ).
	self assert: ships findAll size equals: 1.
	ships
		withOneMatching: [ :spaceship | spaceship name = 'UFO 54-40' ]
		do: [ :spaceship | self assert: spaceship name equals: 'UFO 54-40' ]
		else: [ self fail ]
]

{ #category : 'tests - querying' }
SingleSessionRDMBSRepositoryTest >> testSpaceshipQueryingForPositiveFirepower [

	| solvalou solgrado zeodalley |

	self setUpRepositoryWithNoConflictChecking.

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	solgrado := Spaceship named: 'Solgrado' firepower: 7650.
	zeodalley := Spaceship withUnlimitedFirepowerNamed: 'Zeodalley'.

	ships store: solvalou.
	ships store: solgrado.
	ships store: zeodalley.

	self
		withAllSpaceshipsMatching:
			[ :spaceship :builder | builder isUndefined: spaceship firepower otherwiseSatisfy: spaceship firepower > 0 ]
		do: [ :spaceships | 
			self
				assertCollection: spaceships
				hasSameElements:
					{solgrado.
					zeodalley}
			]
]

{ #category : 'tests - querying' }
SingleSessionRDMBSRepositoryTest >> testSpaceshipQueryingForZeroFirepower [

	| solvalou solgrado zeodalley |

	self setUpRepositoryWithNoConflictChecking.

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	solgrado := Spaceship named: 'Solgrado' firepower: 7650.
	zeodalley := Spaceship withUnlimitedFirepowerNamed: 'Zeodalley'.

	ships store: solvalou.
	ships store: solgrado.
	ships store: zeodalley.

	self
		withAllSpaceshipsMatching: [ :spaceship :builder | builder satisfyingAny: {( spaceship firepower = 0 )} ]
		do: [ :spaceships | self assertCollection: spaceships hasSameElements: {solvalou} ]
]

{ #category : 'utility' }
SingleSessionRDMBSRepositoryTest >> withAllSpaceshipsMatching: aMatchingCriteria do: aOneArgBlock [

	aOneArgBlock value: ( ships findAllMatching: aMatchingCriteria )
]

{ #category : 'utility' }
SingleSessionRDMBSRepositoryTest >> withLoggingAsserterDo: aOneArgBlock [

	| loggingAsserter |

	loggingAsserter := LoggingAsserter on: self.

	[ aOneArgBlock value: loggingAsserter ] ensure: [ loggingAsserter stopLoggers ]
]
