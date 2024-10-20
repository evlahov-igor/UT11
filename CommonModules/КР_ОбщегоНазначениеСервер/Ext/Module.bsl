﻿///////////////////////////////////////////////////
//// Общий модуль "КР_ОбщегоНазначениеСервер"
//// Создан: 23.08.2022,  Мельников А.А.,  КРОК,  Jira№ A2105505-384

#Область ПрограммныйИнтерфейс

// << 20.10.2022 Марченко С.Н., КРОК, JIRA№A2105505-702
Процедура ДокументОбъектОчистить(ДокументОбъект, 
	ОчищатьСтандартныеРеквизиты = Ложь, ОчищатьРеквизиты = Истина, ОчищатьТабличныеЧасти = Истина) Экспорт 

	ДокументМетаданные = ДокументОбъект.Метаданные();
	
	Если ОчищатьСтандартныеРеквизиты Тогда 
		Для Каждого РеквизитМетаданные Из ДокументМетаданные.СтандартныеРеквизиты Цикл  
			Если РеквизитМетаданные.Имя = "Ссылка" Тогда 
				Продолжить;
			КонецЕсли;	
			ДокументОбъект[РеквизитМетаданные.Имя] = Неопределено;
		КонецЦикла;
	КонецЕсли;
	
	Если ОчищатьРеквизиты Тогда 
		Для Каждого РеквизитМетаданные Из ДокументМетаданные.Реквизиты Цикл 
			ДокументОбъект[РеквизитМетаданные.Имя] = Неопределено;
		КонецЦикла;
	КонецЕсли;

	Если ОчищатьТабличныеЧасти Тогда 
		Для Каждого ТабличныеЧастиМетаданные Из ДокументМетаданные.ТабличныеЧасти Цикл 
			ДокументОбъект[ТабличныеЧастиМетаданные.Имя].Очистить();
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры // >> 20.10.2022 Марченко С.Н., КРОК, JIRA№A2105505-702

// << 30.11.2022, Федоров Д.Е., КРОК, Jira№ A2105505-909
// Добавить к дате время
//
// Параметры:
//  Дата - Дата - Дата, к которой нужно добавить время.
//  Время - Время - Время, которое нужно добавить к дате.
//
// Возвращаемое значение:
//  Дата - результат вычисления.
//
Функция ДобавитьКДатеВремя(Дата, Время) Экспорт
	
	ДатаРезультат = Дата + (Время - НачалоДня(Время));
	Возврат ДатаРезультат;
	
КонецФункции // >> 30.11.2022, Федоров Д.Е., КРОК, Jira№ A2105505-909

// << 12.12.2022, Федоров Д.Е., КРОК, Jira№ A2105505-872
// Функция возвращает ссылку искомого объекта
// (Создана на основе КР_Демо_УТ11_ЗагрузкаДанныхСервер.СсылкаПоДаннымСинхронизации)
//
// Параметры:
//  Метаданные           - Метаданные - Метаданные искомого объекта.
//  ПараметрыПоиска      - Структура - структура полей поиска.
//  МассивОшибок         - Массив - Массив ошибок, для заполнения сообщениями об ошибках.
//  СтруктураДляОшибки   - Структура - Данные для расширения сообщения об ошибке
//    *НомерСтрокиПоиска       - Число - Номер строки, в которой осуществляется поиск.
//    *КлючеваяСтрокаПоиска    - Строка - Ключевое значение реквизита поиска строкой.
//..  *ИмяКолонки              - Строка - Имя колонки.
//
// Возвращаемое значение:
//  ОбъектСсылка - Ссылка искомого объекта
//
Функция ПоискСсылки(
			МетаданныеОбъекта,
			ПараметрыПоиска,
			МассивОшибок,
			СтруктураДляОшибки = Неопределено) Экспорт
			
	ТекстОшибкиНекорректныеМетаданные	= НСтр("ru = 'Поиск по нессылочным типам данных невозможен.'");
	
	СинонимОбъектаМД= МетаданныеОбъекта.ПредставлениеОбъекта;
	ИмяОбъектаМД = МетаданныеОбъекта.Имя;
	Если Метаданные.Справочники.Содержит(МетаданныеОбъекта) Тогда
		ТипОбъектаМД = "Справочник";
	ИначеЕсли Метаданные.Документы.Содержит(МетаданныеОбъекта) Тогда
		ТипОбъектаМД = "Документ";
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеОбъекта) Тогда
		ТипОбъектаМД = "ПланВидовХарактеристик";
	Иначе
		МассивОшибок.Добавить(ТекстОшибкиНекорректныеМетаданные);
		Возврат Неопределено;
	КонецЕсли;
	
	СсылкаНаОбъект = Неопределено;
	
	Запрос					= Новый Запрос;
	МассивТекстовЗапроса	= Новый Массив;
	ЗаполнитьМассивТекстовЗапроса(МассивТекстовЗапроса, ПараметрыПоиска, Запрос, ТипОбъектаМД, ИмяОбъектаМД);
	Запрос.Текст			= СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовВПакете());
	СсылкаНаОбъект			= ВыполнениеЗапроса(МассивОшибок, ПараметрыПоиска, Запрос, ТипОбъектаМД, СинонимОбъектаМД, СтруктураДляОшибки);
	
	Возврат СсылкаНаОбъект;
	
