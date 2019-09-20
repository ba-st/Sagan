"
Unit test for RDMBSRepository
"
Class {
	#name : #RDMBSRepositoryTest,
	#superclass : #RepositoryBasedTest,
	#instVars : [
		'session'
	],
	#classVars : [
		'DefaultLogin'
	],
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #configuring }
RDMBSRepositoryTest class >> defaultLogin [

	^ self postgreSQLv9Login
]

{ #category : #initialize }
RDMBSRepositoryTest class >> initialize [

	DefaultLogin := OSEnvironment current
		at: 'RDBMS'
		ifPresent: [ :variable | self loginFor: variable ]
		ifAbsent: [ self defaultLogin ]
]

{ #category : #'private protocol' }
RDMBSRepositoryTest class >> login [

	^ DefaultLogin
]

{ #category : #configuring }
RDMBSRepositoryTest class >> loginFor: anEnvironmentVariable [

	( anEnvironmentVariable beginsWith: 'PostgreSQLv9' )
		ifTrue: [ ^ self postgreSQLv9Login ].
	( anEnvironmentVariable beginsWith: 'PostgreSQLv1' )
		ifTrue: [ ^ self postgreSQLv10Login ].
	anEnvironmentVariable = 'MySQLv5'
		ifTrue: [ ^ self mySQLv5Login ].
	( anEnvironmentVariable beginsWith: 'MariaDB' )
		ifTrue: [ ^ self mariaDBLogin ].
	anEnvironmentVariable = 'SQLite3'
		ifTrue: [ ^ self sqlite3Login ].
	^ self defaultLogin
]

{ #category : #configuring }
RDMBSRepositoryTest class >> mariaDBLogin [

	^ self mySQLv5Login
]

{ #category : #configuring }
RDMBSRepositoryTest class >> mySQLv5Login [

	GAGlorpDriver beGlorpDefaultDriver.
	^ Login new
		database: MySQLPlatform new;
		username: 'travis';
		password: '';
		host: 'localhost';
		port: '3306';
		databaseName: 'test';
		yourself
]

{ #category : #configuring }
RDMBSRepositoryTest class >> postgreSQLv10Login [

	self useP3Driver.
	^ Login new
		database: PostgreSQLPlatform new;
		username: 'postgres';
		password: 'secret';
		host: 'localhost';
		port: 5433;
		databaseName: 'test';
		yourself
]

{ #category : #configuring }
RDMBSRepositoryTest class >> postgreSQLv9Login [

	self useP3Driver.
	^ Login new
		database: PostgreSQLPlatform new;
		username: 'postgres';
		password: 'secret';
		host: 'localhost';
		port: 5432;
		databaseName: 'test';
		yourself
]

{ #category : #configuring }
RDMBSRepositoryTest class >> sqlite3Login [

	PharoDatabaseAccessor DefaultDriver: GlorpSQLite3Driver.
	^ Login new
		database: UDBCSQLite3Platform new;
		username: '';
		password: '';
		host: SmalltalkImage current imagePath asFileReference parent fullName , FileSystem disk delimiter asString;
		port: '';
		databaseName: 'test.db';
		yourself
]

{ #category : #configuring }
RDMBSRepositoryTest class >> useP3Driver [

	DatabaseAccessor classForThisPlatform DefaultDriver: P3DatabaseDriver
]

{ #category : #initialization }
RDMBSRepositoryTest >> configureExtraterrestrialMappings [

	extraterrestrials
		configureMappingsIn: [ :rdbmsRepository | 
			rdbmsRepository
				beAwareOfTableDefinedBy:
					( RealTableDefinition
						named: 'Extraterrestrial'
						fieldsDefinedBy:
							{SequentialNumberFieldDefinition new.
							( CharacterFieldDefinition named: 'first_name' sized: 100 ).
							( CharacterFieldDefinition named: 'last_name' sized: 100 )} );
				beAwareOfClassModelDefinedBy:
					( ClassModelDefinition
						for: Extraterrestrial
						attributesDefinedBy:
							{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							( BasicAttributeDefinition named: #firstName ).
							( BasicAttributeDefinition named: #lastName )} );
				beAwareOfDescriptorDefinedBy:
					( ConcreteDescriptorDefinition
						for: Extraterrestrial
						onTableNamed: 'Extraterrestrial'
						mappingsDefinedBy:
							{( SequentialNumberMappingDefinition onTableNamed: 'Extraterrestrial' ).
							( DirectMappingDefinition
								fromAttributeNamed: #firstName
								toFieldNamed: 'first_name'
								onTableNamed: 'Extraterrestrial' ).
							( DirectMappingDefinition
								fromAttributeNamed: #lastName
								toFieldNamed: 'last_name'
								onTableNamed: 'Extraterrestrial' )} )
			]
]

{ #category : #initialization }
RDMBSRepositoryTest >> configureSpaceshipMappings [

	spaceships
		configureMappingsIn: [ :rdbmsRepository | 
			rdbmsRepository
				beAwareOfTableDefinedBy:
					( RealTableDefinition
						named: 'Spaceship'
						fieldsDefinedBy:
							{SequentialNumberFieldDefinition new.
							( CharacterFieldDefinition named: 'name' sized: 100 )} );
				beAwareOfClassModelDefinedBy:
					( ClassModelDefinition
						for: Spaceship
						attributesDefinedBy:
							{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							( BasicAttributeDefinition named: #name )} );
				beAwareOfDescriptorDefinedBy:
					( ConcreteDescriptorDefinition
						for: Spaceship
						onTableNamed: 'Spaceship'
						mappingsDefinedBy:
							{( SequentialNumberMappingDefinition onTableNamed: 'Spaceship' ).
							( DirectMappingDefinition
								fromAttributeNamed: #name
								toFieldNamed: 'name'
								onTableNamed: 'Spaceship' )} )
			]
]

{ #category : #initialization }
RDMBSRepositoryTest >> createSession [

	| accessor |

	accessor := DatabaseAccessor forLogin: self class login.
	accessor logging: self isLogging.

	^ GlorpSession new
		accessor: accessor;
		system: ConfigurableDescriptorSystem new;
		yourself
]

{ #category : #initialization }
RDMBSRepositoryTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	session := self createSession.
	extraterrestrials := RDBMSRepository
		storingObjectsOfType: Extraterrestrial
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: [ session ].
	self configureExtraterrestrialMappings.
	spaceships := RDBMSRepository
		storingObjectsOfType: Spaceship
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: [ session ].
	self configureSpaceshipMappings.
	session
		loginIfError: [ :error | self fail: error messageText ];
		recreateTablesIfError: [ :error | self fail: error messageText ];
		logout.

	session loginIfError: [ :error | self fail: error messageText ]
]

{ #category : #running }
RDMBSRepositoryTest >> tearDown [

	session ifNotNil: [ session logout ].
	super tearDown
]

{ #category : #'tests - querying' }
RDMBSRepositoryTest >> testMoreThanOneRepository [

	self extraterrestrials store: self silvesterStallone.
	self assert: self extraterrestrials findAll size equals: 1.
	self assertRepositoryIncludesSilvesterStallone.

	spaceships store: ( Spaceship named: 'UFO 54-40' ).
	self assert: spaceships findAll size equals: 1.
	spaceships
		withOneMatching: [ :spaceship | spaceship name = 'UFO 54-40' ]
		do: [ :spaceship | self assert: spaceship name equals: 'UFO 54-40' ]
		else: [ self fail ]
]
