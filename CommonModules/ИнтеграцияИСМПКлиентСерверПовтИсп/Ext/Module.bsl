﻿#Область ПрограммныйИнтерфейс

// Возвращает дату обязательной маркировки маркируемой продукци переданного вида.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
// Возвращаемое значение:
// 	Дата - дата обязательной маркировки маркируемой продукции.
//
Функция ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции);
	
КонецФункции

// Возвращает признак ведения учета маркируемой продукци переданного вида.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
// Возвращаемое значение:
// 	Булево - признак ведения учета маркируемой продукции переданного вида.
//
Функция ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции = Неопределено) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции);
	
КонецФункции

//Возвращает виды маркируемой продукции по которым ведется учет.
// Параметры:
//  ПродукцияИСМП - Булево - Будет добавлена продукция ИСМП
//  ПродукцияМОТП - Булево - Будет добавлена продукция МОТП
//Возвращаемое значение:
//   ФиксированныйМассив Из ПеречислениеСсылка.ВидыПродукцииИС - виды маркируемой продукции.
//
Функция УчитываемыеВидыМаркируемойПродукции(ПродукцияИСМП = Истина, ПродукцияМОТП = Истина) Экспорт
	
	ВидыМаркируемойПродукции = ИнтеграцияИСМПВызовСервера.УчитываемыеВидыМаркируемойПродукции();
	
	Если ПродукцияИСМП И ПродукцияМОТП Тогда
		Возврат ВидыМаркируемойПродукции;
	КонецЕсли;
	
	ВидыПродукции = Новый Массив;
	
	Для Каждого ВидПродукции Из ВидыМаркируемойПродукции Цикл
		Если ПродукцияИСМП И ИнтеграцияИСКлиентСервер.ЭтоПродукцияИСМП(ВидПродукции)
			Или ПродукцияМОТП И ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
			ВидыПродукции.Добавить(ВидПродукции);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ВидыПродукции);
	
КонецФункции

// Проверяет необходимость обязательной регистрации оборота маркируемой продукции переданного вида на переданную дату.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
//  НаДату - Дата - дата оборота маркируемой продукции
// Возвращаемое значение:
//  Булево - Истина, если на переданную дату в системе установлен признак ведения учета по переданному виду маркируемой продукции.
//
Функция ОбязательнаяРегистрацияОборотаМаркируемойПродукции(ВидМаркируемойПродукции, НаДату) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	ИначеЕсли НЕ ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	Иначе
		Возврат НаДату >= ИнтеграцияИСМПКлиентСерверПовтИсп.ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции);
	КонецЕсли;
	
КонецФункции

// Проверяет что регистрация оборота маркируемой продукции переданного вида производится в тестовом режиме на переданную дату.
// 
// Параметры:
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
//  НаДату - Дата - дата оборота маркируемой продукции
// Возвращаемое значение:
//  Булево - Истина, если в системе установлен признак ведения учета по переданному виду маркируемой продукции и дата оборота менее даты обязательной регистрации.
//
Функция ТестоваяРегистрацияОборотаМаркируемойПродукции(ВидМаркируемойПродукции, НаДату) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	ИначеЕсли НЕ ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(ВидМаркируемойПродукции) Тогда
		Возврат Ложь;
	Иначе
		Возврат НаДату < ИнтеграцияИСМПКлиентСерверПовтИсп.ДатаОбязательнойМаркировкиПродукции(ВидМаркируемойПродукции);
	КонецЕсли;
	
КонецФункции

//Возвращает виды маркируемой продукции в тестовом режиме на переданную дату.
//
//Параметры:
//   НаДату - Дата - дата оборота маркируемой продукции
//
//Возвращаемое значение:
//   ФиксированныйМассив Из ПеречислениеСсылка.ВидыПродукцииИС - виды маркируемой продукции, по которым установлен 
//   признак ведения учета и дата оборота менее даты обязательной регистрации.
//
Функция ВидыПродукцииТестовогоПериода(НаДату) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.УчитываемыеВидыМаркируемойПродукции(НаДату, Истина);
	
КонецФункции

//Возвращает виды маркируемой продукции в тестовом режиме на переданную дату.
//
//Параметры:
//   НаДату - Дата - дата оборота маркируемой продукции
//
//Возвращаемое значение:
//   ФиксированныйМассив Из ПеречислениеСсылка.ВидыПродукцииИС - виды маркируемой продукции, по которым установлен 
//   признак ведения учета и дата оборота менее даты обязательной регистрации.
//
Функция ВидыПродукцииОбязательнойМаркировки(НаДату) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.УчитываемыеВидыМаркируемойПродукции(НаДату, Ложь);
	
КонецФункции

//Возвращает признак запроса данных из сервиса ИС МП.
//
//Возвращаемое значение:
//   Булево - Истина, в случае необходимости запроса данных сервиса.
//
Функция ЗапрашиватьДанныеСервиса() Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.ЗапрашиватьДанныеСервиса();

КонецФункции

//Возвращает признак необходимости контроля статусов кодов маркировок ИС МП.
//
//Параметры:
//	 ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции
//	 ВидОперации  - ПеречислениеСсылка.ВидыОперацийИСМП, Неопределено - Вид операции.
//
//Возвращаемое значение:
//   Булево - Истина, в случае необходимости контроля статусов
//
Функция КонтролироватьСтатусыКодовМаркировки(ВидПродукции = Неопределено, ВидОперации = Неопределено) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.КонтролироватьСтатусыКодовМаркировки(ВидПродукции, ВидОперации);

КонецФункции