КонецФункции // >> 12.12.2022, Федоров Д.Е., КРОК, Jira№ A2105505-872

// << 14.12.2022 Марченко С.Н., КРОК, JIRA№A2105505-918
// Метод вычисляет MD5 от переданного значения
//
// Параметры:
//  Данные							 - Строка - Тип параметра согласно ХешированиеДанных.Добавить
//  КонвертироватьРезультатВСтроку	 - Булево - Если Истина, результатом будет строка в нижнем регистре без пробелов
// 
// Возвращаемое значение:
//  ДвоичныеДанные/Строка - В зависимости от значения КонвертироватьРезультатВСтроку
//
Функция MD5(Данные, КонвертироватьРезультатВСтроку = Истина) Экспорт 

	MD5 = Новый ХешированиеДанных(ХешФункция.MD5); 
	MD5.Добавить(Данные);  
	
	Результат = MD5.ХешСумма;
	Если КонвертироватьРезультатВСтроку Тогда 
		Результат = НРег(стрЗаменить(Результат, " ", "")); 
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // >> 14.12.2022 Марченко С.Н., КРОК, JIRA№A2105505-918

// << 14.12.2022 Марченко С.Н., КРОК, JIRA№A2105505-918
// Метод формирует GUID из произвольной строки/текста
//
// Параметры:
//  Данные	 - Строка - Стоковые данные для конвертации в GUID
// 
// Возвращаемое значение:
//  Строка - GUID в формате 1С
//
Функция GUIDИзСтроки(Данные) Экспорт 

	MD5Строка = MD5(Данные);
	
	Шаблон = СтрРазделить("8-4-4-4-12", "-");
	Курсор = 1;
	Для Итератор = 0 По Шаблон.ВГраница() Цикл 
		
		// Читаем сколько сивмолов надо получить
		РазмерСлова = Число(Шаблон[Итератор]);
		
		// Заменяем в массиве полученным значением
		Шаблон[Итератор] = Сред(MD5Строка, Курсор, РазмерСлова);
		
		// Сдвигаем курсор
		Курсор = Курсор + РазмерСлова;
		
	КонецЦикла;	
	
	GIUD = СтрСоединить(Шаблон, "-");
	
	Возврат GIUD;

КонецФункции // >> 14.12.2022 Марченко С.Н., КРОК, JIRA№A2105505-918

// << 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404
Функция СсылкаВСтруктуру(Значение) Экспорт  
			
	ОбъектЗначение = Новый Структура;	
	Если ЗначениеЗаполнено(Значение) Тогда 
	   	ОбъектЗначение.Вставить("Тип", XMLТипЗнч(Значение).ИмяТипа);  
		ОбъектЗначение.Вставить("УникальныйИдентификатор", XMLСтрока(Значение));
		ОбъектЗначение.Вставить("Представление", Строка(Значение));  
	КонецЕсли;	
	
	Возврат ОбъектЗначение;
	
КонецФункции // >> 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404

// << 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404
Функция СтруктураВСсылку(Данные) Экспорт 
	
	// A2105505-1551
	Если Не ЗначениеЗаполнено(Данные) Тогда 
		Возврат Неопределено;
	КонецЕсли;	
	//
	
	СсылкаТип = Тип(Данные.Тип);	
	Возврат XMLЗначение(СсылкаТип, Данные.УникальныйИдентификатор);
	
