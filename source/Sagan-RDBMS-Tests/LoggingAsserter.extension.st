Extension { #name : 'LoggingAsserter' }

{ #category : '*Sagan-RDBMS-Tests' }
LoggingAsserter >> assertLogRecordsMatchInTheFollowingOrder: expectedLogEntries [

	"Logs are producted by database, so this is a best effort to 
	test they appear in the right order - fortizpenaloza"

	| indexes |

	indexes := expectedLogEntries collect: [ :expectedLogEntry | 
		           memoryLogger recordings
			           detectIndex: [ :record | record printString includesSubstring: expectedLogEntry ]
			           ifNone: [ testCase fail ]
		           ].

	testCase assert: indexes equals: ( indexes sorted: [ :a :b | a < b ] )
]
