﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает параметры таможенной декларации - регистрационный номер и признак того, декларировался ли товар в РФ.
// Порядок получения регистрационного номера таможенной декларации см. в описании функции ПроверитьКорректностьНомераТаможеннойДекларации(). 
// Если РегистрационныйНомер вернет пустую строку, будет установлен признак, что товар декларировался не в РФ.
//
// Параметры:
//	НомерТаможеннойДекларации - Строка - номер таможенной декларации или регистрационный номер таможенной декларации.
//
// Возвращаемое значение:
//	Структура - коллекция, содержащая следующие свойства:
//		* РегистрационныйНомер	- Строка -регистрационный номер таможенной декларации либо пустая строка, 
//											если его не удалось определить.
//		* ПорядковыйНомерТовара - Строка - Порядковый номер товара из графы 32 ДТ.
//		* КодОшибки				- Число - код ошибки, расшифровка в ЗакупкиКлиентСерверЛокализация.ТекстОшибкиВНомереТаможеннойДекларации().
//		* СтранаВвозаНеРФ		- Булево - признак, что товар декларировался не в РФ.
Функция РегистрационныйНомерИСтранаВвоза(НомерТаможеннойДекларации) Экспорт
	
	СтруктураНомера = ЗакупкиКлиентСерверЛокализация.ПроверитьКорректностьНомераТаможеннойДекларации(НомерТаможеннойДекларации);
	СтруктураНомера.Вставить("СтранаВвозаНеРФ", НЕ ЗначениеЗаполнено(СтруктураНомера.РегистрационныйНомер));
	
	Возврат СтруктураНомера;
	
КонецФункции

// Возвращает дату принятия декларации на товары.
// Если номер таможенной декларации указан некорректно или декларация была выдана 
// не российским таможенным органом - будет возвращена пустая дата.
//
// Параметры:
//    НомерТаможеннойДекларации - Строка - Номер таможенной декларации или регистрационный номер таможенной декларации.
//
// Возвращаемое значение:
//    Дата - Дата принятия декларации на товары, зашифрованная во втором разряде
//                                            номера таможенной декларации.
Функция ДатаПринятияДекларацииНаТовары(НомерТаможеннойДекларации) Экспорт
	
	ДатаПринятияДекларацииНаТовары = '00010101';
	
	Если НЕ ЗначениеЗаполнено(НомерТаможеннойДекларации) Тогда
		Возврат ДатаПринятияДекларацииНаТовары;
	КонецЕсли;
	
	СтруктураНомера = ЗакупкиКлиентСерверЛокализация.ПроверитьКорректностьНомераТаможеннойДекларации(НомерТаможеннойДекларации);
	
	Если НЕ ЗначениеЗаполнено(СтруктураНомера.РегистрационныйНомер) Тогда
		Возврат ДатаПринятияДекларацииНаТовары;
	КонецЕсли;
	
	МассивТД = СтрРазделить(СтруктураНомера.РегистрационныйНомер, "/");
	РазрядДатаПринятияДекларацииНаТовары = МассивТД[1];
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаВДату(РазрядДатаПринятияДекларацииНаТовары)
	
КонецФункции

