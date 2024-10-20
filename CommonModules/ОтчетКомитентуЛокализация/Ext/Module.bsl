﻿
#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Переопределение текста запроса для отражения в учете НДС в части отчета комитента
//
// Параметры:
//  ТекстТовары - Строка - исходный текст запроса
//
Процедура ТекстЗапросаОтражениеВУчетеНДСТекстТовары(ТекстТовары) Экспорт

	ТекстЗаменыВидыЗапасов = "ЛОЖЬ";
	ТекстЗаменыТовары      = "ЛОЖЬ";
	//++ Локализация
	
	ТекстЗаменыВидыЗапасов = "ТаблицаВидыЗапасов.СчетФактураВыставленный.Исправление";
	ТекстЗаменыТовары      = "Товары.СчетФактураВыставленный.Исправление";
	//-- Локализация
	ТекстТовары = СтрЗаменить(ТекстТовары, "&ПолеИсправлениеОшибокВидыЗапасов", ТекстЗаменыВидыЗапасов);
	ТекстТовары = СтрЗаменить(ТекстТовары, "&ПолеИсправлениеОшибокТовары", ТекстЗаменыТовары);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	
	// Счет-фактура
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
	КомандаПечати.Идентификатор = "СчетФактура";
	КомандаПечати.Представление = НСтр("ru = 'Счет-фактура'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВВалюте", Ложь);

	Если НЕ ПраваПользователяПовтИсп.ЭтоПартнер() Тогда
		// Счет-фактура (в валюте)
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "СчетФактураВВалюте";
		КомандаПечати.Представление = НСтр("ru = 'Счет-фактура (в валюте)'");
		КомандаПечати.ФункциональныеОпции = "ИспользоватьНесколькоВалют";
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВВалюте", Истина);
	КонецЕсли;

	// УПД (Универсальный передаточный документ)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
	КомандаПечати.Идентификатор = "УПД";
	КомандаПечати.Представление = НСтр("ru = 'УПД (Универсальный передаточный документ)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

//++ Локализация

// Формирует текст запроса для получения данных основания при печати Счет-фактуры.
//
Функция ТекстЗапросаДанныхОснованияДляПечатнойФормыСчетФактура() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка                                   КАК Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка) КАК ХозяйственнаяОперация,
	|	ДанныеДокументов.Валюта                                   КАК Валюта,
	|	ДанныеДокументов.Организация                              КАК Организация,
	|	ДанныеДокументов.НалогообложениеНДС                       КАК НалогообложениеНДС,
	|	ДанныеДокументов.Подразделение                            КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)                  КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)             КАК Грузоотправитель,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)             КАК Грузополучатель,
	|	ЛОЖЬ                                                      КАК РасчетыЧерезОтдельногоКонтрагента,
	|	НЕОПРЕДЕЛЕНО                                              КАК Номенклатура,
	|	""""                                                      КАК Содержание,
	|	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)             КАК Комиссионер,
	|	НЕОПРЕДЕЛЕНО                                              КАК Основание,
	|	НЕОПРЕДЕЛЕНО                            				  КАК ОснованиеДата,
	|	НЕОПРЕДЕЛЕНО                           					  КАК ОснованиеНомер,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетОрганизации,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетКонтрагента,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетГрузоотправителя,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетГрузополучателя,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьНомер,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьДата,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьВыдана,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьЛицо,
	|	ДанныеДокументов.Менеджер 								  КАК Менеджер,	
	|	НЕОПРЕДЕЛЕНО                                              КАК Кладовщик,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДолжностьКладовщика
	|
	|//ОператорПОМЕСТИТЬ
	|ИЗ
	|	Документ.ОтчетКомитенту КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&ДокументОснование_ОтчетКомитенту)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Функция получает данные для формирования печатной формы УПД
//
// Параметры:
//	ПараметрыПечати - Структура
//	МассивОбъектов - Массив из ДокументСсылка.ОтчетКомитенту - Массив ссылок на документы, по которым необходимо получить данные.
//
// Возвращаемое значение:
// 	Структура:
// 		* РезультатПоШапке - РезультатЗапроса
// 		* РезультатПоТабличнойЧасти - РезультатЗапроса
//
Функция ПолучитьДанныеДляПечатнойФормыУПД(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка                  КАК Ссылка,
	|	ДанныеДокументов.Валюта                  КАК Валюта,
	|	ДанныеДокументов.Организация             КАК Организация,
	|	ДанныеДокументов.Подразделение           КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад
	|
	|ПОМЕСТИТЬ ТаблицаДанныхДокументов
	|ИЗ
	|	Документ.ОтчетКомитенту КАК ДанныеДокументов
	|
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	УчетНДСРФ.ДополнитьЗапросПолученияДанныхДляПечатиУПД(Запрос);

	Запрос.Выполнить();
	
	ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц);
	Обработки.ПечатьОбщихФорм.ПоместитьВременнуюТаблицуДанныхПоставщика(МенеджерВременныхТаблиц);
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	&ПредставлениеСчетФактура КАК ПредставлениеДокумента,
	|	2 КАК СтатусУПД,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Дата,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправления,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправления,
	|	ЛОЖЬ КАК Исправление,
	|	НЕОПРЕДЕЛЕНО КАК НомерСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправленияСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправленияСчетаФактуры,
	|	ЛОЖЬ КАК КорректировочныйСчетФактура,
	|	"""" КАК СтрокаПоДокументу,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаСчетаФактуры,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Контрагент.ОбособленноеПодразделение
	|			ТОГДА ДанныеДокумента.Контрагент.ГоловнойКонтрагент
	|		ИНАЧЕ ДанныеДокумента.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|	ДанныеДокумента.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ДанныеПоставщика.ГоловнаяОрганизация КАК Организация,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	0 КАК ИндексПодразделения,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	НЕОПРЕДЕЛЕНО КАК Грузополучатель,
	|	НЕОПРЕДЕЛЕНО КАК Грузоотправитель,
	|	ДанныеПоставщика.КПППоставщика КАК КПППоставщика,
	|	""""                           КАК КПППокупателя,
	|	ДанныеДокумента.Контрагент.ИНН КАК ИННПокупателя,
	|	НЕОПРЕДЕЛЕНО КАК АдресДоставки,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Валюта.НаименованиеПолное КАК ВалютаНаименованиеПолное,
	|	ДанныеДокумента.Валюта.Код КАК ВалютаКод,
	|	ИСТИНА КАК ТолькоУслуги,
	|	ЛОЖЬ КАК ЕстьПрослеживаемыеТовары,
	|	ЛОЖЬ КАК ЭтоПередачаНаКомиссию,
	|	НЕОПРЕДЕЛЕНО КАК Основание,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьНомер,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьДата,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьВыдана,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьЛицо,
	|	НЕОПРЕДЕЛЕНО КАК Кладовщик,
	|	НЕОПРЕДЕЛЕНО КАК ДолжностьКладовщика,
	|	ДанныеДокументов.ТребуетсяНаличиеСФ КАК ТребуетсяНаличиеСФ
	|ИЗ
	|	Документ.ОтчетКомитенту КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	|		ПО ДанныеДокумента.Ссылка = ДанныеДокументов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеПоставщика КАК ДанныеПоставщика
	|		ПО ДанныеДокумента.Ссылка = ДанныеПоставщика.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Номенклатура.НаименованиеПолное КАК НоменклатураНаименование,
	|	ВЫБОР
	|		КОГДА &КолонкаКодов = ""Артикул""
	|			ТОГДА ТаблицаДокумента.Номенклатура.Артикул
	|		ИНАЧЕ ТаблицаДокумента.Номенклатура.Код
	|	КОНЕЦ КАК НоменклатураКод,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД          КАК ЕдиницаИзмеренияТНВЭД,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД.Представление КАК ЕдиницаИзмеренияТНВЭДНаименование,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД.Код      КАК ЕдиницаИзмеренияТНВЭДКод,
	|	НЕОПРЕДЕЛЕНО КАК Характеристика,
	|	НЕОПРЕДЕЛЕНО КАК ХарактеристикаНаименование,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	НЕОПРЕДЕЛЕНО КАК НомерГТД,
	|	НЕОПРЕДЕЛЕНО КАК СтранаПроисхождения,
	|	НЕОПРЕДЕЛЕНО КАК СтранаПроисхожденияКод,
	|	1 КАК Количество,
	|	0 КАК КоличествоПоРНПТ,
	|	ТаблицаДокумента.СуммаБезНДС КАК Цена,
	|	ТаблицаДокумента.СуммаБезНДС КАК СуммаБезНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.СуммаБезНДС + ТаблицаДокумента.СуммаНДС КАК СуммаСНДС,
	|	1 КАК НомерСтроки,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара
	|ИЗ
	|	ОтчетКомитентуТаблицаТоваров КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|ИТОГИ ПО
	|	Ссылка";
	Запрос.УстановитьПараметр("ПредставлениеСчетФактура", НСтр("ru='счет-фактура'"));
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов         = Запрос.ВыполнитьПакет();
	РезультатПоШапке          = МассивРезультатов[0];
	РезультатПоТабличнойЧасти = МассивРезультатов[1];
	
	СтруктураДанныхДляПечати 	= Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", РезультатПоШапке);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", РезультатПоТабличнойЧасти);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

// Формирует временную таблицу, содержащую табличную часть по таблице данных документов.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу ТаблицаДанныхДокументов с полями:
//		Ссылка.
//
//	ПараметрыЗаполнения - Структура - структура, возвращаемая функцией ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров.
//
Процедура ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПараметрыЗаполнения = Неопределено) Экспорт
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		ПараметрыЗаполнения = ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",     Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ПересчитыватьВВалютуРегл",       ПараметрыЗаполнения.ПересчитыватьВВалютуРегл);
	
	Если ПараметрыЗаполнения.ПересчитыватьВВалютуРегл И ПараметрыЗаполнения.АктуализироватьРасчеты Тогда
		Если НЕ ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		
			Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
			|ИЗ
			|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ТаблицаДанныхДокументов КАК ДанныеДокументов
			|	ПО
			|		РасчетыСКлиентами.Регистратор = ДанныеДокументов.Ссылка
			|
			|ГДЕ
			|	ДанныеДокументов.Валюта <> ДанныеДокументов.Ссылка.Организация.ВалютаРегламентированногоУчета
			|	И РасчетыСКлиентами.Активность
			|";
			ТаблицаАналитик = Запрос.Выполнить().Выгрузить();
			МассивАналитикУчетаПоПартнерам = ТаблицаАналитик.ВыгрузитьКолонку("АналитикаУчетаПоПартнерам");
			
			Если МассивАналитикУчетаПоПартнерам.Количество() > 0 Тогда
				ОкончаниеПериодаРасчета = КонецМесяца(ВзаиморасчетыСервер.ПолучитьМаксимальнуюДатуВКоллекцииДокументов(МенеджерВременныхТаблиц)) + 1;
				АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
				АналитикиРасчета.АналитикиУчетаПоПартнерам = МассивАналитикУчетаПоПартнерам;
				Попытка
					РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(ОкончаниеПериодаРасчета, АналитикиРасчета);
				Исключение
					ТекстСообщения = НСтр("ru ='Печатная форма сформирована по неактуальным данным.
					|Необходимо актуализировать взаиморасчеты вручную и переформировать печатную форму.'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				КонецПопытки;
			КонецЕсли;
		Иначе
			
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДанныеДокументов.Ссылка КАК Ссылка
			|ИЗ
			|	ТаблицаДанныхДокументов КАК ДанныеДокументов
			|ГДЕ 
			|	ДанныеДокументов.Валюта <> ДанныеДокументов.Ссылка.Организация.ВалютаРегламентированногоУчета
			|	ИЛИ ДанныеДокументов.Валюта <> &ВалютаУправленческогоУчета";
			МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
			РегистрыСведений.СуммыДокументовВВалютахУчета.РассчитатьСуммыДокументовВВалютахУчета(МассивДокументов);
			
		КонецЕсли;
	КонецЕсли;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                                      КАК Ссылка,
	|	1                                                            КАК НомерСтроки,
	|	ТаблицаДокумента.Услуга                                      КАК Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)          КАК Серия,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)                  КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)       КАК Упаковка,
	|	1                                                            КАК Количество,
	|	1                                                            КАК КоличествоУпаковок,
	|	0                                                            КАК КоличествоПоРНПТ,
	|	ТаблицаДокумента.СтавкаНДСВознаграждения                     КАК СтавкаНДС,
	|
	|	ЕСТЬNULL(
	|		СуммыДокументовВВалютахУчета.СуммаБезНДСРегл,
	|		ТаблицаДокумента.СуммаВознаграждения - ТаблицаДокумента.СуммаНДСВознаграждения
	|	)                                                            КАК СуммаБезНДС,
	|	ЕСТЬNULL(
	|		СуммыДокументовВВалютахУчета.СуммаНДСРегл,
	|		ТаблицаДокумента.СуммаНДСВознаграждения
	|	)                                                            КАК СуммаНДС,
	|	
	|	ЛОЖЬ                                                         КАК ЭтоТовар,
	|	ЛОЖЬ                                                         КАК ВернутьМногооборотнуюТару
	|
	|ПОМЕСТИТЬ ОтчетКомитентуТаблицаТоваров
	|ИЗ
	|	Документ.ОтчетКомитенту КАК ТаблицаДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
	|	ПО
	|		ТаблицаДокумента.Ссылка = СуммыДокументовВВалютахУчета.Регистратор
	|		И СуммыДокументовВВалютахУчета.ИдентификаторСтроки = """"
	|		И СуммыДокументовВВалютахУчета.Активность
	|		И &ПересчитыватьВВалютуРегл
	|;";
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьЗначенияНДСПродажиПоДаннымРеализации(Объект) Экспорт
	
	ТаблицаПараметров = Новый ТаблицаЗначений();
	ТаблицаПараметров.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаПараметров.Колонки.Добавить("Характеристика",Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаПараметров.Колонки.Добавить("Упаковка",Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	ТаблицаПараметров.Колонки.Добавить("СуммаПродажи", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15,2)));
	ТаблицаПараметров.Колонки.Добавить("СчетФактураВыставленный",Новый ОписаниеТипов("ДокументСсылка.СчетФактураВыданный"));
	
	Для каждого Стр Из Объект.Товары Цикл
		СтрНов = ТаблицаПараметров.Добавить();
		ЗаполнитьЗначенияСвойств(СтрНов,Стр);
		СтрНов.СчетФактураВыставленный = Стр.СчетФактураВыставленный;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ОтчетКомитентуТовары",ТаблицаПараметров);
	
	Запрос.Текст = " 
	|ВЫБРАТЬ
	|ОтчетКомитентуТовары.Номенклатура КАК Номенклатура,
	|ОтчетКомитентуТовары.Характеристика КАК Характеристика,
	|ОтчетКомитентуТовары.Упаковка КАК Упаковка,
	|ОтчетКомитентуТовары.СуммаПродажи КАК СуммаПродажи,
	|ОтчетКомитентуТовары.СчетФактураВыставленный
	|
	|ПОМЕСТИТЬ СтрокиСРеализациейПодготовка	
	|	ИЗ
	|		&ОтчетКомитентуТовары КАК ОтчетКомитентуТовары
	|;
	|
	|ВЫБРАТЬ
	|ОтчетКомитентуТовары.Номенклатура КАК Номенклатура,
	|ОтчетКомитентуТовары.Характеристика КАК Характеристика,
	|ОтчетКомитентуТовары.Упаковка КАК Упаковка,
	|ОтчетКомитентуТовары.СуммаПродажи КАК СуммаПродажи,
	|СчетФактураВыданный.ДокументОснование КАК СчетФактураВыставленныйДокументОснование
	|
	|ПОМЕСТИТЬ СтрокиСРеализацией
	|	ИЗ
	|		СтрокиСРеализациейПодготовка КАК ОтчетКомитентуТовары
	|			ЛЕВОЕ СОЕДИНЕНИЕ
	|			Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|			ПО ОтчетКомитентуТовары.СчетФактураВыставленный = СчетФактураВыданный.Ссылка
	|
	|;
	|ВЫБРАТЬ
	|СтрокиСРеализацией.Номенклатура КАК Номенклатура,
	|СтрокиСРеализацией.Характеристика КАК Характеристика,
	|СтрокиСРеализацией.Упаковка КАК Упаковка,
	|СуммыДокументовВВалютахУчета.СуммаНДСРегл КАК СуммаНДСРегл,
	|СуммыДокументовВВалютахУчета.СуммаБезНДСРегл КАК СуммаБезНДСРегл,
	|СуммыДокументовВВалютахУчета.СтавкаНДС КАК СтавкаНДС
	|	ИЗ 
	|		СтрокиСРеализацией
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровИУслугТовары
	|			ПО СтрокиСРеализацией.СчетФактураВыставленныйДокументОснование = РеализацияТоваровИУслугТовары.Ссылка И
	|			СтрокиСРеализацией.Номенклатура = РеализацияТоваровИУслугТовары.Номенклатура  И
	|			СтрокиСРеализацией.Характеристика = РеализацияТоваровИУслугТовары.Характеристика  И
	|			СтрокиСРеализацией.Упаковка = РеализацияТоваровИУслугТовары.Упаковка 
	|				ЛЕВОЕ СОЕДИНЕНИЕ
	|					Документ.РеализацияТоваровУслуг.ВидыЗапасов КАК РеализацияТоваровИУслугВидыЗапасов
	|					ПО РеализацияТоваровИУслугТовары.Ссылка = РеализацияТоваровИУслугВидыЗапасов.Ссылка И
	|					РеализацияТоваровИУслугТовары.АналитикаУчетаНоменклатуры = РеализацияТоваровИУслугВидыЗапасов.АналитикаУчетаНоменклатуры
	|						ЛЕВОЕ СОЕДИНЕНИЕ
	|							РегистрСведений.СуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
	|							ПО РеализацияТоваровИУслугВидыЗапасов.Ссылка = СуммыДокументовВВалютахУчета.Регистратор И
	|							РеализацияТоваровИУслугВидыЗапасов.ИдентификаторСтроки  =  СуммыДокументовВВалютахУчета.ИдентификаторСтроки	
	|
	|ГДЕ  СуммыДокументовВВалютахУчета.СуммаНДСРегл IS NOT NULL		
	|И СтрокиСРеализацией.СуммаПродажи = СуммыДокументовВВалютахУчета.СуммаБезНДСРегл+СуммыДокументовВВалютахУчета.СуммаНДСРегл;
	|";
	
	УстановитьПривилегированныйРежим(Истина);
		
	Рез = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Рез.Следующий() Цикл
		
		Структура = Новый Структура();
		Структура.Вставить("Номенклатура",Рез.Номенклатура);
		Структура.Вставить("Характеристика",Рез.Характеристика);
		Структура.Вставить("Упаковка",Рез.Упаковка); 
		Структура.Вставить("СуммаПродажи", Рез.СуммаБезНДСРегл + Рез.СуммаНДСРегл);
		
		ТЧТовары = Объект.Товары;
		Строки = ТЧТовары.НайтиСтроки(Структура);
		
		Если Строки.Количество()>0 Тогда
			Стр = Строки[0];
			Стр.СуммаПродажиНДС = Рез.СуммаНДСРегл; 
			Стр.СтавкаНДС = Рез.СтавкаНДС;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//-- Локализация
#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

//++ Локализация

//-- Локализация

#КонецОбласти

#КонецОбласти
