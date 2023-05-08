Class {
	#name : #SingleRDBMSSessionProviderTest,
	#superclass : #TestCase,
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #'private - protocol' }
SingleRDBMSSessionProviderTest class >> failingLogin [
	" This login should always fail - jvanecek "

	<ignoreForCoverage>
	^ Login new
		database: self login database;
		username: 'blabla';
		password: 'blabla';
		host: 'localhost';
		port: 3456;
		databaseName: 'not-a-db';
		yourself
]

{ #category : #'private - protocol' }
SingleRDBMSSessionProviderTest class >> login [

	^ SingleSessionRDMBSRepositoryTest login
]

{ #category : #tests }
SingleRDBMSSessionProviderTest >> testHandleFailingLogin [

	| sessionProvider |

	self timeLimit: 30 seconds.
	self withLoggingAsserterDo: [ :asserter | 
		self
			should: [ 
				asserter
					runMemoryLoggerDuring: [ 
						sessionProvider := SingleRDBMSSessionProvider
							                   loginWith: self class failingLogin
							                   configuredBy: [ :options | options at: #logDatabaseEvents put: true ]
						];
					assertLogRecordsMatch: #(  ).

				asserter
					runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
					assertLogRecordsMatch: #(  )
				]
			raise: DatabaseLoginFailed
			withMessageText: 'ConnectionTimedOut: Cannot connect to 127.0.0.1:3456'.

		asserter assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
			   '[WARNING] Failed to connect to database after 1 attempts because ConnectionTimedOut: Cannot connect to 127.0.0.1:3456'
			   '[DEBUG] Glorp event received {"detail":"Login"}'
			   '[WARNING] Failed to connect to database after 2 attempts because ConnectionTimedOut: Cannot connect to 127.0.0.1:3456'
			   '[DEBUG] Glorp event received {"detail":"Login"}'
			   '[WARNING] Failed to connect to database after 3 attempts because ConnectionTimedOut: Cannot connect to 127.0.0.1:3456'
			   '[DEBUG] Glorp event received {"detail":"Login"}' )
		]
]

{ #category : #tests }
SingleRDBMSSessionProviderTest >> testLogsInWhenSessionFirstUsed [

	| sessionProvider |

	self withLoggingAsserterDo: [ :asserter | 
		asserter
			runMemoryLoggerDuring: [ 
				sessionProvider := SingleRDBMSSessionProvider
					                   loginWith: self class login
					                   configuredBy: [ :options | options at: #logDatabaseEvents put: true ]
				];
			assertLogRecordsMatch: #(  ).

		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' )
		]
]

{ #category : #tests }
SingleRDBMSSessionProviderTest >> testLogsInWhenSessionFoundedDisconnected [

	| sessionProvider |

	sessionProvider := SingleRDBMSSessionProvider
		                   loginWith: self class login
		                   configuredBy: [ :options | options at: #logDatabaseEvents put: true ].

	self withLoggingAsserterDo: [ :asserter | 
		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session | session logout ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Logout"}'
				   '[DEBUG] Glorp event received {"detail":"Logout finished"}' ).

		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Logout"}'
				   '[DEBUG] Glorp event received {"detail":"Logout finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' )
		]
]

{ #category : #tests }
SingleRDBMSSessionProviderTest >> withLoggingAsserterDo: aOneArgBlock [

	| loggingAsserter |

	loggingAsserter := LoggingAsserter on: self.

	[ aOneArgBlock value: loggingAsserter ] ensure: [ loggingAsserter stopLoggers ]
]