//Возвращает признак необходимости контроля статусов кодов маркировок ИС МП при розничной торговле.
//
//Параметры:
//	 ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции
//	 ВидОперации  - ПеречислениеСсылка.ВидыОперацийИСМП, Неопределено - Вид операции.
//Возвращаемое значение:
//   Булево - Истина, в случае необходимости контроля статусов.
//
Функция КонтролироватьСтатусыКодовМаркировкиВРознице(ВидПродукции = Неопределено, ВидОперации = Неопределено) Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.КонтролироватьСтатусыКодовМаркировкиВРознице(ВидПродукции, ВидОперации);

КонецФункции

// Возвращает настройки сканирования кодов маркировки ИС МП.
//
// Возвращаемое значение:
//  Булево - Истина, в случае необходимости контроля статусов.
Функция НастройкиСканированияКодовМаркировки() Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.НастройкиСканированияКодовМаркировки();

КонецФункции

Функция СлужебныйШтрихкодПечатиУпаковки() Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.НастройкиСканированияКодовМаркировки().СлужебныйШтрихкодПечатиУпаковки;
	
КонецФункции

//Возвращает признак наличия типа метаданных конфигурации в типе реквизита "ДокументОснование"
//   Наличие типа означает то, что документ может иметь документ-основание.
//
//Возвращаемое значение:
//   Булево - Истина, если документ может иметь документ-основание.
//
Функция ДокументМожетИметьДокументОснование(ПолноеИмяМетаданных) Экспорт

	Возврат ИнтеграцияИСМПВызовСервера.ДокументМожетИметьДокументОснование(ПолноеИмяМетаданных);

КонецФункции

// Определяет признак учета в системе МРЦ.
// 
// Возвращаемое значение:
// 	Булево - Включено ведение учетаю
Функция УчитыватьМРЦ() Экспорт
	
	Возврат ИнтеграцияИСМПКлиентСерверПовтИсп.НастройкиСканированияКодовМаркировки().УчитыватьМРЦ;
	
КонецФункции

// Классифицирует текущий сеанс, как сеанс, запущенный в фоновом задании в клиент-серверном варианте, в остальных
// случаях, сеанс имеет ту же файловую систему на стороне сервера, что и основной сеанс.
//	
// Возвращаемое значение:
// 	Булево - Описание
Функция ЭтоФоновоеЗаданиеНаСервере() Экспорт
	Возврат ИнтеграцияИСМПВызовСервера.ЭтоФоновоеЗаданиеНаСервере();
КонецФункции

// Возвращает признак включения режима работы с тестовым контуром ИС МП
//
// Возвращаемое значение:
//  Булево - Истина, если включен режим работы с тестовым контуром ИС МП.
//
Функция РежимРаботыСТестовымКонтуромИСМП() Экспорт
	
	Возврат ИнтеграцияИСМПВызовСервера.РежимРаботыСТестовымКонтуромИСМП();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ЧастичноеВыбытие

// Возвращает признак возможности для вида продукции (и вида операции) участвовать в частичном выбытии.
// 
// Параметры:
//  ВидПродукции    - ПеречислениеСсылка.ВидыПродукцииИС                - вид маркируемой продукции.
//  ВидОперацииИСМП - ПеречислениеСсылка.ВидыОперацийИСМП, Неопределено - вид операции ИСМП.
// Возвращаемое значение:
//  Булево - Вид продукци (в текущей операции) может выбывать частично.
Функция ПоддерживаетсяЧастичноеВыбытие(ВидПродукции, ВидОперацииИСМП = Неопределено) Экспорт
	
	ПоддерживаетсяЧастичноеВыбытие = Ложь;
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак") Тогда
		
		РозничныеОперации = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ОперацииРозничнойТорговли();
		
		Если ВидОперацииИСМП = Неопределено
			Или РозничныеОперации.Найти(ВидОперацииИСМП) <> Неопределено Тогда
			ПоддерживаетсяЧастичноеВыбытие = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПоддерживаетсяЧастичноеВыбытие;
	
КонецФункции

Функция ЗаголовокРежимаВыбытияПоВидуОперации(ВидОперации) Экспорт
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа")
		Или ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа") Тогда
		Возврат НСтр("ru = 'Продается'");
	Иначе
		Возврат НСтр("ru = 'Возвращается'");
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеРежимаВыбытияПоВидуПродукции(РежимВыбытия, ВидПродукции) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Если РежимВыбытия = "Полностью" Тогда
		
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи") Тогда
			ВозвращаемоеЗначение = НСтр("ru = 'Флакон'"); 
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция") Тогда
			ВозвращаемоеЗначение = НСтр("ru = 'Пачка'");
		КонецЕсли;
		
	Иначе
		
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи") Тогда
			ВозвращаемоеЗначение = НСтр("ru = 'На разлив'"); 
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция") Тогда
			ВозвращаемоеЗначение = НСтр("ru = 'Поштучно'");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

Функция ДоступноНесколькоПотребительскихШаблоновКодовДляВидаПродукции(ВидПродукции) Экспорт
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КОнецФункции

// Возвращает редакцию библиотеки подключаемого оборудования(БПО).
// В редакции 2 данные возвращаются как первый элемент массива, возращаемого в свойстве ВыходныеПараметры.
// В редакции 3 данные возвращаются в составе возвращаемого значение.
// 
// Возвращаемое значение:
//  Число - Редакция БПО. Первая цифра номера версии.
Функция РедакцияБПО() Экспорт
	
	ВерсияБиблиотеки = МенеджерОборудованияВызовСервера.ВерсияБиблиотеки();
	
	Возврат Число(СтрРазделить(ВерсияБиблиотеки, ".")[0]);
	
КонецФункции

#КонецОбласти