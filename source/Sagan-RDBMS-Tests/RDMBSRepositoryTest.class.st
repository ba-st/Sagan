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

	DefaultLogin := (OSEnvironment current getEnv: 'RDBMS') ifNil: [ self defaultLogin ] ifNotNil: [ :variable | self loginFor: variable ]
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
RDMBSRepositoryTest class >> useP3Driver [

	DatabaseAccessor classForThisPlatform DefaultDriver: P3DatabaseDriver
]

{ #category : #initialization }
RDMBSRepositoryTest >> configureMappings [

	repository
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
							( DirectMappingDefinition fromAttributeNamed: #firstName toFieldNamed: 'first_name' onTableNamed: 'Extraterrestrial' ).
							( DirectMappingDefinition fromAttributeNamed: #lastName toFieldNamed: 'last_name' onTableNamed: 'Extraterrestrial' )} )
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
	repository := RDMBSRepository
		storingObjectsOfType: Extraterrestrial
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: [ session ].
	self configureMappings.
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
