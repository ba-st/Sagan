Class {
	#name : #PooledRDBMSRepositoryProvider,
	#superclass : #RepositoryProvider,
	#instVars : [
		'sessionPool',
		'descriptorSystem',
		'login'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
PooledRDBMSRepositoryProvider class >> using: aLogin [

	^ self new initializeUsing: aLogin
]

{ #category : #building }
PooledRDBMSRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [


	^ RDBMSRepository
		storingObjectsOfType: aBusinessObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: self currentSessionBlock
]

{ #category : #private }
PooledRDBMSRepositoryProvider >> currentSessionBlock [

	^ [ :actionBlock | 
	CurrentRDBMSSession
		withValueDo: [ :wrapper | actionBlock value: wrapper realSession ]
		ifAbsent: [ | wrapper |

			wrapper := SessionReturningToPoolOnFinalize
				wrapping: sessionPool borrow
				returningOnFinalizeTo: sessionPool.
			CurrentRDBMSSession value: wrapper.
			actionBlock value: wrapper realSession
			]
	]
]

{ #category : #initialization }
PooledRDBMSRepositoryProvider >> initializeUsing: aLogin [

	login := aLogin.
	descriptorSystem := ConfigurableDescriptorSystem new.
	sessionPool := OPBasicPool new.
	sessionPool
		creator: [ 
			| session |
			session := DescriptorSystem sessionForLogin: login.
			session system: descriptorSystem.
			session loginIfError: [ :error | DatabaseLoginFailed signal: error description ].
			session
			];
		destroyer: [ :session | session logout ];
		validator: [ :session | session isLoggedIn ];
		passivator: [ :session | session reset ];
		maxIdleObjects: 10;
		minIdleObjects: 5;
		maxActiveObjects: 12
]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> prepareForInitialPersistence [

	self currentSessionBlock
		value: [ :session | 
			session
				recreateTablesIfError: [ :error | Error signal: error description ];
				logout;
				loginIfError: [ :error | Error signal: error description ]
			]
]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> prepareForShutDown [

	CurrentRDBMSSession destroy.
	sessionPool
		minIdleObjects: nil;
		clear
]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> reset [

	CurrentRDBMSSession destroy.
	sessionPool clear
]
