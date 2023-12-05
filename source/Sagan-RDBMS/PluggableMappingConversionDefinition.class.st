Class {
	#name : 'PluggableMappingConversionDefinition',
	#superclass : 'MappingConversionDefinition',
	#instVars : [
		'fromDatabaseToSmalltalkBlock',
		'fromSmalltalkToDatabaseBlock',
		'converterName'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
PluggableMappingConversionDefinition class >> named: aConverterNameOrString
	convertingFromDatabaseToSmalltalkUsing: aFromDatabaseConversionBlock
	fromSmalltalkToDatabaseUsing: aFromSmalltalkConversionBlock [


	^ self new
		initializeNamed: aConverterNameOrString asSymbol
		convertingFromDatabaseToSmalltalkUsing: aFromDatabaseConversionBlock
		fromSmalltalkToDatabseUsing: aFromSmalltalkConversionBlock
]

{ #category : 'Defining' }
PluggableMappingConversionDefinition >> defineConversionOn: aMapping using: aDescriptorSystem [

	^ aDescriptorSystem
		definePluggableConversionOn: aMapping
		named: converterName
		convertingFromDatabaseToSmalltalkUsing: fromDatabaseToSmalltalkBlock
		fromSmalltalkToDatabaseUsing: fromSmalltalkToDatabaseBlock
]

{ #category : 'Initialization' }
PluggableMappingConversionDefinition >> initializeNamed: aConverterName
	convertingFromDatabaseToSmalltalkUsing: aFromDatabaseConversionBlock
	fromSmalltalkToDatabseUsing: aFromSmalltalkConversionBlock [


	converterName := aConverterName.
	fromDatabaseToSmalltalkBlock := aFromDatabaseConversionBlock.
	fromSmalltalkToDatabaseBlock := aFromSmalltalkConversionBlock
]
