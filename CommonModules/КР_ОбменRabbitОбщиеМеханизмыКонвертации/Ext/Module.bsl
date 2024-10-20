﻿
#Область ПрограммныйИнтерфейс

#Область ИдентификаторыСинхронизируемыхОбъектов

// Записывает идентификатор в регистр сведений "Идентификаторы синхронизируемых объектов"
// с привязкой к ссылке в текущей ИБ и информационной базе-отправителю
// 
// Параметры:
//  Идентификатор - Строка - Идентификатор объекта в базе-отправителе
//  Ссылка - ЛюбаяСсылка - Ссылка на объект в текущей базе
//  СообщениеОбмена	 - Структура - Структура сообщения обмена Rabbit
// 
Функция ЗаписатьИдентификаторСинхронизируемыхОбъектов(Идентификатор, Ссылка, СообщениеОбмена) Экспорт

	ИнформационнаяБаза = СообщениеОбмена.Отправитель;
	
	// Для начала проверка на то, что к текущему идентификатору на данной точке не привязана другая ссылка
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ИнформационнаяБаза", СообщениеОбмена.Отправитель);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.КР_ИдентификаторыСинхронизируемыхОбъектов КАК Т
	|ГДЕ
	|	Т.ИнформационнаяБаза = &ИнформационнаяБаза
	|	И Т.Идентификатор = &Идентификатор
	|	И НЕ Т.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда	
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		ТекстСообщения = НСтр("ru = 'Идентификатор ""%1"" уже зарегистрирован для информационной базы ""%2"" на другую ссылку ""%3""'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Идентификатор, ИнформационнаяБаза, ВыборкаДетальныеЗаписи.Ссылка);
		
		СсылкаМетаданные = Ссылка.Метаданные();
		ТипЗаписиВЛог_Ошибка = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка(СсылкаМетаданные, Ссылка);
		
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстСообщения, ТипЗаписиВЛог_Ошибка);
		
		Возврат Ложь;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.КР_ИдентификаторыСинхронизируемыхОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Идентификатор = Идентификатор;
	МенеджерЗаписи.Ссылка = Ссылка;
	МенеджерЗаписи.ИнформационнаяБаза = ИнформационнаяБаза;
	МенеджерЗаписи.Записать(Истина);
	
	Возврат Истина;
	
КонецФункции

// Метод проверяет наличие записи в регистре 
//
// Параметры:
//  Идентификатор	 - Строка - Строковый идентификатор 
//  Ссылка			 - Ссылка -  переменная в которую будет передана найденная ссылка на объект
//  СообщениеОбмена	 - Структура - Структура сообщения обмена Rabbit
// 
// Возвращаемое значение:
//  Булево - Наличие записи. В случае наличия записи параметр метода "Ссылка" будет заполнен найденным значением
//
Функция ЕстьЗаписьСИдентификаторомВСинхронизируемыхОбъектах(Идентификатор, Ссылка, СообщениеОбмена) Экспорт 

	Запрос = Новый Запрос(ТекстЗапросаНайтиСсылкуПоИдентификаторуОтправителя());
    Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
    Запрос.УстановитьПараметр("Отправитель", СообщениеОбмена.Отправитель);
	
	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();   
		
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		
		Ссылка = ВыборкаДетальныеЗаписи.Ссылка;  
			
		Возврат	Истина;
		
	Иначе 	
				
		Возврат Ложь;
		
	КонецЕсли;	
	
КонецФункции

#КонецОбласти          

#Область ЗагрузкаДанных