КонецФункции // >> 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404

// << 04.04.2023 Марченко С.Н., КРОК, JIRA№A2105505-1515
Функция ПолучитьСсылкуСУчетомСсылкиНового(Объект, GUIDУникальныйИдентификатор = Неопределено) Экспорт 

	// Определим ссылку на документ
	// Если документа не существует то установим ему ссылку, если еще не установлеоа
	Если Объект.ЭтоНовый() Тогда       
		ОбъектСсылка = Объект.ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(ОбъектСсылка) Тогда      
			
			Если GUIDУникальныйИдентификатор = Неопределено Тогда 
				GUID = Строка(Новый УникальныйИдентификатор());
			ИначеЕсли ТипЗнч(GUIDУникальныйИдентификатор) = Тип("Строка") Тогда 
				GUID = GUIDУникальныйИдентификатор;   
			Иначе	
				GUID = Строка(GUIDУникальныйИдентификатор);
			КонецЕсли;	
							
			ТипЗначения = ТипЗнч(Объект.Ссылка);
			ОбъектСсылка = XMLЗначение(ТипЗначения, GUID);
			Объект.УстановитьСсылкуНового(ОбъектСсылка);
		КонецЕсли;         
	Иначе
		ОбъектСсылка = Объект.Ссылка;
	КонецЕсли;  
	
	Возврат ОбъектСсылка;
	
КонецФункции // >> 04.04.2023 Марченко С.Н., КРОК, JIRA№A2105505-1515

#Область JSON

// << 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404
Функция ДанныеВJSON(Данные, ПараметрыЗаписиJSON = Неопределено) Экспорт 
	
	Если ПараметрыЗаписиJSON = Неопределено Тогда 
		ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, "");
	КонецЕсли;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	ЗаписатьJSON(ЗаписьJSON, Данные);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции // >> 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404

// << 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404
Функция JSONВДанные(JSON, ПрочитатьВСоответствие = Ложь) Экспорт 

	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(JSON);
	
	Возврат ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);
	
КонецФункции // >> 16.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1404

#КонецОбласти

#Область ХранилищеНастроек
// --> Евлахов Игорь Николаевич (Начало) 18.06.2024
// Задача #3341

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с хранилищем настроек.