// Инициализирует структуру параметров для передачи данных в обработчик заполнения элемента справочника НомераГТД.
//
// Параметры:
//	НомерТаможеннойДекларации - Строка - номер таможенной декларации или регистрационный номер таможенной декларации.
//	СтранаПроисхождения - Неопределено, СправочникСсылка.СтраныМира - Необязательный, страна происхождения товара
//																		по таможенной декларации.
//
// Возвращаемое значение:
//	Структура - параметры заполнения элемента справочника НомераГТД, включающие следующие свойства:
//		* Код - Строка - Полный номер грузовой таможенной декларации.
//		* СтранаПроисхождения - СправочникСсылка.СтраныМира - Страна происхождения товара по таможенной декларации.
//		* РегистрационныйНомер - Строка - Номер таможенной декларации.
//		* ПорядковыйНомерТовара - Строка - Порядковый номер товара (значение поля №32 таможенной декларации).
//		* РНПТ - Булево - Признак того, что номер ГТД подлежит учету в системе прослеживаемости импортных товаров.
//							Значение по умолчанию "ЛОЖЬ".
//		* ЗаполнитьПорядковыйНомерТовараАвтоматически - Булево - Признак, что ПорядковыйНомерТовара будет вычисляться
//																	непосредственно из свойства Код.
//		* СтранаВвозаНеРФ - Булево - Признак, что товар декларировался не в РФ.
//
Функция ПараметрыДляЗаполненияЭлемента(НомерТаможеннойДекларации, СтранаПроисхождения = Неопределено) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Код",						НомерТаможеннойДекларации);
	ПараметрыЗаполнения.Вставить("СтранаПроисхождения",		?(ЗначениеЗаполнено(СтранаПроисхождения),
																СтранаПроисхождения,
																Справочники.СтраныМира.ПустаяСсылка()));
	ПараметрыЗаполнения.Вставить("РегистрационныйНомер",	"");
	ПараметрыЗаполнения.Вставить("ПорядковыйНомерТовара",	"");
	ПараметрыЗаполнения.Вставить("РНПТ",					Ложь);
	ПараметрыЗаполнения.Вставить("ЗаполнитьПорядковыйНомерТовараАвтоматически", Ложь);
	ПараметрыЗаполнения.Вставить("СтранаВвозаНеРФ",			Ложь);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтранаПроисхождения = Неопределено;
	
	Параметры.Отбор.Свойство("СтранаПроисхождения", СтранаПроисхождения);
	
	ТекстЗапроса = "";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеСправочника.Ссылка КАК Ссылка,
		|	ДанныеСправочника.Представление КАК Представление,
		|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
		|	ДанныеСправочника.СтранаПроисхождения.Представление КАК СтранаПредставление
		|ИЗ
		|	Справочник.НомераГТД КАК ДанныеСправочника
		|ГДЕ
		|	НЕ ДанныеСправочника.Предопределенный
		|";
		
	Иначе
		
		ТекстВложенногоЗапросаСочетанияНоменклатураГТД = "";
		
		ПравоДоступаПриобретениеТоваровУслуг = ПравоДоступа("Чтение", Метаданные.Документы.ПриобретениеТоваровУслуг);
		ПравоДоступаКорректировкаПриобретения = ПравоДоступа("Чтение", Метаданные.Документы.КорректировкаПриобретения);
		ПравоДоступаПересортицаТоваров = ПравоДоступа("Чтение", Метаданные.Документы.ПересортицаТоваров);
		ПравоДоступаОприходованиеИзлишковТоваров = ПравоДоступа("Чтение", Метаданные.Документы.ОприходованиеИзлишковТоваров);
		
		//при добавлении выборок к вложенному запросу необходимо, чтобы текст начинался с |ОБЪЕДИНИТЬ ВСЕ
		Если ПравоДоступаПриобретениеТоваровУслуг Тогда
			ТекстВложенногоЗапросаСочетанияНоменклатураГТД = ТекстВложенногоЗапросаСочетанияНоменклатураГТД + "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ ПЕРВЫЕ 100
				|	ПриобретениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
				|	ПриобретениеТоваровУслугТовары.Характеристика КАК Характеристика,
				|	ПриобретениеТоваровУслугТовары.НомерГТД КАК НомерГТД,
				|	ПриобретениеТоваровУслугТовары.Ссылка КАК Ссылка,
				|	ПриобретениеТоваровУслугТовары.Ссылка.Дата КАК Дата
				|ИЗ
				|	Документ.ПриобретениеТоваровУслуг.Товары КАК ПриобретениеТоваровУслугТовары
				|ГДЕ
				|	ПриобретениеТоваровУслугТовары.Номенклатура = &Номенклатура
				|	И ПриобретениеТоваровУслугТовары.Характеристика = &Характеристика
				|	И ПриобретениеТоваровУслугТовары.Ссылка.Проведен
				|";
		КонецЕсли;
		
		Если ПравоДоступаКорректировкаПриобретения Тогда
			ТекстВложенногоЗапросаСочетанияНоменклатураГТД = ТекстВложенногоЗапросаСочетанияНоменклатураГТД + "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ ПЕРВЫЕ 100
				|	КорректировкаПриобретенияТовары.Номенклатура КАК Номенклатура,
				|	КорректировкаПриобретенияТовары.Характеристика КАК Характеристика,
				|	КорректировкаПриобретенияТовары.НомерГТД КАК НомерГТД,
				|	КорректировкаПриобретенияТовары.Ссылка КАК Ссылка,
				|	КорректировкаПриобретенияТовары.Ссылка.Дата КАК Дата
				|ИЗ
				|	Документ.КорректировкаПриобретения.Товары КАК КорректировкаПриобретенияТовары
				|ГДЕ
				|	КорректировкаПриобретенияТовары.Номенклатура = &Номенклатура
				|	И КорректировкаПриобретенияТовары.Характеристика = &Характеристика
				|	И КорректировкаПриобретенияТовары.Ссылка.Проведен
				|";
		КонецЕсли;
		
		Если ПравоДоступаОприходованиеИзлишковТоваров Тогда
			ТекстВложенногоЗапросаСочетанияНоменклатураГТД = ТекстВложенногоЗапросаСочетанияНоменклатураГТД + "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ ПЕРВЫЕ 100
				|	ОприходованиеИзлишковТоваровТовары.Номенклатура КАК Номенклатура,
				|	ОприходованиеИзлишковТоваровТовары.Характеристика КАК Характеристика,
				|	ОприходованиеИзлишковТоваровТовары.НомерГТД КАК НомерГТД,
				|	ОприходованиеИзлишковТоваровТовары.Ссылка КАК Ссылка,
				|	ОприходованиеИзлишковТоваровТовары.Ссылка.Дата КАК Дата
				|ИЗ
				|	Документ.ОприходованиеИзлишковТоваров.Товары КАК ОприходованиеИзлишковТоваровТовары
				|ГДЕ
				|	ОприходованиеИзлишковТоваровТовары.Номенклатура = &Номенклатура
				|	И ОприходованиеИзлишковТоваровТовары.Характеристика = &Характеристика
				|	И ОприходованиеИзлишковТоваровТовары.Ссылка.Проведен
				|";
		КонецЕсли;
		
		Если ПравоДоступаПересортицаТоваров Тогда
			ТекстВложенногоЗапросаСочетанияНоменклатураГТД = ТекстВложенногоЗапросаСочетанияНоменклатураГТД + "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ ПЕРВЫЕ 100
				|	ПересортицаТоваровТовары.Номенклатура КАК Номенклатура,
				|	ПересортицаТоваровТовары.Характеристика КАК Характеристика,
				|	ПересортицаТоваровТовары.НомерГТД КАК НомерГТД,
				|	ПересортицаТоваровТовары.Ссылка КАК Ссылка,
				|	ПересортицаТоваровТовары.Ссылка.Дата КАК Дата
				|ИЗ
				|	Документ.ПересортицаТоваров.Товары КАК ПересортицаТоваровТовары
				|ГДЕ
				|	ПересортицаТоваровТовары.Номенклатура = &Номенклатура
				|	И ПересортицаТоваровТовары.Характеристика = &Характеристика
				|	И ПересортицаТоваровТовары.Ссылка.Проведен
				|";
		КонецЕсли;
		
		Если ПравоДоступа("Чтение", Метаданные.Документы.ТаможеннаяДекларацияИмпорт) Тогда
			ТекстВложенногоЗапросаСочетанияНоменклатураГТД = ТекстВложенногоЗапросаСочетанияНоменклатураГТД + "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ ПЕРВЫЕ 100
				|	ТаможеннаяДекларацияИмпортТовары.Номенклатура КАК Номенклатура,
				|	ТаможеннаяДекларацияИмпортТовары.Характеристика КАК Характеристика,
				|	ТаможеннаяДекларацияИмпортТовары.НомерГТД КАК НомерГТД,
				|	ТаможеннаяДекларацияИмпортТовары.Ссылка КАК Ссылка,
				|	ТаможеннаяДекларацияИмпортТовары.Ссылка.Дата КАК Дата
				|ИЗ
				|	Документ.ТаможеннаяДекларацияИмпорт.Товары КАК ТаможеннаяДекларацияИмпортТовары
				|ГДЕ
				|	ТаможеннаяДекларацияИмпортТовары.Номенклатура = &Номенклатура
				|	И ТаможеннаяДекларацияИмпортТовары.Характеристика = &Характеристика
				|	И ТаможеннаяДекларацияИмпортТовары.Ссылка.Проведен
				|";
		КонецЕсли;
		
		Если Не ПустаяСтрока(ТекстВложенногоЗапросаСочетанияНоменклатураГТД) Тогда
			ТекстЗапросаОбъединитьВсе = "ОБЪЕДИНИТЬ ВСЕ";
			КоличествоСимволовОбъединитьВсе = СтрДлина(ТекстЗапросаОбъединитьВсе);
			ПозицияИнструкцииОбъединитьВсе = СтрНайти(ТекстВложенногоЗапросаСочетанияНоменклатураГТД,
														ТекстЗапросаОбъединитьВсе);
			ПозицияНачалаПервойВыборки = ?(ПозицияИнструкцииОбъединитьВсе > 0,
											ПозицияИнструкцииОбъединитьВсе + КоличествоСимволовОбъединитьВсе,
											1);
			ТекстВложенногоЗапросаСочетанияНоменклатураГТДДляВставки = "(" + Сред(ТекстВложенногоЗапросаСочетанияНоменклатураГТД, ПозицияНачалаПервойВыборки) + ")";
			
			ТекстЗапросаСочетанияНоменклатураГТД =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 10000
				|	СочетанияНоменклатураГТД.Номенклатура КАК Номенклатура,
				|	СочетанияНоменклатураГТД.Характеристика КАК Характеристика,
				|	СочетанияНоменклатураГТД.НомерГТД КАК НомерГТД,
				|	СочетанияНоменклатураГТД.Ссылка КАК Ссылка,
				|	СочетанияНоменклатураГТД.Дата КАК Дата
				|ПОМЕСТИТЬ СочетанияНоменклатураГТД
				|ИЗ
				|	&ТекстВложенногоЗапросаСочетанияНоменклатураГТДДляВставки КАК СочетанияНоменклатураГТД
				|УПОРЯДОЧИТЬ ПО
				|	Дата УБЫВ";
			
			ТекстЗапросаСочетанияНоменклатураГТД = СтрЗаменить(ТекстЗапросаСочетанияНоменклатураГТД,
																"&ТекстВложенногоЗапросаСочетанияНоменклатураГТДДляВставки",
																ТекстВложенногоЗапросаСочетанияНоменклатураГТДДляВставки);
			
			ТекстЗапроса = ТекстЗапросаСочетанияНоменклатураГТД + "
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ДанныеСправочника.Ссылка КАК Ссылка,
				|	ДанныеСправочника.Представление КАК Представление,
				|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
				|	ДанныеСправочника.СтранаПроисхождения.Представление КАК СтранаПредставление,
				|	МАКСИМУМ(СочетанияНоменклатураГТД.Дата) КАК Порядок
				|ИЗ
				|	Справочник.НомераГТД КАК ДанныеСправочника
				|		ЛЕВОЕ СОЕДИНЕНИЕ СочетанияНоменклатураГТД КАК СочетанияНоменклатураГТД
				|		ПО (СочетанияНоменклатураГТД.НомерГТД = ДанныеСправочника.Ссылка)
				|ГДЕ
				|	ДанныеСправочника.Код ПОДОБНО &СтрокаПоиска
				|	И (НЕ &ОтборПоСтране
				|			ИЛИ ДанныеСправочника.СтранаПроисхождения = &Страна)
				|
				|СГРУППИРОВАТЬ ПО
				|	ДанныеСправочника.Ссылка,
				|	ДанныеСправочника.Представление,
				|	ДанныеСправочника.ПометкаУдаления,
				|	ДанныеСправочника.СтранаПроисхождения.Представление
				|
				|УПОРЯДОЧИТЬ ПО
				|	Порядок УБЫВ";
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Не ПустаяСтрока(ТекстЗапроса) Тогда
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Номенклатура", ?(Параметры.Свойство("Номенклатура"), Параметры.Номенклатура, Неопределено));
		Запрос.УстановитьПараметр("Характеристика", ?(Параметры.Свойство("Характеристика"), Параметры.Характеристика, Неопределено));
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		Запрос.УстановитьПараметр("ОтборПоСтране", ЗначениеЗаполнено(СтранаПроисхождения));
		Запрос.УстановитьПараметр("Страна", СтранаПроисхождения);
		
		ВыборкаГТД = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаГТД.Следующий() Цикл
			ЭлементВыбора = Новый Структура("Значение, ПометкаУдаления", ВыборкаГТД.Ссылка, ВыборкаГТД.ПометкаУдаления);
			Представление = СокрЛП(ВыборкаГТД.Представление)
							+ ?(ЗначениеЗаполнено(ВыборкаГТД.СтранаПредставление), " (" + ВыборкаГТД.СтранаПредставление + ")", "");
			
			ДанныеВыбора.Добавить(ЭлементВыбора, Представление);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Возвращает порядковый номер товара из полного номера таможенной декларации,  для России это 4 группа символов,
// найденных по разделителю "\".
//
// Параметры:
//	НомерТаможеннойДекларации - Строка - Полный номер таможенной декларации.
//
// Возвращаемое значение:
//	Строка - Порядковый номер товара (значение поля №32 таможенной декларации).
//
Функция ПорядковыйНомерТовараИзНомераТаможеннойДекларации(НомерТаможеннойДекларации) Экспорт
	
	ПорядковыйНомерТовара	= "";
	ДанныеНомераГТД			= СтрРазделить(НомерТаможеннойДекларации, "/");
	
	Если ДанныеНомераГТД.Количество() = 4 Тогда
		ПорядковыйНомерТовара = ДанныеНомераГТД[3];
	КонецЕсли;
	
	Возврат ПорядковыйНомерТовара;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