// Метод производит поиск по Guid или создает новый объект справочника 
//	и заполняет его "Общими" данными (Наименование, ПометкаУдаления [ЭтоГруппа]).
// При создании нового объекта, если в XDTOПакет есть свойство Group(<Булево) 
//	то учитывается его значение - создается Группа или элемент. Иначе создается элемент
//
// Параметры:
//  ИмяСправочника	 - Строка - Имя справочника (Пример "Склады")
//  XDTOПакет		 - ОбъектXDTO - XDTOОбъект с полями Ref, Name, DeletionMark [, Group]
// 
// Возвращаемое значение:
//  СправочникОбъект - Созданный по Guid или полученный из БД объект с заполненными свойствами
//
Функция СправочникиИнициализироватьОбъект(ИмяСправочника, XDTOПакет) Экспорт 
	
	СправочникТип = СтрШаблон("СправочникСсылка.%1", ИмяСправочника);
	СправочникТип = Тип(СправочникТип);

	ЕстьСвойствоGroup = XDTOПакет.Свойства().Получить("Group") <> Неопределено;
	
	Ссылка = XMLЗначение(СправочникТип, XDTOПакет.Ref);
	ЭтоНовый = Не ОбщегоНазначения.СсылкаСуществует(Ссылка);  
		
	Если ЭтоНовый Тогда    
		
		// Если передается признак группы 
		//	и его значение Истина то создаем группу   
		Если ЕстьСвойствоGroup
			И XDTOПакет.Group Тогда 
			
			Объект = Справочники[ИмяСправочника].СоздатьГруппу();   		
		Иначе	
			Объект = Справочники[ИмяСправочника].СоздатьЭлемент();   
		КонецЕсли;
		
		Объект.УстановитьСсылкуНового(Ссылка);  
	Иначе
		Объект = Ссылка.ПолучитьОбъект();
	КонецЕсли;	

	Объект.Наименование = XDTOПакет.Name;    
	Объект.ПометкаУдаления = XDTOПакет.DeletionMark;  
	
	Возврат Объект;
	
КонецФункции	

// Метод производит поиск по Guid или создает новый объект документа 
//	и заполняет его "Общими" данными (Номер, Дата, Проведен, ПометкаУдаления [ЭтоГруппа]).
// При создании нового объекта, если в XDTOПакет есть свойство Group(<Булево) 
//	то учитывается его значение - создается Группа или элемент. Иначе создается элемент
//
// Параметры:
//  ИмяСправочника	 - Строка - Имя документа (Пример "РеализацияТоваровУслуг")
//  XDTOПакет		 - ОбъектXDTO - XDTOОбъект с полями Ref, Name, DeletionMark [, Group]
//  ИмяРеквизитаНомер - Строка - реквизита "Номер" документа. (Упаркврчный лист использует "Код" вместо Номера)
// 
// Возвращаемое значение:
//  СправочникОбъект - Созданный по Guid или полученный из БД объект с заполненными свойствами
//
Функция ДокументыИнициализироватьОбъект(ИмяДокумента, XDTOПакет) Экспорт 
	
	// Для упаковочного листа в частности нет номера документа
	//	используется "Код" вместо Номера
	
	ДокументТип = СтрШаблон("ДокументСсылка.%1", ИмяДокумента);
	ДокументТип = Тип(ДокументТип);
	
	Ссылка = XMLЗначение(ДокументТип, XDTOПакет.Ref);
	ЭтоНовый = Не ОбщегоНазначения.СсылкаСуществует(Ссылка);  
		
	Если ЭтоНовый Тогда  
		Объект = Документы[ИмяДокумента].СоздатьДокумент();   		
		Объект.УстановитьСсылкуНового(Ссылка);  
	Иначе
		Объект = Ссылка.ПолучитьОбъект();
	КонецЕсли;	

	Объект.Дата = XDTOПакет.DocDate;     
	
	Если ТипЗнч(Объект) <> Тип("ДокументОбъект.УпаковочныйЛист") Тогда  
		Объект.Номер = XDTOПакет.DocNum;
	Иначе
		Объект.Код = XDTOПакет.DocNum;
	КонецЕсли;	
	
	Объект.Проведен = XDTOПакет.Posted; 
	Объект.ПометкаУдаления = XDTOПакет.DeletionMark; 
	
	Возврат Объект;
	
КонецФункции	