// Записывает данные в хранилище настроек.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Хранилище недоступно для записи пользователям (кроме администраторов),
// а доступно только коду, который делает обращения только к своей части данных и
// в том контексте, который предполагает чтение или запись настроек данных.
//
// Параметры:
//  Владелец - СправочникСсылка
//           - Строка - ссылка на объект информационной базы,
//             представляющий объект-владелец сохраняемой настройки или строка до 128 символов.
//             Для объектов других типов в качестве владельца рекомендуется использовать ссылку на
//             элемент метаданных этого типа в справочнике ИдентификаторыОбъектовМетаданных
//             или ключ в виде строки с учетом имен подсистем.
//             Например, для БСП:
//               Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.АдресныеОбъекты");
//             если нужно 1 хранилище на подсистему БСП:
//               Владелец = "СтандартныеПодсистемы.УправлениеДоступом";
//             если нужно более 1 хранилища на подсистему БСП:
//               Владелец = "СтандартныеПодсистемы.УправлениеДоступом.<Уточнение>";
//
//  Данные  - Произвольный - данные помещаемые в хранилище настроек. Неопределенно - удаляет все данные.
//             Для удаления данных по ключу следует использовать процедуру УдалитьДанныеИзХранилищаНастроек.
//  Ключ    - Строка       - ключ сохраняемых настроек.
//                           Ключ должен соответствовать правилам имен идентификаторов:
//                           1. Первым символом ключа должна быть буква или символ подчеркивания (_).
//                           2. Каждый из последующих символов может быть буквой, цифрой или символом подчеркивания (_).
//
// Пример:
//  Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
//  	УстановитьПривилегированныйРежим(Истина);
//      КР_ОбщегоНазначениеСервер.ЗаписатьДанныеВХранилищеНастроек(ТекущийОбъект.Ссылка, "https://ya.ru/", "АдресСервера");
//      УстановитьПривилегированныйРежим(Ложь);
//  КонецПроцедуры
//
Процедура ЗаписатьДанныеВХранилищеНастроек(Владелец, Данные, Ключ) Экспорт

	АдресПроцедуры = "КР_ОбщегоНазначениеСервер.ЗаписатьДанныеВХранилищеНастроек";
	
	ТекстШаблона = НСтр("ru = 'Недопустимое значение параметра %1 в %2.
			           |параметр должен содержать ссылку; передано значение: %3 (тип %4).'");	 
	ТекстСообщения = СтрШаблон(ТекстШаблона, "Владелец", АдресПроцедуры, Владелец, ТипЗнч(Владелец));							
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец), ТекстСообщения);
		
	ТекстШаблона = НСтр("ru = 'Недопустимое значение параметра %1 в %2.
			           |параметр должен содержать строку; передано значение: %3 (тип %4).'");	 
	ТекстСообщения = СтрШаблон(ТекстШаблона, "Ключ", АдресПроцедуры, Ключ, ТипЗнч(Ключ));							
	ОбщегоНазначенияКлиентСервер.Проверить(ТипЗнч(Ключ) = Тип("Строка"), ТекстСообщения);
			
	ХранилищеНастроекДанных = РегистрыСведений.злХранилищеНастроекДанных.СоздатьМенеджерЗаписи();
	
	ХранилищеНастроекДанных.Владелец = Владелец;
	ХранилищеНастроекДанных.Прочитать();
	
	Если Данные <> Неопределено Тогда
		Если ХранилищеНастроекДанных.Выбран() Тогда
			ДанныеДляСохранения = ХранилищеНастроекДанных.Данные.Получить();
			
			Если ТипЗнч(ДанныеДляСохранения) <> Тип("Структура") Тогда
				ДанныеДляСохранения = Новый Структура();
			КонецЕсли;
			
			ДанныеДляСохранения.Вставить(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			ХранилищеНастроекДанных.Данные = ДанныеДляХранилищеЗначения;
			ХранилищеНастроекДанных.Записать();
		Иначе
			ДанныеДляСохранения = Новый Структура(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			ХранилищеНастроекДанных.Данные = ДанныеДляХранилищеЗначения;
			ХранилищеНастроекДанных.Владелец = Владелец;
			ХранилищеНастроекДанных.Записать();
		КонецЕсли;
	Иначе
		ХранилищеНастроекДанных.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные из хранилища настроек.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Хранилище настроек недоступно для записи пользователям (кроме администраторов),
// а доступно только коду, который делает обращения только к своей части данных и
// в том контексте, который предполагает чтение или запись конфиденциальных данных.
//
// Параметры:
//  Владелец    - СправочникСсылка
//              - Строка - ссылка на объект информационной базы,
//                  представляющий объект-владелец сохраняемой настройки или строка до 128 символов.
//  Ключи       - Строка - содержит список имен сохраненных данных, указанных через запятую.
// 
// Возвращаемое значение:
//  Произвольный, Структура, Неопределено - данные из хранилища настроек. Если указан один ключ,
//                            то возвращается его значение, иначе структура.
//                            Если данные отсутствуют - Неопределенно.
//
// Пример:
//	Процедура ПриЧтенииНаСервере(ТекущийОбъект)
//		
//		УстановитьПривилегированныйРежим(Истина);
//		АдресСервера  = КР_ОбщегоНазначениеСервер.ПрочитатьДанныеИзХранилищаНастроек(ТекущийОбъект.Ссылка, "АдресСервера");
//		УстановитьПривилегированныйРежим(Ложь);
//		
//	КонецПроцедуры
//
Функция ПрочитатьДанныеИзХранилищаНастроек(Владелец, Ключи) Экспорт
	
	АдресПроцедуры = "КР_ОбщегоНазначениеСервер.ПрочитатьДанныеИзХранилищаНастроек";
	
	ТекстШаблона = НСтр("ru = 'Недопустимое значение параметра %1 в %2.
			           |параметр должен содержать ссылку; передано значение: %3 (тип %4).'");	 
	ТекстСообщения = СтрШаблон(ТекстШаблона, "Владелец", АдресПроцедуры, Владелец, ТипЗнч(Владелец));							
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец), ТекстСообщения);
			
	Результат = ДанныеИзХранилищаНастроек(Владелец, Ключи);
	
	Если Результат <> Неопределено И Результат.Количество() = 1 Тогда
		Возврат ?(Результат.Свойство(Ключи), Результат[Ключи], Неопределено);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Удаляет данные в хранилище настроек.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Хранилище настроек недоступно для чтения пользователям (кроме администраторов),
// а доступно только коду, который делает обращения только к своей части данных и
// в том контексте, который предполагает чтение или запись конфиденциальных данных.
//
// Параметры:
//  Владелец - СправочникСсылка
//           - Строка - ссылка на объект информационной базы,
//               представляющий объект-владелец сохраняемой настройки или строка до 128 символов.
//  Ключи    - Строка - содержит список имен удаляемых данных, указанных через запятую. 
//               Неопределено - удаляет все данные.
//
// Пример:
//	Процедура ПередУдалением(Отказ)
//		
//		// Проверка значения свойства ОбменДанными.Загрузка отсутствует, так как удалять данные
//		// из хранилища настроек нужно даже при удалении объекта при обмене данными.
//		
//		УстановитьПривилегированныйРежим(Истина);
//		КР_ОбщегоНазначениеСервер.УдалитьДанныеИзХранилищаНастроек(Ссылка);
//		УстановитьПривилегированныйРежим(Ложь);
//		
//	КонецПроцедуры
//
Процедура УдалитьДанныеИзХранилищаНастроек(Владелец, Ключи = Неопределено) Экспорт
	
	АдресПроцедуры = "КР_ОбщегоНазначениеСервер.УдалитьДанныеИзХранилищаНастроек";
	
	ТекстШаблона = НСтр("ru = 'Недопустимое значение параметра %1 в %2.
			           |параметр должен содержать ссылку; передано значение: %3 (тип %4).'");	 
	ТекстСообщения = СтрШаблон(ТекстШаблона, "Владелец", АдресПроцедуры, Владелец, ТипЗнч(Владелец));							
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец), ТекстСообщения);
		
	ХранилищеНастроекДанных = РегистрыСведений.злХранилищеНастроекДанных.СоздатьМенеджерЗаписи();
	
	ХранилищеНастроекДанных.Владелец = Владелец;
	ХранилищеНастроекДанных.Прочитать();
	
	Если ТипЗнч(ХранилищеНастроекДанных.Данные) = Тип("ХранилищеЗначения") Тогда
		ДанныеДляСохранения = ХранилищеНастроекДанных.Данные.Получить();
		
		Если Ключи <> Неопределено И ТипЗнч(ДанныеДляСохранения) = Тип("Структура") Тогда
			СписокКлючей = СтрРазделить(Ключи, ",", Ложь);
			
			Если ХранилищеНастроекДанных.Выбран() И СписокКлючей.Количество() > 0 Тогда
				Для каждого КлючДляУдаления Из СписокКлючей Цикл
					Если ДанныеДляСохранения.Свойство(КлючДляУдаления) Тогда
						ДанныеДляСохранения.Удалить(КлючДляУдаления);
					КонецЕсли;
				КонецЦикла;
				
				ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
				ХранилищеНастроекДанных.Данные = ДанныеДляХранилищеЗначения;
				ХранилищеНастроекДанных.Записать();
				
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ХранилищеНастроекДанных.Удалить();
	
КонецПроцедуры

// Задача #3341
// <-- Евлахов Игорь Николаевич (Конец) 18.06.2024
#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// << 12.12.2022, Федоров Д.Е., КРОК, Jira№ A2105505-872
// Заполняет массив текстов запросов
//
// Параметры:
//  МассивТекстовПакета - Массив - Заполняемый массив.
//  ПоляПакетногоПоиска - Массив - Массив структур полей поиска.
//  Запрос - Запрос - Текущий запрос.
//  ТипОбъектаМД - Строка - Тип объекта метаданных.
//  ИмяОбъектаМД - Строка - Имя объекта метаданных.
//
Процедура ЗаполнитьМассивТекстовЗапроса(МассивТекстовПакета, СтруктураПолей, Запрос, ТипОбъектаМД, ИмяОбъектаМД)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК СсылкаНаОбъект
	|ИЗ
	|	%1.%2 КАК Таблица
	|ГДЕ
	|	%3";
	
	МассивТекстовУсловий = Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураПолей Цикл
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Массив")
			Или ТипЗнч(КлючИЗначение.Значение) = Тип("СписокЗначений") Тогда
			ТекстУсловия = "Таблица.%1 В(&%1)";
		Иначе
			ТекстУсловия = "Таблица.%1 = &%1";
		КонецЕсли;
		МассивТекстовУсловий.Добавить(СтрШаблон(ТекстУсловия, КлючИЗначение.Ключ));
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	ТекстПакета = СтрШаблон(ТекстЗапроса, ТипОбъектаМД, ИмяОбъектаМД, СтрСоединить(МассивТекстовУсловий, " И "));
	МассивТекстовПакета.Добавить(ТекстПакета);
	
КонецПроцедуры // >> 12.12.2022, Федоров Д.Е., КРОК, Jira№ A2105505-872

// << 12.12.2022, Федоров Д.Е., КРОК, Jira№ A2105505-872
// Выполняет текст запроса
//
// Параметры:
//  МассивОшибок - Массив - Массив ошибок поиска ссылки.
//  ПараметрыПоиска - Структура - Структура полей поиска.
//  Запрос - Запрос - Текущий запрос.
//  ТипОбъектаМД - Строка - Тип объекта метаданных.
//  СинонимОбъектаМД - Строка - Имя объекта метаданных.
//  СтруктураДляОшибки - Структура -Данные для расширения сообщений об ошибке.
//
// Возвращаемое значение:
//  Произвольный - результат поиска.
//
Функция ВыполнениеЗапроса(МассивОшибок, ПараметрыПоиска, Запрос, ТипОбъектаМД, СинонимОбъектаМД, СтруктураДляОшибки)
	
	Если ПустаяСтрока(Запрос.Текст) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если СтруктураДляОшибки = Неопределено Тогда
		НомерСтрокиПоиска				= 0;
		КлючеваяСтрокаПоиска			= "";
		ИмяКолонки						= "";
	Иначе
		НомерСтрокиПоиска				= СтруктураДляОшибки.НомерСтрокиПоиска;
		КлючеваяСтрокаПоиска			= СтруктураДляОшибки.КлючеваяСтрокаПоиска;
		ИмяКолонки						= СтруктураДляОшибки.ИмяКолонки;
	КонецЕсли;
	
	ТекстОшибкиПоискВИБНетДанных		= НСтр("ru = 'Не найден(а) %1 ""%2""%3%4.'");
	ТекстОшибкиПоискВИББолееОдного		= НСтр("ru = 'Найдено более одного объекта %1 ""%2""%3%4.'");
	
	РезультатЗапроса					= Запрос.ВыполнитьПакет();
	Индекс								= 0;	
	Представление						= ПредставлениеПолейПоиска(ПараметрыПоиска);
	
	Если РезультатЗапроса[Индекс].Пустой() Тогда
		ТекстСообщения 	= СтрШаблон(ТекстОшибкиПоискВИБНетДанных,
			?(ИмяКолонки = "", СинонимОбъектаМД, ИмяКолонки),
			?(КлючеваяСтрокаПоиска = "", Представление, КлючеваяСтрокаПоиска),
			?(НомерСтрокиПоиска = 0, "", " по строке №"),
			?(НомерСтрокиПоиска = 0, "", НомерСтрокиПоиска));
		МассивОшибок.Добавить(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса[Индекс].Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.СсылкаНаОбъект;
	Иначе
		ТекстСообщения 	= СтрШаблон(ТекстОшибкиПоискВИББолееОдного,
			?(ИмяКолонки ="", СинонимОбъектаМД, ИмяКолонки),
			?(КлючеваяСтрокаПоиска = "", Представление, КлючеваяСтрокаПоиска),
			?(НомерСтрокиПоиска = 0, "", " по строке №"),
			?(НомерСтрокиПоиска = 0, "", НомерСтрокиПоиска));
		МассивОшибок.Добавить(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// << 12.12.2022, Федоров Д.Е., КРОК, Jira№ A2105505-872
// Формирует текст условия поиска для запроса
//
// Параметры:
//  СтруктураПолей - Структура - Структура полей поиска.
//
// Возвращаемое значение:
//  Строка - итоговый текст условия.
//
Функция ПредставлениеПолейПоиска(СтруктураПолей)
	
	МассивТекстов = Новый Массив;
	
	Для Каждого КлючИЗначение Из СтруктураПолей Цикл
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Массив") Тогда
			ПредставлениеУсловия = НСтр("ru = '%1 в списке (%2)'");
			ПредставлениеЗначения = СтрСоединить(КлючИЗначение.Значение, "|");
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("СписокЗначений") Тогда
			ПредставлениеЗначения = СтрСоединить(КлючИЗначение.Значение, "|");
			ПредставлениеУсловия = НСтр("ru = '%1 в списке (%2)'");
		Иначе
			ПредставлениеУсловия = НСтр("ru = '%1 = ""%2""'");
			ПредставлениеЗначения = Строка(КлючИЗначение.Значение);
		КонецЕсли;
		
		МассивТекстов.Добавить(СтрШаблон(ПредставлениеУсловия, КлючИЗначение.Ключ, ПредставлениеЗначения));
	КонецЦикла;
	
	Возврат СтрСоединить(МассивТекстов, "; ");
	
КонецФункции // >> 12.12.2022, Федоров Д.Е., КРОК, Jira№ A2105505-872

// Производит загрузку данных из табличного документа
//
// Параметры:
//  ТаблицаТовары - Табличная часть документа (Товары).
//  ДокументыОснования - Массив - Массив документов оснований.
//  АдресТоваровВХранилище - Строка - Адрес во временном хранилище.
//
Процедура ПолучитьЗагруженныеТоварыИзХранилища(ТаблицаТовары, ДокументыОснования, АдресТоваровВХранилище) Экспорт

	СтруктураДействий = РасхожденияКлиентСервер.СтруктураДействийПриИзмененииКоличестваУпаковок();

	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();

	ТоварыИзХранилища = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДанныеИзВнешнегоИсточника.Номенклатура КАК Номенклатура,
	               |	ДанныеИзВнешнегоИсточника.Характеристика КАК Характеристика,
	               |	ДанныеИзВнешнегоИсточника.Упаковка КАК Упаковка,
	               |	ДанныеИзВнешнегоИсточника.КоличествоУпаковок КАК КоличествоУпаковок,
	               |	ЕСТЬNULL(ДанныеИзВнешнегоИсточника.Цена, 0) КАК Цена,
	               |	ДанныеИзВнешнегоИсточника.СтавкаНДС КАК СтавкаНДС,
	               |	ДанныеИзВнешнегоИсточника.ХарактеристикиИспользуются КАК ХарактеристикиИспользуются
	               |ПОМЕСТИТЬ ДанныеВнешнегоИсточника
	               |ИЗ
	               |	&ДанныеИзВнешнегоИсточника КАК ДанныеИзВнешнегоИсточника
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДанныеВнешнегоИсточника.Номенклатура КАК Номенклатура,
	               |	ДанныеВнешнегоИсточника.Характеристика КАК Характеристика,
	               |	ДанныеВнешнегоИсточника.Упаковка КАК Упаковка,
	               |	СУММА(ДанныеВнешнегоИсточника.КоличествоУпаковок) КАК КоличествоУпаковок,
	               |	ДанныеВнешнегоИсточника.Цена КАК Цена,
	               |	ДанныеВнешнегоИсточника.СтавкаНДС КАК СтавкаНДС,
	               |	ДанныеВнешнегоИсточника.ХарактеристикиИспользуются КАК ХарактеристикиИспользуются
	               |ИЗ
	               |	ДанныеВнешнегоИсточника КАК ДанныеВнешнегоИсточника
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДанныеВнешнегоИсточника.Номенклатура,
	               |	ДанныеВнешнегоИсточника.Характеристика,
	               |	ДанныеВнешнегоИсточника.Упаковка,
	               |	ДанныеВнешнегоИсточника.Цена,
	               |	ДанныеВнешнегоИсточника.СтавкаНДС,
	               |	ДанныеВнешнегоИсточника.ХарактеристикиИспользуются";

	ДокументТовары = ТаблицаТовары.Выгрузить(); // ТаблицаЗначений

	Если ДокументТовары.Колонки.Найти("Цена") = Неопределено Тогда
		ДокументТовары.Колонки.Добавить("Цена", Новый ОписаниеТипов("Число"));
	КонецЕсли;

	Запрос.УстановитьПараметр("ДанныеИзВнешнегоИсточника", ТоварыИзХранилища);
	//Запрос.УстановитьПараметр("ДанныеДокумента", ДокументТовары);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;

	Выборка = Результат.Выбрать();
	
	ТекущийТовар = Новый Структура("Номенклатура, Характеристика, Упаковка, Цена");
	ОстатокТовара = 0; 
	
	Пока Выборка.Следующий() Цикл

		ТекущийТовар.Вставить("Номенклатура", Выборка.Номенклатура);
		ТекущийТовар.Вставить("Характеристика", Выборка.Характеристика);
		ТекущийТовар.Вставить("Упаковка", Выборка.Упаковка);
		ТекущийТовар.Вставить("Цена", Выборка.Цена);
		
		КоличествоПоФакту = 0;
		
		МассивСтрокТовары = ДокументТовары.НайтиСтроки(ТекущийТовар);
		СтрокаВыборкиОбработана = Ложь;
		
		Если МассивСтрокТовары.Количество()>0 Тогда
			КоличествоПоФакту = Выборка.КоличествоУпаковок;
			Для Каждого ЭлементМассива Из МассивСтрокТовары Цикл
				
				СтрокаТовары = ТаблицаТовары[ЭлементМассива.НомерСтроки-1];
				
				Если СтрокаТовары.КоличествоПоДокументу > КоличествоПоФакту Тогда 
					СтрокаТовары.КоличествоУпаковок = ?(КоличествоПоФакту > 0, КоличествоПоФакту, 0);
					//ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТовары, СтруктураДействий, КэшированныеЗначения);
					//СтрокаВыборкиОбработана = Истина; 
				ИначеЕсли СтрокаТовары.КоличествоУпаковок = 0 Или НЕ СтрокаТовары.КоличествоПоДокументу = СтрокаТовары.КоличествоУпаковок Тогда 
					СтрокаТовары.КоличествоУпаковок = ?(СтрокаТовары.КоличествоПоДокументу > КоличествоПоФакту, КоличествоПоФакту, СтрокаТовары.КоличествоПоДокументу);
				КонецЕсли;   
				
				ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТовары, СтруктураДействий, КэшированныеЗначения);
				СтрокаВыборкиОбработана = Истина; 
				
				КоличествоПоФакту = КоличествоПоФакту - СтрокаТовары.КоличествоПоДокументу;
				
			КонецЦикла;
				
		Иначе

			СтрокаТЧТовары = ТаблицаТовары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧТовары, Выборка);
			РасхожденияКлиентСервер.ЗаполнитьДокументОснованиеВСтроке(СтрокаТЧТовары, ДокументыОснования); 
			
		КонецЕсли; 
		
		Если КоличествоПоФакту > 0 Тогда
			
			СтрокаТЧТовары = ТаблицаТовары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧТовары, Выборка);
			СтрокаТЧТовары.КоличествоУпаковок = КоличествоПоФакту;
			РасхожденияКлиентСервер.ЗаполнитьДокументОснованиеВСтроке(СтрокаТЧТовары, ДокументыОснования);
			
		КонецЕсли;
		Если НЕ СтрокаВыборкиОбработана Тогда
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧТовары, СтруктураДействий, КэшированныеЗначения);
		КонецЕсли;
	КонецЦикла;
	
	МассивСтрокТовары = Неопределено;
	СтрокаВыборкиОбработана = Неопределено;
	ТекущийТовар = Неопределено;
	
КонецПроцедуры

#Область ХранилищеНастроек

// --> Евлахов Игорь Николаевич (Начало) 18.06.2024
// Задача #3341
Функция ДанныеИзХранилищаНастроек(Владелец, Ключ)
	
	Запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	злХранилищеНастроекДанных.Данные КАК Данные
	               |ИЗ
	               |	РегистрСведений.злХранилищеНастроекДанных КАК злХранилищеНастроекДанных
	               |ГДЕ
	               |	злХранилищеНастроекДанных.Владелец = &Владелец";
	
	#КонецОбласти
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Данные = Новый Структура(Ключ);
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Данные) Тогда
			СохраненныеДанные = Выборка.Данные.Получить();
			Если ЗначениеЗаполнено(СохраненныеДанные) Тогда
				ЗаполнитьЗначенияСвойств(Данные, СохраненныеДанные);
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
		
	Возврат(Данные);
	
КонецФункции
// <-- Евлахов Игорь Николаевич (Конец) 18.06.2024

#КонецОбласти

#КонецОбласти