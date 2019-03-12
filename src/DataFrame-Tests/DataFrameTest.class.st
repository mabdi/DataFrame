Class {
	#name : #DataFrameTest,
	#superclass : #TestCase,
	#instVars : [
		'df'
	],
	#category : #'DataFrame-Tests'
}

{ #category : #initialization }
DataFrameTest >> setUp [

	df := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)).
		
	df rowNames: #(A B C).
	df columnNames: #(City Population BeenThere).
]

{ #category : #tests }
DataFrameTest >> testAdd [

	| row expected |
	
	row := DataSeries withValues: #(Paris 2.141 true) name: #X.
	df add: row.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)
		(Paris 2.141 true)).
		
	expected rowNames: #(A B C X).
	expected columnNames: #(City Population BeenThere).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddColumn [

	| column expected |
	
	column := DataSeries withValues: #(2015 2010 2017) name: #Year.
	df addColumn: column.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true 2015)
   		(Dubai 2.789 true 2010)
   		(London 8.788 false 2017)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere Year).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddColumnAtPosition [
	| column expected |
	
	column := DataSeries withValues: #(2015 2010 2017) name: #Year.
	df addColumn: column atPosition: 3.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 2015 true)
   		(Dubai 2.789 2010 true)
   		(London 8.788 2017 false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population Year BeenThere).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddColumnNameMustBeDistinct [

	| series |
	series := DataSeries withValues: #(1 2 3) name: #City.
	self should: [ df addColumn: series ] raise: Error.
]

{ #category : #tests }
DataFrameTest >> testAddColumnNamed [
	| expected |
	
	df addColumn: #(2015 2010 2017) named: #Year.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true 2015)
   		(Dubai 2.789 true 2010)
   		(London 8.788 false 2017)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere Year).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddColumnNamedAtPosition [
	| expected |
	
	df addColumn: #(2015 2010 2017) named: #Year atPosition: 3.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 2015 true)
   		(Dubai 2.789 2010 true)
   		(London 8.788 2017 false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population Year BeenThere).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddColumnNamedNameMustBeDistinct [

	self should: [ df addColumn: #(1 2 3) named: #City ] raise: Error.
]

{ #category : #tests }
DataFrameTest >> testAddEmptyColumnNamed [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true nil)
   		(Dubai 2.789 true nil)
   		(London 8.788 false nil)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere EmptyColumn).
		
	df addEmptyColumnNamed: #EmptyColumn.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddEmptyColumnNamedAtPosition [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 nil true)
   		(Dubai 2.789 nil true)
   		(London 8.788 nil false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population EmptyColumn BeenThere).
		
	df addEmptyColumnNamed: #EmptyColumn atPosition: 3.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddEmptyRowNamed [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)
		(nil nil nil)).
		
	expected rowNames: #(A B C X).
	expected columnNames: #(City Population BeenThere).
		
	df addEmptyRowNamed: #X.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddEmptyRowNamedAtPosition [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
		(nil nil nil)
   		(London 8.788 false)).
		
	expected rowNames: #(A B X C).
	expected columnNames: #(City Population BeenThere).
		
	df addEmptyRowNamed: #X atPosition: 3.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddRow [

	| row expected |
	
	row := DataSeries withValues: #(Paris 2.141 true) name: #X.
	df addRow: row.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)
		(Paris 2.141 true)).
		
	expected rowNames: #(A B C X).
	expected columnNames: #(City Population BeenThere).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddRowAtPosition [
	| row expected |
	
	row := DataSeries withValues: #(Paris 2.141 true) name: #X.
	df addRow: row atPosition: 2.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
		(Paris 2.141 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)).
		
	expected rowNames: #(A X B C).
	expected columnNames: #(City Population BeenThere).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddRowNameMustBeDistinct [

	| series |
	series := DataSeries withValues: #(1 2 3) name: #A.
	self should: [ df addRow: series ] raise: Error.
]