// Метод производит записть произвольного объекта справичника
// При этом если объект не помечен на удаление выполняется стандартная проверка заполнения 
// Метод так-же генерирует ошибку в общий механизм ошибок с привязкой к метаданным и данным (по возможности)  
//
// Параметры:
//  Объект						 - СправочникОбъект - Объект справочника произвольного типа
//  СообщениеОбмена				 - Структура - СообщениеОбмена механизма Rabbit
//  СвойствоОбъектБылЗагружен	 - Строка - имя дополнительного свойства которое будет помещено в допсвойства объекта
//								   Должно совпадать с тем, что проверяем перед выгрузкой чтоб не допустить зацикливания 	
// 
// Возвращаемое значение:
//  Булево - Успех записи объекта
//
Функция СправочникОбъектЗаписать(Объект, СообщениеОбмена, СвойствоОбъектБылЗагружен = Неопределено) Экспорт 
	
	ОбъектМетаданные = Объект.Метаданные();
	
	// Метод дополнительно к основному фуункционалу
	//	устанавливает ссылку нового это новый и ссылка не задана
	Если Не РегистрыСведений.КР_ОтметкиИнтеграционныхИзменений.Записать(Объект, СообщениеОбмена) Тогда 
		СообщениеОбмена.СсылкиНаОбъекты.Добавить(Объект.Ссылка);
		Возврат Ложь;
	КонецЕсли;
	
	// A2105505-1619
	Если Не Объект.ДополнительныеСвойства.Свойство("ВерсионированиеОбъектовКомментарийКВерсии") Тогда
		КомментарийКВерсии = НСтр("ru='Изменения на основании данных пакета ID: %1'");
		КомментарийКВерсии = СтрШаблон(КомментарийКВерсии, СообщениеОбмена.КлючСообщения);
		Объект.ДополнительныеСвойства.Вставить("ВерсионированиеОбъектовКомментарийКВерсии", КомментарийКВерсии);
	КонецЕсли;

	// A2105505-1615
	Если СообщениеОбмена.ЕстьОшибка Тогда      
		
		Если Объект.ЭтоНовый() Тогда 
			Объект.Записать();
		КонецЕсли; 
		
		СообщениеОбмена.СсылкиНаОбъекты.Добавить(Объект.Ссылка); 
		
		Возврат Ложь;
		
	КонецЕсли;	
	//
	
	// При создании нового объекта мы можем указать уникальный идентификатор в качестве новой ссылки
	// Но в модуле объекта перед записью или в подписках она может быть подменена (без проверки)  
	// Для нас это критично.
	// По этому проверяем на то что ссылка установленная до записи совпадала с таковой после записи
	Ссылка = КР_ОбщегоНазначениеСервер.ПолучитьСсылкуСУчетомСсылкиНового(Объект);
	
	Если Не Объект.ПометкаУдаления
		И Не Объект.ПроверитьЗаполнение() Тогда   
		
		ТекстСообщения = НСтр("ru = 'Ошибка заполнения справочника %1 %2'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ОбъектМетаданные, Объект);
		ДополнитьТекстСообщенияУникальнымИдентификатором(ТекстСообщения, Объект);
		
		Если ЗначениеЗаполнено(Ссылка) Тогда  
			ТипЗаписиВЛог_Ошибка = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка(ОбъектМетаданные, Ссылка);
		Иначе
			ТипЗаписиВЛог_Ошибка = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка(ОбъектМетаданные);
		КонецЕсли;	                                                                                           
		
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстСообщения, ТипЗаписиВЛог_Ошибка);
		
		Возврат Ложь;
	КонецЕсли;

	Если СвойствоОбъектБылЗагружен <> Неопределено Тогда 
		Объект.ДополнительныеСвойства.Вставить(СвойствоОбъектБылЗагружен); 
	КонецЕсли;
	
	Объект.Записать();
	
	Если Ссылка <> Объект.Ссылка Тогда 
		ТекстИсключения = НСтр("ru = 'В процессе записи объекта установленная ссылка (по GUID) " +
			"была изменена логикой ""ПередЗаписью"" модуля объекта либо подписками'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;	 

	СообщениеОбмена.СсылкиНаОбъекты.Добавить(Ссылка);
	
	Возврат Истина;
	
КонецФункции

// Метод производит записть произвольного объекта документа
// При этом если объект проводится то выполняется стандартная проверка заполнения 
// Метод так-же генерирует ошибку в общий механизм ошибок с привязкой к метаданным и данным (по возможности)  
// В методе используется доп. свойство "КР_ЗаписатьБезПроведения" 
//	Логика использования: если мы знаем о существовании ошибки, которая нам не даст провести документ,
//	 но нам его надо обязательно записать, то в допсвойства объекта надо добавить свойство "КР_ЗаписатьБезПроведения"
//   без значения
//
// Параметры:
//  Объект						 - ДокументОбъект - Объект документа произвольного типа
//  СообщениеОбмена				 - Структура - СообщениеОбмена механизма Rabbit
//  СвойствоОбъектБылЗагружен	 - Строка - имя дополнительного свойства которое будет помещено в допсвойства объекта
//								   Должно совпадать с тем, что проверяем перед выгрузкой чтоб не допустить зацикливания 	
// 
// Возвращаемое значение:
//  Булево - Успех записи объекта
//
Функция ДокументОбъектЗаписать(Объект, СообщениеОбмена, СвойствоОбъектБылЗагружен = Неопределено) Экспорт 

	ОбъектМетаданные = Объект.Метаданные(); 
	
	Если СвойствоОбъектБылЗагружен <> Неопределено Тогда 
		Объект.ДополнительныеСвойства.Вставить(СвойствоОбъектБылЗагружен); 
	КонецЕсли;
	
	// Метод дополнительно к основному фуункционалу
	//	устанавливает ссылку нового это новый и ссылка не задана
	Если Не РегистрыСведений.КР_ОтметкиИнтеграционныхИзменений.Записать(Объект, СообщениеОбмена) Тогда 
		СообщениеОбмена.СсылкиНаОбъекты.Добавить(Объект.Ссылка);
		Возврат Ложь;
	КонецЕсли;	
	
	// При создании нового объекта мы можем указать уникальный идентификатор в качестве новой ссылки
	// Но в модуле объекта перед записью или в подписках она может быть подменена (без проверки)  
	// Для нас это критично.
	// По этому проверяем на то что ссылка установленная до записи совпадала с таковой после записи
	Ссылка = КР_ОбщегоНазначениеСервер.ПолучитьСсылкуСУчетомСсылкиНового(Объект);
	
	// A2105505-1651   
	ЕстьОшибки = СообщениеОбмена.ЕстьОшибка;
	//
		
	Если Объект.Проведен
		И Не Объект.ПроверитьЗаполнение() Тогда    
		
		ТекстСообщения = НСтр("ru = 'Ошибка проверки заполнения документа %1'");   
		ТекстСообщения = СтрШаблон(ТекстСообщения, Объект);
		ДополнитьТекстСообщенияУникальнымИдентификатором(ТекстСообщения, Объект);		
		ТипЗаписиВЛог = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_ОшибкаПроведенияДокумента(ОбъектМетаданные, Ссылка);
		
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстСообщения, ТипЗаписиВЛог);
		ЕстьОшибки = Истина;
				
	КонецЕсли;
	
	// A2105505-1619
	Если Не Объект.ДополнительныеСвойства.Свойство("ВерсионированиеОбъектовКомментарийКВерсии") Тогда
		КомментарийКВерсии = НСтр("ru='Изменения на основании данных пакета ID: %1'");
		КомментарийКВерсии = СтрШаблон(КомментарийКВерсии, СообщениеОбмена.КлючСообщения);
		Объект.ДополнительныеСвойства.Вставить("ВерсионированиеОбъектовКомментарийКВерсии", КомментарийКВерсии);
	КонецЕсли;
	
	Если Не ЕстьОшибки
		И Объект.Проведен Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	Иначе
		Объект.Проведен = Ложь; 
		// A2105505-1691 добавлена отмена проведения
		Если Объект.Ссылка.Проведен	Тогда  
			РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
		Иначе	
			РежимЗаписи = РежимЗаписиДокумента.Запись;     
		КонецЕсли;	   
		//
	КонецЕсли;      
		
	Попытка
		Объект.Записать(РежимЗаписи);
	Исключение		
		
		// Если это новый документ или не был проведен ранее то просто записыываем его
		Если Объект.ЭтоНовый() 
			Или Не Объект.Ссылка.Проведен Тогда 
			
			//A2105505-1772 Включен запрет загрузки по дате запрета
			//Объект.ОбменДанными.Загрузка = Истина; // требуется для обхода даты запрета изменения 
			//
			Объект.Проведен = Ложь;
			Объект.Записать(РежимЗаписиДокумента.Запись);  
			
			ТекстСообщения = НСтр("ru = 'Ошибка проведения документа %1
			|По причине: %2
			|ДОКУМЕНТ ЗАПИСАН В (РЕЖИМЕ ЗАПИСИ БЕЗ ПРОВЕДЕНИЯ)'");   
			
		Иначе        
			
			ТекстСообщения = НСтр("ru = 'Ошибка проведения документа %1
			|По причине: %2
			|ДОКУМЕНТ НЕ БЫЛ ИЗМЕНЕН'");   
			
		КонецЕсли;
		
		// Если есть ошибки конвертации / проверки заполнения то нам нельзя перекрывать состояние записи
		// По этой причине мы сообщать ничего не будем чтоб не путать пользователя
		Если Не ЕстьОшибки Тогда 
		
			ТекстСообщения = СтрШаблон(ТекстСообщения, Объект, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ДополнитьТекстСообщенияУникальнымИдентификатором(ТекстСообщения, Объект);		

			ТипЗаписиВЛог = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_ОшибкаПроведенияДокумента(ОбъектМетаданные, Ссылка);
			
			КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстСообщения, ТипЗаписиВЛог);
			
		КонецЕсли;
		
		ЕстьОшибки = Истина;
		
	КонецПопытки;
		
	Если Ссылка <> Объект.Ссылка Тогда 
		ТекстИсключения = НСтр("ru = 'В процессе записи объекта установленная ссылка (по GUID) " +
			"была изменена логикой ""ПередЗаписью"" модуля объекта либо подписками'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;	
	
	СообщениеОбмена.СсылкиНаОбъекты.Добавить(Ссылка);
	
	Возврат Не ЕстьОшибки;
	
КонецФункции

// Метод производит записть произвольного набора записей
// При этом выполняется стандартная проверка заполнения 
// Метод так-же генерирует ошибку в общий механизм ошибок с привязкой к метаданным  
//
// Параметры:
//  Объект						 - НаборЗаписей - Объект документа произвольного типа
//  СообщениеОбмена				 - Структура - СообщениеОбмена механизма Rabbit
//  СвойствоОбъектБылЗагружен	 - Строка - имя дополнительного свойства которое будет помещено в допсвойства объекта
//								   Должно совпадать с тем, что проверяем перед выгрузкой чтоб не допустить зацикливания 	
// 
// Возвращаемое значение:
//  Булево - Успех записи объекта
//
Функция НаборЗаписейРегистраЗаписать(Объект, СообщениеОбмена, СвойствоОбъектБылЗагружен = Неопределено) Экспорт  
	
	Если Не Объект.ПроверитьЗаполнение() Тогда                                     
		
		ОбъектМетаданные = Объект.Метаданные();
		
		ТекстСообщения = НСтр("ru = 'Ошибка заполнения набора записей регистра %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ОбъектМетаданные.ПолноеИмя());
		
		ТипЗаписиВЛог_Ошибка = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка(ОбъектМетаданные);
		
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстСообщения, ТипЗаписиВЛог_Ошибка);
		
		Возврат Ложь;
	КонецЕсли;
	
	Если СвойствоОбъектБылЗагружен <> Неопределено Тогда 
		Объект.ДополнительныеСвойства.Вставить(СвойствоОбъектБылЗагружен); 
	КонецЕсли;
	
	Объект.Записать();
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ВыгрузкаДанных

// Метод заполняет общие поля XDTOОбъекта справочника 
// При этом учитывается свойство "ЭтоУдаление" сообщения обмена.
// Данное свойство устанавливается как "автоматически" при непосредственном удалении
//	так и может быть выставленно программно для отправки объекта на удаление в принимающей БД
//	которая требуется в случае изменения параметров объекта которые не проходят по правилам выгрузки 
// При этом если СообщениеОбмена.ЭтоУдаление = Истина, то XDTOОбъект.DeletionMark становится равным true	
//
// Параметры:
//  XDTOОбъект		 - ОбъектXDTO - XDTO объект справочника
//  Источник		 - СправочникОбъект - Источник для заполнения
//  СообщениеОбмена	 - Структура - Структура сообщения обмена Rabbit
// 
// Возвращаемое значение:
//  Булево - Успех выполнения метода
//
Функция ЗаполнитьОбщиеПоляXDTOСправочника(XDTOОбъект, Источник, СообщениеОбмена) Экспорт 
	
	XDTOОбъект.Ref = XMLСтрока(Источник.Ссылка);
	XDTOОбъект.Name = Источник.Наименование;
	
	// Если ранее элемент справочника был отправлен так как прошел условие регистрации
	//	а сейчас не проходит по условию
	//	то нужно переотправить его с пометкой удаления
	ПометкаУдаления = Источник.ПометкаУдаления
		Или СообщениеОбмена.ЭтоУдаление; 
		
	XDTOОбъект.DeletionMark = XMLСтрока(ПометкаУдаления);
	
	Возврат Истина;

КонецФункции	

// Метод заполняет общие поля XDTOОбъекта документа 
// При этом учитывается свойство "ЭтоУдаление" сообщения обмена.
// Данное свойство устанавливается как "автоматически" при непосредственном удалении
//	так и может быть выставленно программно для отправки объекта на удаление в принимающей БД
//	которая требуется в случае изменения параметров объекта которые не проходят по правилам выгрузки 
// При этом если СообщениеОбмена.ЭтоУдаление = Истина, то XDTOОбъект.DeletionMark становится равным true
//														а XDTOОбъект.Posted становится равным false
//
// Параметры:
//  XDTOОбъект		 - ОбъектXDTO - XDTO объект документ
//  Источник		 - ДокументОбъект - Источник для заполнения
//  СообщениеОбмена	 - Структура - Структура сообщения обмена Rabbit
// 
// Возвращаемое значение:
//  Булево - Успех выполнения метода
//
Функция ЗаполнитьОбщиеПоляXDTOДокумента(XDTOОбъект, Источник, СообщениеОбмена) Экспорт 
	
	XDTOОбъект.Ref = XMLСтрока(Источник.Ссылка);
	XDTOОбъект.DocDate = XMLСтрока(Источник.Дата);       
	
	Если ТипЗнч(Источник) <> Тип("ДокументОбъект.УпаковочныйЛист") Тогда  
		XDTOОбъект.DocNum = Источник.Номер;    
	Иначе
		XDTOОбъект.DocNum = Источник.Код;    
	КонецЕсли;	
	
	// Если ранее документ был отправлен так как прошел условие регистрации
	//	а сейчас не проходит по условию
	//	то нужно переотправить документ с пометкой удаления
	ПометкаУдаления = Источник.ПометкаУдаления
		Или СообщениеОбмена.ЭтоУдаление; 
		
	// Соответственно меняем сстояние проведения документа	
	Проведен = Источник.Проведен
		И Не ПометкаУдаления; 
	
	XDTOОбъект.Posted = XMLСтрока(Проведен);
	XDTOОбъект.DeletionMark = XMLСтрока(ПометкаУдаления);
	
	Возврат Истина;

КонецФункции	

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьТекстСообщенияУникальнымИдентификатором(ТекстСообщения, Объект)

	// Определим ссылку объекта с которой происходит запись  
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда   
		Ссылка = Объект.ПолучитьСсылкуНового();	
	Иначе 	
		Ссылка = Объект.Ссылка; 
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда 
		Возврат;
	КонецЕсли; 	

	GUID = XMLСтрока(Ссылка);  
	ШаблонСообщения = НСтр("ru = '%1. Уникальный идентификатор объекта ""%2""'"); 
	
	ТекстСообщения = СтрШаблон(ШаблонСообщения, ТекстСообщения, GUID);   
	
КонецПроцедуры

#Область ТекстыЗапросов

Функция ТекстЗапросаНайтиСсылкуПоИдентификаторуОтправителя()

	Возврат
	"ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.КР_ИдентификаторыСинхронизируемыхОбъектов КАК Т
	|ГДЕ
	|	Т.Идентификатор = &Идентификатор
	|	И Т.ИнформационнаяБаза = &Отправитель";
	
КонецФункции

#КонецОбласти

#КонецОбласти
