"
Unit test for RDMBSRepository
"
Class {
	#name : #RDMBSRepositoryTest,
	#superclass : #RepositoryBasedTest,
	#instVars : [
		'session'
	],
	#category : #'Sagan-RDBMS-Tests'
}

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

	DatabaseAccessor classForThisPlatform DefaultDriver: P3DatabaseDriver.
	accessor := DatabaseAccessor
		forLogin:
			( Login new
				database: PostgreSQLPlatform new;
				username: 'postgres';
				password: 'secret';
				host: 'localhost';
				port: 5432;
				databaseName: 'test';
				yourself ).

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