{ #category : #tests }
DataFrameTest >> testAddRowNamed [
	| expected |
	
	df addRow: #(Paris 2.141 true) named: #X.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)
		(Paris 2.141 true)).
		
	expected rowNames: #(A B C X).
	expected columnNames: #(City Population BeenThere).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddRowNamedAtPosition [
	| expected |
	
	df addRow: #(Paris 2.141 true) named: #X atPosition: 2.
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
		(Paris 2.141 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)).
		
	expected rowNames: #(A X B C).
	expected columnNames: #(City Population BeenThere).
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAddRowNamedNameMustBeDistinct [

	self should: [ df addRow: #(1 2 3) named: #A ] raise: Error.
]

{ #category : #tests }
DataFrameTest >> testAddRowSizeMismatch [

	| aBlock |
	aBlock := [ df addRow: #(1 2) named: #TooSmall ].
	
	self should: aBlock raise: SizeMismatch.
]

{ #category : #tests }
DataFrameTest >> testAsArrayOfColumns [

	| expected |
	
	expected := #(
		('Barcelona' 'Dubai' 'London')
		(1.609 2.789 8.788)
   		(true true false)).
	
	self assert: df asArrayOfColumns equals: expected.
	

]

{ #category : #tests }
DataFrameTest >> testAsArrayOfRows [

	| expected |
	
	expected := {
		#('Barcelona' 1.609 true) asDataSeries name: 'A'; keys: df columnNames; yourself .
   		#('Dubai' 2.789 true) asDataSeries name: 'B'; keys: df columnNames; yourself .
   		#('London' 8.788 false) asDataSeries name: 'C'; keys: df columnNames; yourself
	}.
	
	self assert: df asArrayOfRows equals: expected.
	

]

{ #category : #tests }
DataFrameTest >> testAt [

	| actual expected |

	expected := DataSeries withValues:
		#('Dubai' 2.789 true).
		
	expected name: #B.
	expected keys: df columnNames.
	
	actual := df at: 2.
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testAtAt [

	self assert: (df at: 2 at: 1) equals: 'Dubai'.
]

{ #category : #tests }
DataFrameTest >> testAtAtPut [

	| expectedDataFrame |
	
	expectedDataFrame := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
   		(London 1000 false)).
		
	expectedDataFrame rowNames: df rowNames.
	expectedDataFrame columnNames: df columnNames.
		
	df at: 3 at: 2 put: 1000.
			
	self assert: df equals: expectedDataFrame. 
]

{ #category : #tests }
DataFrameTest >> testCollect [
	| expectedDf expectedResult actualResult |
	
	expectedDf := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
   		(London 8.788 false)).
		
	expectedDf rowNames: #(A B C).
	expectedDf columnNames: #(City Population BeenThere).
	
	expectedResult := DataFrame withRows: #(
		('BARCELONA' 1)
   		('DUBAI' 2)
   		('LONDON' 8)).
		
	expectedResult rowNames: #(A B C).
	expectedResult columnNames: #(City Population).
	
	actualResult := df collect: [ :row |
		row atKey: #City put: (row atKey: #City) asUppercase.
		row atKey: #Population put: (row atKey: #Population) asInteger.
		row removeAtKey: #BeenThere.
		row ].
	
	self assert: actualResult equals: expectedResult.
	self assert: df equals: expectedDf.
]

{ #category : #tests }
DataFrameTest >> testColumn [

	| actualSeries expectedSeries |

	expectedSeries := DataSeries withValues:
		#(Barcelona Dubai London).
	
	expectedSeries name: #City.
	expectedSeries keys: df rowNames.
	
	actualSeries := df column: #City.
	
	self assert: actualSeries equals: expectedSeries.
]

{ #category : #tests }
DataFrameTest >> testColumnAt [

	| actualSeries expectedSeries |

	expectedSeries := DataSeries withValues:
		#(Barcelona Dubai London).
	
	expectedSeries name: #City.
	expectedSeries keys: df rowNames.
	
	actualSeries := df columnAt: 1.
	
	self assert: actualSeries equals: expectedSeries.
]

{ #category : #tests }
DataFrameTest >> testColumnAtPut [

	| actual expected |

	expected := DataFrame withRows: #(
		('X' 1.609 0)
   		('Y' 2.789 1)
   		('Z' 8.788 0)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
	
	actual := df.
	actual columnAt: 1 put: #('X' 'Y' 'Z').
	actual columnAt: 3 put: #(0 1 0).
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testColumnNames [
	| newNames |
	newNames := #(X Y Z).
	df columnNames: newNames.
	self assert: df columnNames equals: newNames asOrderedCollection
]

{ #category : #tests }
DataFrameTest >> testColumnNamesMustBeDistinct [
	| newNames |
	newNames := #(x y y).
	self should: [ df columnNames: newNames ] raise: Error.
]

{ #category : #tests }
DataFrameTest >> testColumnNamesSizeMismatch [
	| tooManyNames notEnoughNames |
	
	tooManyNames := #(W X Y Z).
	notEnoughNames := #(Y Z).
	
	self should: [ df columnNames: tooManyNames ] raise: SizeMismatch.
	self should: [ df columnNames: notEnoughNames ] raise: SizeMismatch.
]

{ #category : #tests }
DataFrameTest >> testColumnPut [

	| actual expected |

	expected := DataFrame withRows: #(
		('X' 1.609 0)
   		('Y' 2.789 1)
   		('Z' 8.788 0)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
	
	actual := df.
	actual column: #City put: #('X' 'Y' 'Z').
	actual column: #BeenThere put: #(0 1 0).
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testColumns [

	| columnNames actualDataFrame expectedDataFrame |
	
	columnNames := #(City BeenThere).
	
	expectedDataFrame := DataFrame withRows: #(
		(Barcelona true)
   		(Dubai true)
   		(London false)).
		
	expectedDataFrame rowNames: df rowNames.
	expectedDataFrame columnNames: columnNames.
	
	actualDataFrame := df columns: columnNames.
	
	self assert: actualDataFrame equals: expectedDataFrame.
]

{ #category : #tests }
DataFrameTest >> testColumnsAt [

	| columnNumbers actualDataFrame expectedDataFrame |
	
	columnNumbers := #(1 3).
	
	expectedDataFrame := DataFrame withRows: #(
		(Barcelona true)
   		(Dubai true)
   		(London false)).
		
	expectedDataFrame rowNames: df rowNames.
	expectedDataFrame columnNames:
		(columnNumbers collect: [ :i |
			df columnNames at: i ]).
	
	actualDataFrame := df columnsAt: columnNumbers.
	
	self assert: actualDataFrame equals: expectedDataFrame.
]

{ #category : #tests }
DataFrameTest >> testColumnsFromTo [

	| actualDataFrame expectedDataFrame |
		
	expectedDataFrame := DataFrame withRows: #(
		(1.609 true)
   		(2.789 true)
   		(8.788 false)).
		
	expectedDataFrame rowNames: df rowNames.
	expectedDataFrame columnNames: #(Population BeenThere).
	
	actualDataFrame := df columnsFrom: 2 to: 3.
	
	self assert: actualDataFrame equals: expectedDataFrame.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWith3ColumnsAndNoRows [
	| dataFrame |
	dataFrame := DataFrame new: 0@3.
	
	self assert: dataFrame class equals: DataFrame.
	self assert: dataFrame dimensions equals: 0@3.
	self assert: dataFrame rowNames equals: #() asOrderedCollection.
	self assert: dataFrame columnNames equals: #(1 2 3) asOrderedCollection.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithColumns [

	| columns dataFrame expectedValues |
	
	columns := #(
		('Robb Stark' 'Jon Snow' 'Eddard Stark')
    	(3 4 1)
      	(true false true)).
	
	dataFrame := DataFrame withColumns: columns.
	
	self assert: dataFrame rowNames equals: #(1 2 3) asOrderedCollection.
	self assert: dataFrame columnNames equals: #(1 2 3) asOrderedCollection.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withColumns: columns.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithColumnsColumnNames [

	| columns columnNames dataFrame expectedValues |
	
	columns := #(
		('Robb Stark' 'Jon Snow' 'Eddard Stark')
    	(3 4 1)
      	(true false true)).
	
	columnNames := #(Name Book IsAlive) asOrderedCollection.
	dataFrame := DataFrame
		withColumns: columns
		columnNames: columnNames.
	
	self assert: dataFrame rowNames equals: #(1 2 3) asOrderedCollection.
	self assert: dataFrame columnNames equals: columnNames.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withColumns: columns.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithColumnsRowNames [

	| columns rowNames dataFrame expectedValues |
	
	columns := #(
		('Robb Stark' 'Jon Snow' 'Eddard Stark')
    	(3 4 1)
      	(true false true)).
	
	rowNames := #(A B C) asOrderedCollection.
	dataFrame := DataFrame
		withColumns: columns
		rowNames: rowNames.
	
	self assert: dataFrame rowNames equals: rowNames.
	self assert: dataFrame columnNames equals: #(1 2 3) asOrderedCollection.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withColumns: columns.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithColumnsRowNamesColumnNames [

	| columns rowNames columnNames dataFrame expectedValues |
	
	columns := #(
		('Robb Stark' 'Jon Snow' 'Eddard Stark')
    	(3 4 1)
      	(true false true)).
	
	rowNames := #(A B C) asOrderedCollection.
	columnNames := #(Name Book IsAlive) asOrderedCollection.
	
	dataFrame := DataFrame
		withColumns: columns
		rowNames: rowNames
		columnNames: columnNames.
	
	self assert: dataFrame rowNames equals: rowNames.
	self assert: dataFrame columnNames equals: columnNames.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withColumns: columns.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithDataFrameInternalRowNamesColumnNames [

	| rows dataFrameInternal rowNames columnNames dataFrame expectedValues |
	
	rows := #(
		('Robb Stark' 3 true)
    	('Jon Snow' 4 false)
      	('Eddard Stark' 1 true)).
	
	dataFrameInternal := DataFrameInternal withRows: rows.
	rowNames := #(A B C) asOrderedCollection.
	columnNames := #(Name Book IsAlive) asOrderedCollection.
	
	dataFrame := DataFrame
		withDataFrameInternal: dataFrameInternal
		rowNames: rowNames
		columnNames: columnNames.
	
	self assert: dataFrame rowNames equals: rowNames.
	self assert: dataFrame columnNames equals: columnNames.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withRows: rows.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithRows [

	| rows dataFrame expectedValues |
	
	rows := #(
		('Robb Stark' 3 true)
    	('Jon Snow' 4 false)
      	('Eddard Stark' 1 true)).
	
	dataFrame := DataFrame
		withRows: rows.
	
	self assert: dataFrame rowNames equals: #(1 2 3) asOrderedCollection.
	self assert: dataFrame columnNames equals: #(1 2 3) asOrderedCollection.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withRows: rows.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithRowsColumnNames [

	| rows columnNames dataFrame expectedValues |
	
	rows := #(
		('Robb Stark' 3 true)
    	('Jon Snow' 4 false)
      	('Eddard Stark' 1 true)).
	
	columnNames := #(Name Book IsAlive) asOrderedCollection.
	
	dataFrame := DataFrame
		withRows: rows
		columnNames: columnNames.
	
	self assert: dataFrame rowNames equals: #(1 2 3) asOrderedCollection.
	self assert: dataFrame columnNames equals: columnNames.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withRows: rows.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithRowsRowNames [

	| rows rowNames dataFrame expectedValues |
	
	rows := #(
		('Robb Stark' 3 true)
    	('Jon Snow' 4 false)
      	('Eddard Stark' 1 true)).
	
	rowNames := #(A B C) asOrderedCollection.
	
	dataFrame := DataFrame
		withRows: rows
		rowNames: rowNames.
	
	self assert: dataFrame rowNames equals: rowNames.
	self assert: dataFrame columnNames equals: #(1 2 3) asOrderedCollection.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withRows: rows.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateDataFrameWithRowsRowNamesColumnNames [

	| rows rowNames columnNames dataFrame expectedValues |
	
	rows := #(
		('Robb Stark' 3 true)
    	('Jon Snow' 4 false)
      	('Eddard Stark' 1 true)).
	
	rowNames := #(A B C) asOrderedCollection.
	columnNames := #(Name Book IsAlive) asOrderedCollection.
	
	dataFrame := DataFrame
		withRows: rows
		rowNames: rowNames
		columnNames: columnNames.
	
	self assert: dataFrame rowNames equals: rowNames.
	self assert: dataFrame columnNames equals: columnNames.
	
	"We know that it works, because we have tests for it in DataFrameInternalTests"
	expectedValues := DataFrameInternal withRows: rows.
	
	self assert: dataFrame contents equals: expectedValues.
]

{ #category : #tests }
DataFrameTest >> testCreateEmptyDataFrame [
	| dataFrame |
	dataFrame := DataFrame new.
	
	self assert: dataFrame class equals: DataFrame.
	self assert: dataFrame dimensions equals: 0@0.
	self assert: dataFrame rowNames equals: #() asOrderedCollection.
	self assert: dataFrame columnNames equals: #() asOrderedCollection.
]

{ #category : #tests }
DataFrameTest >> testCreateEmptyDataFrameWithColumnNames [
	| columnNames dataFrame |
	
	columnNames := #(Name Age Nationality) asOrderedCollection.
	dataFrame := DataFrame withColumnNames: columnNames.
	
	self assert: dataFrame class equals: DataFrame.
	self assert: dataFrame dimensions equals: 0@3.
	self assert: dataFrame rowNames equals: #() asOrderedCollection.
	self assert: dataFrame columnNames equals: columnNames.
]

{ #category : #tests }
DataFrameTest >> testCreateEmptyDataFrameWithRowNames [
	| rowNames dataFrame |
	
	rowNames := #(A B C) asOrderedCollection.
	dataFrame := DataFrame withRowNames: rowNames.
	
	self assert: dataFrame class equals: DataFrame.
	self assert: dataFrame dimensions equals: 3@0.
	self assert: dataFrame rowNames equals: rowNames.
	self assert: dataFrame columnNames equals: #() asOrderedCollection.
]

{ #category : #tests }
DataFrameTest >> testCreateEmptyDataFrameWithRowNamesColumnNames [
	| rowNames columnNames dataFrame |
	
	rowNames := #(A B C) asOrderedCollection.
	columnNames := #(Name Age Nationality) asOrderedCollection.
	
	dataFrame := DataFrame
		withRowNames: rowNames
		columnNames: columnNames.
	
	self assert: dataFrame class equals: DataFrame.
	self assert: dataFrame dimensions equals: 3@3.
	self assert: dataFrame rowNames equals: rowNames.
	self assert: dataFrame columnNames equals: columnNames.
]

{ #category : #tests }
DataFrameTest >> testCrossTabulation [

	| dataFrame expected |
	
	dataFrame := DataFrame withRows: #(
		(Male Young)
		(Female Old)
		(Female Young)
		(Female Young)
		(Male Old)).
	dataFrame columnNames: #(Gender Age).
	
	expected := DataFrame withRows:
		#((2 1)(1 1)).
		
	expected rowNames: #(Female Male).
	expected columnNames: #(Young Old).	
	
	self assert: (dataFrame crossTabulate: #Gender with: #Age) equals: expected.
]

{ #category : #tests }
DataFrameTest >> testDo [

	| actual expected |

	expected := OrderedCollection
		with: #(Barcelona 1.609 true) asDataSeries
		with: #(Dubai 2.789 true) asDataSeries
		with: #(London 8.788 false) asDataSeries.
		
	expected doWithIndex: [ :each :i |
		each keys: #(City Population BeenThere).
		each name: (#(A B C) at: i) ].
		
	actual := OrderedCollection new.
	
	df do: [ :each |
		actual add: each ].
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testEquality [

	| df1 df2 |
	
	df1 := DataFrame withRows: #((1 2)(3 4)).
	df2 := DataFrame withRows: #((1 2)(3 4)).
	
	self assert: df1 equals: df2.
	self assert: (df1 = df2).
]

{ #category : #tests }
DataFrameTest >> testInequality [

	| df1 df2 df3 df4 df5 |
	
	"Other data frames will be compared to this one"
	df1 := DataFrame withRows: #((1 2)(3 4)).
	df1 rowNames: #(a b).
	df1 columnNames: #(x y).
	
	"This one has different row names"
	df2 := DataFrame withRows: #((1 2)(3 4)).
	df2 rowNames: #(c b).
	df2 columnNames: #(x y).
	
	"This one has different column names"
	df3 := DataFrame withRows: #((1 2)(3 4)).
	df3 rowNames: #(a b).
	df3 columnNames: #(x z).
	
	"This one has different dimensions"
	df4 := DataFrame withRows: #((1 2)(3 4)(5 6)).
	df4 rowNames: #(a b c).
	df4 columnNames: #(x z).
	
	"This one has different values"
	df5 := DataFrame withRows: #((1 2)(3 5)).
	df5 rowNames: #(a b).
	df5 columnNames: #(x z).

	self assert: (df2 = df1) not.
	self assert: (df3 = df1) not.
	self assert: (df4 = df1) not.
	self assert: (df5 = df1) not.
]

{ #category : #tests }
DataFrameTest >> testPrintOn [

	| expected actual |
	
	expected := 'a DataFrame (3@3)'.
	
	actual := String new writeStream.
	df printOn: actual.
	actual := actual contents.
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRemoveColumn [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona true)
   		(Dubai true)
   		(London false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City BeenThere).
		
	df removeColumn: #Population.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRemoveColumnAt [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona true)
   		(Dubai true)
   		(London false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City BeenThere).
		
	df removeColumnAt: 2.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRemoveFirstRow [

	| expected |
	
	expected := DataFrame withRows: #(
   		(Dubai 2.789 true)
   		(London 8.788 false)).
		
	expected rowNames: #(B C).
	expected columnNames: #(City Population BeenThere).
		
	df removeFirstRow.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRemoveLastRow [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)).
		
	expected rowNames: #(A B).
	expected columnNames: #(City Population BeenThere).
		
	df removeLastRow.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRemoveRow [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(London 8.788 false)).
		
	expected rowNames: #(A C).
	expected columnNames: #(City Population BeenThere).
		
	df removeRow: #B.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRemoveRowAt [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(London 8.788 false)).
		
	expected rowNames: #(A C).
	expected columnNames: #(City Population BeenThere).
		
	df removeRowAt: 2.
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRow [

	| actualSeries expectedSeries |

	expectedSeries := DataSeries withValues:
		#('Dubai' 2.789 true).
		
	expectedSeries name: #B.
	expectedSeries keys: df columnNames.
	
	actualSeries := df row: #B.
	
	self assert: actualSeries equals: expectedSeries.
]

{ #category : #tests }
DataFrameTest >> testRowAt [

	| actualSeries expectedSeries |

	expectedSeries := DataSeries withValues:
		#('Dubai' 2.789 true).
		
	expectedSeries name: #B.
	expectedSeries keys: df columnNames.
	
	actualSeries := df rowAt: 2.
	
	self assert: actualSeries equals: expectedSeries.
]

{ #category : #tests }
DataFrameTest >> testRowAtPut [

	| actual expected |

	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(X Y Z)
   		(London 8.788 false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
	
	actual := df.
	actual rowAt: 2 put: #(X Y Z).
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRowNames [
	| newNames |
	newNames := #(X Y Z).
	df rowNames: newNames.
	self assert: df rowNames equals: newNames asOrderedCollection
]

{ #category : #tests }
DataFrameTest >> testRowNamesMustBeDistinct [
	| newNames |
	newNames := #(x y y).
	self should: [ df rowNames: newNames ] raise: Error.
]

{ #category : #tests }
DataFrameTest >> testRowNamesSizeMismatch [
	| tooManyNames notEnoughNames |
	
	tooManyNames := #(W X Y Z).
	notEnoughNames := #(Y Z).
	
	self should: [ df rowNames: tooManyNames ] raise: SizeMismatch.
	self should: [ df rowNames: notEnoughNames ] raise: SizeMismatch.
]

{ #category : #tests }
DataFrameTest >> testRowPut [

	| actual expected |

	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(X Y Z)
   		(London 8.788 false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
	
	actual := df.
	actual row: #B put: #(X Y Z).
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testRows [

	| rowNames actualDataFrame expectedDataFrame |
	
	rowNames := #(A C).
	
	expectedDataFrame := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(London 8.788 false)).
		
	expectedDataFrame rowNames: rowNames.
	expectedDataFrame columnNames: df columnNames.
	
	actualDataFrame := df rows: rowNames.
	
	self assert: actualDataFrame equals: expectedDataFrame.
]

{ #category : #tests }
DataFrameTest >> testRowsAt [

	| rowNumbers actualDataFrame expectedDataFrame |
	
	rowNumbers := #(1 3).
	
	expectedDataFrame := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(London 8.788 false)).
		
	expectedDataFrame rowNames:
		(rowNumbers collect: [ :i |
			df rowNames at: i ]).
	expectedDataFrame columnNames: df columnNames.
	
	actualDataFrame := df rowsAt: rowNumbers.
	
	self assert: actualDataFrame equals: expectedDataFrame.
]

{ #category : #tests }
DataFrameTest >> testRowsFromTo [

	| actualDataFrame expectedDataFrame |
		
	expectedDataFrame := DataFrame withRows: #(
   		(Dubai 2.789 true)
   		(London 8.788 false)).
		
	expectedDataFrame rowNames: #(B C).
	expectedDataFrame columnNames: df columnNames.
	
	actualDataFrame := df rowsFrom: 2 to: 3.
	
	self assert: actualDataFrame equals: expectedDataFrame.
]

{ #category : #tests }
DataFrameTest >> testSortBy [

	| actual expected |

	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
   		(Dubai 2.789 true)
		(London 8.788 false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
	
	actual := df sortBy: #Population.
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testSortByUsing [
	"Sort by second letter of city name"
	| actual expected |

	expected := DataFrame withRows: #(
		(Barcelona 1.609 true)
		(London 8.788 false)
		(Dubai 2.789 true)).
		
	expected rowNames: #(A C B).
	expected columnNames: #(City Population BeenThere).
	
	actual := df sortBy: #City using: [ :name1 :name2 |
		name1 second <= name2 second ].
	
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testSortDescendingBy [

	| actual expected |

	expected := DataFrame withRows: #(
		(London 8.788 false)
		(Dubai 2.789 true)
		(Barcelona 1.609 true)).
		
	expected rowNames: #(C B A).
	expected columnNames: #(City Population BeenThere).
	
	actual := df sortDescendingBy: #Population.
	self assert: actual equals: expected.
]

{ #category : #tests }
DataFrameTest >> testToColumnApplyElementwise [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona '1.609' true)
   		(Dubai '2.789' true)
   		(London '8.788' false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
		
	df toColumn: #Population
		applyElementwise: [ :each | each asString ].
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testToColumnAtApplyElementwise [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona '1.609' true)
   		(Dubai '2.789' true)
   		(London '8.788' false)).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
		
	df toColumnAt: 2
		applyElementwise: [ :each | each asString ].
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testToColumnsApplyElementwise [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona '1.609' 'true')
   		(Dubai '2.789' 'true')
   		(London '8.788' 'false')).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
		
	df toColumns: #(Population BeenThere)
		applyElementwise: [ :each | each asString ].
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testToColumnsAtApplyElementwise [

	| expected |
	
	expected := DataFrame withRows: #(
		(Barcelona '1.609' 'true')
   		(Dubai '2.789' 'true')
   		(London '8.788' 'false')).
		
	expected rowNames: #(A B C).
	expected columnNames: #(City Population BeenThere).
		
	df toColumnsAt: #(2 3)
		applyElementwise: [ :each | each asString ].
	
	self assert: df equals: expected.
]

{ #category : #tests }
DataFrameTest >> testTransposed [

	| expected |
	
	expected := DataFrame withRows: #(
		('Barcelona' 'Dubai' 'London')
		(1.609 2.789 8.788)
   		(true true false)).
		
	expected rowNames: df columnNames.
	expected columnNames: df rowNames.
	
	self assert: df transposed equals: expected.
	

]

{ #category : #tests }
DataFrameTest >> testVarSizeInstanceCreation [

	| dataFrame |
	dataFrame := DataFrame new: 3@2.
	
	self assert: dataFrame numberOfRows equals: 3.
	self assert: dataFrame numberOfColumns equals: 2.
	
	self assert: dataFrame rowNames equals: #(1 2 3) asOrderedCollection.
	self assert: dataFrame columnNames equals: #(1 2) asOrderedCollection.
]

{ #category : #tests }
DataFrameTest >> testWithKeyDo [

	| actual expected |

	expected := Dictionary new.
	expected at: #A put: #(Barcelona 1.609 true) asDataSeries.
	expected at: #B put: #(Dubai 2.789 true) asDataSeries.
	expected at: #C put: #(London 8.788 false) asDataSeries.
		
	expected keysAndValuesDo: [ :name :each |
		each keys: #(City Population BeenThere).
		each name: name ].
		
	actual := Dictionary new.
	
	df withKeyDo: [ :each :key |
		actual at: key put: each ].
	
	self assert: actual equals: expected.
]