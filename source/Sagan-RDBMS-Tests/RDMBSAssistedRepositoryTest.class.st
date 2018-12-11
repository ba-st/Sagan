Class {
	#name : #RDMBSAssistedRepositoryTest,
	#superclass : #RepositoryBasedTest,
	#instVars : [
		'session'
	],
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #initialization }
RDMBSAssistedRepositoryTest >> configureMappings [

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
RDMBSAssistedRepositoryTest >> createSession [

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
	accessor logging: true.
	^ GlorpSession new
		accessor: accessor;
		system: ConfigurableDescriptorSystem new;
		yourself
]

{ #category : #initialization }
RDMBSAssistedRepositoryTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	session := self createSession.
	repository := RDMBSAssistedRepository
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
RDMBSAssistedRepositoryTest >> tearDown [

	session ifNotNil: [ session logout ].
	super tearDown
]
