﻿//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

#Область СостояниеПакета

// Возвращает состояние пакета
// 
// Параметры:
//  МассивСостояний - Массив из ПеречислениеСсылка.СостоянияДокументовЭДО
// Возвращаемое значение:
//  - Неопределено - если состояние неоднородно.
//  - ПеречислениеСсылка.СостоянияДокументовЭДО - состояние пакета документа.
//
Функция СостояниеПакета(МассивСостояний) Экспорт
	
	СостояниеПакета = Неопределено;
	
	ПорядокСостояний = Новый ТаблицаЗначений;
	ПорядокСостояний.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	ПорядокСостояний.Колонки.Добавить("Состояние", Новый ОписаниеТипов("ПеречислениеСсылка.СостоянияДокументовЭДО"));
	
	ТолькоОсновной = Ложь;
	ТолькоОтклонение = Ложь;
	ТолькоАннулирование = Ложь;
	СостоянияОдинаковы = Истина;
	
	ЭтоПерваяИтерация = Истина;
	ПредыдущееСостояние = Перечисления.СостоянияДокументовЭДО.ПустаяСсылка();
	
	Для Каждого Состояние Из МассивСостояний Цикл
		
		Если Не ЭтоПерваяИтерация Тогда
			Если ПредыдущееСостояние <> Состояние Тогда
				СостоянияОдинаковы = Ложь
			КонецЕсли;
			Если Не (СостоянияОдинаковы ИЛИ ТолькоОсновной ИЛИ ТолькоОтклонение ИЛИ ТолькоАннулирование) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		ПредыдущееСостояние = Состояние;
		
		Если ТолькоОсновной ИЛИ ЭтоПерваяИтерация Тогда
			
			Порядок = ПорядокСостоянияОсновной(Состояние);
			Если Порядок > 0 Тогда
				ТолькоОсновной = Истина;
				ДобавитьПорядокСостояния(ПорядокСостояний, Порядок, Состояние);
				ЭтоПерваяИтерация = Ложь;
				Продолжить;
			ИначеЕсли ТолькоОсновной Тогда
				ТолькоОсновной = Ложь;
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТолькоОтклонение ИЛИ ЭтоПерваяИтерация Тогда
			
			Порядок = ПорядокСостоянияОтклонение(Состояние);
			Если Порядок > 0 Тогда
				ТолькоОтклонение = Истина;
				ДобавитьПорядокСостояния(ПорядокСостояний, Порядок, Состояние);
				ЭтоПерваяИтерация = Ложь;
				Продолжить;
			ИначеЕсли ТолькоОтклонение Тогда
				ТолькоОтклонение = Ложь;
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТолькоАннулирование ИЛИ ЭтоПерваяИтерация Тогда
			
			Порядок = ПорядокСостоянияАннулирование(Состояние);
			Если Порядок > 0 Тогда
				ТолькоАннулирование = Истина;
				ДобавитьПорядокСостояния(ПорядокСостояний, Порядок, Состояние);
				ЭтоПерваяИтерация = Ложь;
				Продолжить;
			ИначеЕсли ТолькоАннулирование Тогда
				ТолькоАннулирование = Ложь;
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
		ЭтоПерваяИтерация = Ложь;
		
	КонецЦикла;
	
	Если СостоянияОдинаковы Тогда
		СостояниеПакета = ПредыдущееСостояние;
	ИначеЕсли ЗначениеЗаполнено(ПорядокСостояний)
		И (ТолькоОсновной ИЛИ ТолькоОтклонение ИЛИ ТолькоАннулирование) Тогда
		ПорядокСостояний.Сортировать("Порядок");
		СостояниеПакета = ПорядокСостояний[0].Состояние;
	КонецЕсли;
	
	Возврат СостояниеПакета;
	
КонецФункции

#КонецОбласти

#Область СостояниеДокумента

// Начальное состояние исходящего электронного документа.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция НачальноеСостояниеДокумента() Экспорт
	Возврат Перечисления.СостоянияДокументовЭДО.НеСформирован;
КонецФункции

// Возвращает параметры электронного документа для определения состояния.
// 
// Возвращаемое значение:
//  Структура:
//  * ТипРегламента - ПеречислениеСсылка.ТипыРегламентовЭДО - Тип регламента ЭДО.
//  * СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД - Способ обмена электронными документами.
//  * ОбменБезПодписи - Булево - Обмен без подписи (прямой обмен).
//  * ТребуетсяПодтверждение - Булево - Необходимость формирования ответного титула или ответной подписи.
//  * ТребуетсяИзвещение - Булево - необходимость формирования извещения о получении.
//  * Остановлен - Булево - признак остановленного документа.
//  * ПричинаОстановки - ПеречислениеСсылка.ПричиныОстановкиЭДО - причина остановки документа.
//  * Исправлен - Булево - признак того, что создан документ исправление.
//
Функция НовыеПараметрыДокументаДляОпределенияСостояния() Экспорт
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ТипРегламента", Перечисления.ТипыРегламентовЭДО.ПустаяСсылка());
	ПараметрыДокумента.Вставить("СпособОбмена", Перечисления.СпособыОбменаЭД.ПустаяСсылка());
	ПараметрыДокумента.Вставить("ОбменБезПодписи", Ложь);
	ПараметрыДокумента.Вставить("ТребуетсяИзвещение", Ложь);
	ПараметрыДокумента.Вставить("ТребуетсяПодтверждение", Ложь);
	ПараметрыДокумента.Вставить("Остановлен", Ложь);
	ПараметрыДокумента.Вставить("ПричинаОстановки", Перечисления.ПричиныОстановкиЭДО.ПустаяСсылка());
	ПараметрыДокумента.Вставить("Исправлен", Ложь);
	
	Возврат ПараметрыДокумента;
	
КонецФункции

// Возвращает описание таблицы состояний документов для расчета состояния электронного документа.
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО - Тип элемента регламента.
//  * Состояние - ПеречислениеСсылка.СостоянияСообщенийЭДО - Состояние электронного документа.
//
Функция НовыеСостоянияЭлементовРегламента() Экспорт
	
	СостоянияЭлементовРегламента = Новый ТаблицаЗначений;
	СостоянияЭлементовРегламента.Колонки.Добавить("ТипЭлементаРегламента",
		Новый ОписаниеТипов("ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО"));
	СостоянияЭлементовРегламента.Колонки.Добавить("Состояние",
		Новый ОписаниеТипов("ПеречислениеСсылка.СостоянияСообщенийЭДО"));
	Возврат СостоянияЭлементовРегламента;
	
КонецФункции

// Возвращает состояния электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. НовыеСостоянияЭлементовРегламента
//  ЭтоВходящийЭДО - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента, ЭтоВходящийЭДО = Ложь) Экспорт
	
	Если ПараметрыДокумента.Остановлен Тогда
		Состояние = СостояниеОстановленногоДокумента(ПараметрыДокумента.ПричинаОстановки,
			ПараметрыДокумента.Исправлен);
	ИначеЕсли ЭтоВходящийЭДО Тогда
		Состояние = СостояниеВходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента);
	Иначе
		Состояние = СостояниеИсходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента);
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает состояния электронного документа по которым ЭДО является завершенным.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО - Состояние электронного документа.
//
Функция СостоянияЗавершенногоЭДО() Экспорт
	Состояния = Новый Массив;
	Состояния.Добавить(Перечисления.СостоянияДокументовЭДО.ОбменЗавершен);
	Состояния.Добавить(Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением);
	Состояния.Добавить(Перечисления.СостоянияДокументовЭДО.Аннулирован);
	Состояния.Добавить(Перечисления.СостоянияДокументовЭДО.ЗакрытПринудительно);
	Состояния.Добавить(Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением);
	Состояния.Добавить(Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонениемПриглашения);
	Состояния.Добавить(Перечисления.СостоянияДокументовЭДО.ЗакрытСОшибкойПередачи);
	Возврат Состояния;
КонецФункции

#КонецОбласти

#Область СостояниеСообщения

// Возвращает пустые параметры сообщения для определения состояния.
// 
// Возвращаемое значение:
//  Структура:
//  * Статус - ПеречислениеСсылка.СтатусыСообщенийЭДО
//  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  * Направление - ПеречислениеСсылка.НаправленияЭДО
//
Функция НовыеПараметрыСообщенияДляОпределенияСостояния() Экспорт
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ТипЭлементаРегламента", Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка());
	ПараметрыДокумента.Вставить("Статус", Перечисления.СтатусыСообщенийЭДО.ПустаяСсылка());
	ПараметрыДокумента.Вставить("Направление", Перечисления.НаправленияЭДО.ПустаяСсылка());
	Возврат ПараметрыДокумента;
КонецФункции

// Возвращает параметры электронного документа для определения состояния.
// 
// Возвращаемое значение:
//  Структура:
//  * ТипРегламента          - ПеречислениеСсылка.ТипыРегламентовЭДО
//  * ТребуетсяПодтверждение - Булево
//  * ОбменБезПодписи        - Булево
//  * СпособОбмена           - ПеречислениеСсылка.СпособыОбменаЭД
//
Функция НовыеПараметрыДокументаДляОпределенияСостоянияСообщения() Экспорт
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ТипРегламента", Перечисления.ТипыРегламентовЭДО.ПустаяСсылка());
	ПараметрыДокумента.Вставить("ТребуетсяПодтверждение", Ложь);
	ПараметрыДокумента.Вставить("ОбменБезПодписи", Ложь);
	ПараметрыДокумента.Вставить("СпособОбмена", Перечисления.СпособыОбменаЭД.ПустаяСсылка());
	Возврат ПараметрыДокумента;
КонецФункции

// Возвращает состояние сообщения.
//
// Параметры:
//  ПараметрыСообщения - См. НовыеПараметрыСообщенияДляОпределенияСостояния
//  ПараметрыДокумента - См. НовыеПараметрыДокументаДляОпределенияСостоянияСообщения
//  ИспользоватьУтверждение  - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенийЭДО
//
Функция СостояниеСообщения(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение = Ложь) Экспорт
	МенеджерРегламента = МенеджерРегламента(ПараметрыДокумента.ТипРегламента);
	Возврат МенеджерРегламента.СостояниеСообщения(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение);
КонецФункции

#КонецОбласти

#Область СхемаРегламента

// Возвращает пустую структуру настроек регламента.
//
// Возвращаемое значение:
//  Структура:
//  * ТипРегламента          - ПеречислениеСсылка.ТипыРегламентовЭДО - Тип регламента ЭДО.
//  * СпособОбмена           - ПеречислениеСсылка.СпособыОбменаЭД - Способ обмена электронными документами.
//  * ТребуетсяИзвещение     - Булево - необходимость формирования извещения о получении.
//  * ТребуетсяПодтверждение - Булево - Необходимость формирования ответного титула или ответной подписи.
//  * ЭтоВходящийЭДО         - Булево - признак входящего документооборота.
//
Функция НовыеНастройкиСхемыРегламента() Экспорт
	НастройкиРегламента = Новый Структура;
	НастройкиРегламента.Вставить("ТипРегламента", Перечисления.ТипыРегламентовЭДО.ПустаяСсылка());
	НастройкиРегламента.Вставить("СпособОбмена", Перечисления.СпособыОбменаЭД.ПустаяСсылка());
	НастройкиРегламента.Вставить("ТребуетсяИзвещение", Ложь);
	НастройкиРегламента.Вставить("ТребуетсяПодтверждение", Ложь);
	НастройкиРегламента.Вставить("ЭтоВходящийЭДО", Ложь);
	Возврат НастройкиРегламента;
КонецФункции

// Возвращает новую схему регламента.
//
// Параметры:
//  НастройкиСхемыРегламента - См. НовыеНастройкиСхемыРегламента
//  ДанныеЭлементовСхемы     - Неопределено
//                           - ТаблицаЗначений:
//  * ТипЭлементаРегламента  - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  ДеревоЗначений:
//  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО - Тип элемента регламента.
//  * Дополнительный - Булево - Признак дополнительного элемента схемы.
//  * Данные - СтрокаТаблицыЗначений - Строка таблицы ДанныеЭлементовСхемы.
//
Функция НоваяСхемаРегламента(НастройкиСхемыРегламента, ДанныеЭлементовСхемы = Неопределено) Экспорт
	
	СхемаРегламента = Новый ДеревоЗначений;
	СхемаРегламента.Колонки.Добавить("ТипЭлементаРегламента",
		Новый ОписаниеТипов("ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО"));
	СхемаРегламента.Колонки.Добавить("Дополнительный", Новый ОписаниеТипов("Булево"));
	СхемаРегламента.Колонки.Добавить("Данные", Новый ОписаниеТипов("СтрокаТаблицыЗначений"));
	
	ЭлементыСхемы = ДобавитьЭлементыСхемыРегламента(СхемаРегламента, НастройкиСхемыРегламента);
	
	Если ЗначениеЗаполнено(ДанныеЭлементовСхемы) Тогда
		ЗаполнитьДанныеЭлементовСхемыРегламента(ЭлементыСхемы, ДанныеЭлементовСхемы);
	КонецЕсли;
	
	Возврат СхемаРегламента;
	
КонецФункции

// Возвращает элементы схемы регламента у которых не заполнены данные.
// 
// Параметры:
//  СхемаРегламента - См. НоваяСхемаРегламента
//
// Возвращаемое значение:
//  Массив из СтрокаДереваЗначений:
//  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО - Тип элемента регламента.
//  * Дополнительный - Булево - Признак дополнительного элемента схемы.
//  * Данные - СтрокаТаблицыЗначений - Строка таблицы ДанныеЭлементовСхемы. 
//
Функция ЭлементыСхемыРегламентаБезДанных(СхемаРегламента) Экспорт
	
	Отбор = Новый Структура("Данные", СхемаРегламента.Колонки.Данные.ТипЗначения.ПривестиЗначение());
	ЭлементыСхемы = СхемаРегламента.Строки.НайтиСтроки(Отбор, Истина);
	Возврат ЭлементыСхемы;
	
КонецФункции

#КонецОбласти

#Область Извещения

// Возвращает пустые параметры документа для определения потребности извещения.
// 
// Возвращаемое значение:
//  Структура:
//  * ТипРегламента      - ПеречислениеСсылка.ТипыРегламентовЭДО
//  * СпособОбмена       - ПеречислениеСсылка.СпособыОбменаЭД
//  * ТребуетсяИзвещение - Булево
//
Функция НовыеПараметрыДокументаДляОпределенияПотребностиИзвещения() Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("ТипРегламента", Перечисления.ТипыРегламентовЭДО.ПустаяСсылка());
	Параметры.Вставить("СпособОбмена", Перечисления.СпособыОбменаЭД.ПустаяСсылка());
	Параметры.Вставить("ТребуетсяИзвещение", Ложь);
	Возврат Параметры;
КонецФункции

// Возвращает тип извещения для элемента регламента.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  ПараметрыДокумента - См. НовыеПараметрыДокументаДляОпределенияПотребностиИзвещения
//  ЭтоВходящийЭДО - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Функция ТипИзвещенияДляЭлементаРегламента(ТипЭлементаРегламента, ПараметрыДокумента, ЭтоВходящийЭДО = Ложь) Экспорт
	
	Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка();
	
	Если ЭтоВнутреннийОбмен(ПараметрыДокумента.СпособОбмена) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя
		И Не ПараметрыДокумента.ТребуетсяИзвещение Тогда
		Возврат Результат;
	КонецЕсли;
	
	МенеджерРегламента = МенеджерРегламента(ПараметрыДокумента.ТипРегламента);
	
	Если ЭтоВходящийЭДО Тогда
		Результат = МенеджерРегламента.ТипИзвещенияДляЭлементаВходящегоДокумента(ТипЭлементаРегламента);
	Иначе
		Результат = МенеджерРегламента.ТипИзвещенияДляЭлементаИсходящегоДокумента(ТипЭлементаРегламента);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Возвращает признак наличия информации получателя по регламенту.
// 
// Параметры:
//  ТипРегламента - ПеречислениеСсылка.ТипыРегламентовЭДО
//
// Возвращаемое значение:
//  Булево - признак наличия информации получателя по регламенту.
//
Функция ЕстьИнформацияПолучателя(ТипРегламента) Экспорт
	МенеджерРегламента = МенеджерРегламента(ТипРегламента);
	Возврат МенеджерРегламента.ЕстьИнформацияПолучателя();
КонецФункции

// Возвращает признак доступности отклонения.
// 
// Параметры:
//  ЭлементыРегламента - ТаблицаЗначений:
//  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  ЭтоВходящийЭДО - Булево
//
// Возвращаемое значение:
//  Булево
//
Функция ОтклонениеДоступно(ЭлементыРегламента, ЭтоВходящийЭДО) Экспорт
	
	Результат = Ложь;
	
	Если ЭтоВходящийЭДО
		И Не ЕстьАктивноеАннулирование(ЭлементыРегламента) Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак отношения типа элемента регламента к служебным типам.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЭтоСлужебноеСообщение(ТипЭлементаРегламента) Экспорт
	Возврат Не ЭтоИнформацияУчастникаЭДО(ТипЭлементаРегламента);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СостояниеПакета

// Возвращает порядок состояния основной группы состояний.
// 
// Параметры:
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Число
//
Функция ПорядокСостоянияОсновной(Состояние)
	Порядок = 0;
	Если Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонениемПриглашения Тогда
		Порядок = 1;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонениемПриглашения Тогда
		Порядок = 2;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяУтверждение Тогда
		Порядок = 3;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание Тогда
		Порядок = 4;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке Тогда
		Порядок = 5;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправка Тогда
		Порядок = 6;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении Тогда
		Порядок = 7;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения Тогда
		Порядок = 8;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещения Тогда
		Порядок = 9;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещения Тогда
		Порядок = 10;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждение Тогда
		Порядок = 11;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеОператора Тогда
		Порядок = 12;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеОПолучении Тогда
		Порядок = 13;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением Тогда
		Порядок = 14;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОбменЗавершен Тогда
		Порядок = 15;
	КонецЕсли;
	Возврат Порядок;
КонецФункции

// Возвращает порядок состояния группы состояний отклонения.
// 
// Параметры:
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Число
//
Функция ПорядокСостоянияОтклонение(Состояние)
	Порядок = 0;
	Если Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения Тогда
		Порядок = 1;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеОтклонения Тогда
		Порядок = 2;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаОтклонения Тогда
		Порядок = 3;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеПоОтклонению Тогда
		Порядок = 4;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещенияПоОтклонению Тогда
		Порядок = 5;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещенияПоОтклонению Тогда
		Порядок = 6;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещенияПоОтклонению Тогда
		Порядок = 7;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяУточнение Тогда
		Порядок = 8;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению Тогда
		Порядок = 9;
	КонецЕсли;
	Возврат Порядок;
КонецФункции

// Возвращает порядок состояния группы состояний аннулирования.
// 
// Параметры:
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Число
//
Функция ПорядокСостоянияАннулирование(Состояние)
	Порядок = 0;
	Если Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеАннулирования Тогда
		Порядок = 1;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодтверждениеАннулирования Тогда
		Порядок = 2;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеАннулирования Тогда
		Порядок = 3;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаАннулирования Тогда
		Порядок = 4;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеАннулирования Тогда
		Порядок = 5;
	КонецЕсли;
	Возврат Порядок;
КонецФункции

// Добавляет строку в таблицу порядка состояний.
// 
// Параметры:
//  ПорядокСостояний - ТаблицаЗначений:
//  * Порядок - Число
//  * Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//  Порядок - Число
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
Процедура ДобавитьПорядокСостояния(ПорядокСостояний, Порядок, Состояние)
	НоваяСтрока = ПорядокСостояний.Добавить();
	НоваяСтрока.Порядок = Порядок;
	НоваяСтрока.Состояние = Состояние;
КонецПроцедуры

#КонецОбласти

#Область СостояниеДокумента

// Возвращает состояние остановленного документа.
// 
// Параметры:
//  ПричинаОстановки - ПеречислениеСсылка.ПричиныОстановкиЭДО
//  Исправлен - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеОстановленногоДокумента(ПричинаОстановки, Исправлен)
	
	Если ПричинаОстановки = Перечисления.ПричиныОстановкиЭДО.ОтклонениеПодписания
		ИЛИ ПричинаОстановки = Перечисления.ПричиныОстановкиЭДО.ОшибкаПередачиБлокирующая Тогда
		
		Состояние = ?(Исправлен, Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением,
			Перечисления.СостоянияДокументовЭДО.ТребуетсяУточнение);
		
	ИначеЕсли ПричинаОстановки = Перечисления.ПричиныОстановкиЭДО.ОшибкаПередачиНеблокирующая Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПовторнаяОтправка;
		
	ИначеЕсли ПричинаОстановки = Перечисления.ПричиныОстановкиЭДО.ТребуетсяОтправкаПриглашения Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаПриглашения;
		
	ИначеЕсли ПричинаОстановки = Перечисления.ПричиныОстановкиЭДО.ОжидаетсяОтветНаПриглашение Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяОтветНаПриглашение;
		
	ИначеЕсли ПричинаОстановки = Перечисления.ПричиныОстановкиЭДО.ОтклонениеПриглашения Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонениемПриглашения;
		
	ИначеЕсли ПричинаОстановки = Перечисления.ПричиныОстановкиЭДО.Аннулирован Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.Аннулирован;
		
	Иначе
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытПринудительно;
		
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает состояния исходящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. НовыеСостоянияЭлементовРегламента
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеИсходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента)
	
	Если Не ЗначениеЗаполнено(СостоянияЭлементовРегламента) Тогда
		Возврат НачальноеСостояниеДокумента();
	КонецЕсли;
	
	МенеджерРегламента = МенеджерРегламента(ПараметрыДокумента.ТипРегламента);
	Возврат МенеджерРегламента.СостояниеИсходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента);
	
КонецФункции

// Возвращает состояния входящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. НовыеСостоянияЭлементовРегламента
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеВходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента)
	
	Если Не ЗначениеЗаполнено(СостоянияЭлементовРегламента) Тогда
		Возврат НачальноеСостояниеДокумента();
	КонецЕсли;
	
	МенеджерРегламента = МенеджерРегламента(ПараметрыДокумента.ТипРегламента);
	Возврат МенеджерРегламента.СостояниеВходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента);
	
КонецФункции

// Возвращает признак наличия элемента регламента.
// 
// Параметры:
//  КоллекцияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  ТипЭлементаРегламента        - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  ЭлементРегламента            - Неопределено,
//                                 СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//
// Возвращаемое значение:
//  Булево
//
Функция ЕстьЭлементРегламента(КоллекцияЭлементовРегламента, ТипЭлементаРегламента, ЭлементРегламента = Неопределено) Экспорт
	
	ЭлементРегламента = КоллекцияЭлементовРегламента.Найти(ТипЭлементаРегламента, "ТипЭлементаРегламента");
	Возврат ЭлементРегламента <> Неопределено;
	
КонецФункции

// Устанавливает приоритетное состояние.
// 
// Параметры:
//  Состояние      - ПеречислениеСсылка.СостоянияДокументовЭДО
//  НовоеСостояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
Процедура УстановитьПриоритетноеСостояние(Состояние, НовоеСостояние) Экспорт
	
	Если СравнитьСостояния(Состояние, НовоеСостояние) = 1 Тогда
		Состояние = НовоеСостояние;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает результат сравнения двух состояний.
// 
// Параметры:
//  Состояние1 - ПеречислениеСсылка.СостоянияДокументовЭДО
//  Состояние2 - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Число
//
Функция СравнитьСостояния(Состояние1, Состояние2)
	
	ПриоритетСостояния1 = ПриоритетСостояния(Состояние1);
	ПриоритетСостояния2 = ПриоритетСостояния(Состояние2);
	Если ПриоритетСостояния1 > ПриоритетСостояния2 Тогда
		Возврат -1;
	ИначеЕсли ПриоритетСостояния1 < ПриоритетСостояния2 Тогда 
		Возврат 1;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

// Возвращает значение приоритета состояния.
// 
// Параметры:
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Число
//
Функция ПриоритетСостояния(Состояние)
	
	Если Не ЗначениеЗаполнено(Состояние) Тогда
		Возврат 0
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждение Тогда
		Возврат 1;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеОПолучении Тогда 
		Возврат 2;
	ИначеЕсли Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеОператора Тогда 
		Возврат 3;
	Иначе
		Возврат 4;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СостояниеСообщения

// Возвращает состояние сообщения ФНС.
// 
// Параметры:
//  ПараметрыСообщения - Структура:
//  * Статус - ПеречислениеСсылка.СтатусыСообщенийЭДО
//  ПараметрыДокумента - Структура:
//  * ОбменБезПодписи - Булево
//  * СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
//  ИспользоватьУтверждение - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенийЭДО
//
Функция СостояниеСообщенияФНС(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение) Экспорт

	Состояние = Перечисления.СостоянияСообщенийЭДО.ПустаяСсылка();
	
	Статус = ПараметрыСообщения.Статус;
	
	Если Статус = Перечисления.СтатусыСообщенийЭДО.Получен Тогда
		
		Если ИспользоватьУтверждение Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.Утверждение;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Утвержден Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Сформирован Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.ЧастичноПодписан Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Подписан Тогда
		
		Если ЭтоВнутреннийОбмен(ПараметрыДокумента.СпособОбмена) Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.ПодготовленКОтправке Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Отправлен Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		
	Иначе
		ВызватьИсключение ТекстОшибкиНекорректныйСтатусСообщения();
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает состояние сообщения аннулирования.
// 
// Параметры:
//  ПараметрыСообщения - Структура:
//  * Статус - ПеречислениеСсылка.СтатусыСообщенийЭДО
//  * Направление - ПеречислениеСсылка.НаправленияЭДО
//  ПараметрыДокумента - Структура:
//  * ОбменБезПодписи - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенийЭДО
//
Функция СостояниеСообщенияАннулирования(ПараметрыСообщения, ПараметрыДокумента) Экспорт
	
	Состояние = Перечисления.СостоянияСообщенийЭДО.ПустаяСсылка();
	
	Статус = ПараметрыСообщения.Статус;
	
	Если Статус = Перечисления.СтатусыСообщенийЭДО.Получен Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Подтверждение;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Утвержден Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Сформирован Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Подписан Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.ПодготовленКОтправке Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Отправлен Тогда
		
		Если ПараметрыСообщения.Направление = Перечисления.НаправленияЭДО.Входящий
			ИЛИ ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.ОжидаетсяПодпись;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Подтвержден Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		
	Иначе
		ВызватьИсключение ТекстОшибкиНекорректныйСтатусСообщения();
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает состояние служебного сообщения.
// 
// Параметры:
//  ПараметрыСообщения - Структура:
//  * Статус - ПеречислениеСсылка.СтатусыСообщенийЭДО
//  ПараметрыДокумента - Структура:
//  * ОбменБезПодписи - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенийЭДО
//
Функция СостояниеСлужебногоСообщения(ПараметрыСообщения, ПараметрыДокумента) Экспорт
	
	Состояние = Перечисления.СостоянияСообщенийЭДО.ПустаяСсылка();
	
	Статус = ПараметрыСообщения.Статус;
	
	Если Статус = Перечисления.СтатусыСообщенийЭДО.Получен Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Сформирован Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Подписан Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.ПодготовленКОтправке Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Отправлен Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		
	Иначе
		ВызватьИсключение ТекстОшибкиНекорректныйСтатусСообщения();
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает текст ошибки по некорректному статусу.
// 
// Возвращаемое значение:
//  Строка
//
Функция ТекстОшибкиНекорректныйСтатусСообщения() Экспорт
	Возврат НСтр("ru = 'Некорректный статус документа'");
КонецФункции

#КонецОбласти

#Область СхемаРегламента

// Возвращает коллекцию добавленных элементов схемы регламента.
// 
// Параметры:
//  СхемаРегламента - См. НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. НовыеНастройкиСхемыРегламента
//
// Возвращаемое значение:
//  См. НоваяКоллекцияЭлементовСхемыРегламента
//
Функция ДобавитьЭлементыСхемыРегламента(СхемаРегламента, НастройкиСхемыРегламента)
	
	МенеджерРегламента = МенеджерРегламента(НастройкиСхемыРегламента.ТипРегламента);
	Возврат МенеджерРегламента.ДобавитьЭлементыСхемыРегламента(СхемаРегламента, НастройкиСхемыРегламента);
	
КонецФункции

// Возвращает коллекцию добавленных элементов схемы регламента.
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//  * Ключ - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  * Значение - СтрокаДереваЗначений:
//  ** ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  ** Дополнительный - Булево
//  ** Данные - СтрокаТаблицыЗначений
//
Функция НоваяКоллекцияЭлементовСхемыРегламента() Экспорт
	Возврат Новый Соответствие;
КонецФункции

// Заполняет данные элементов схемы регламента.
// 
// Параметры:
//  КоллекцияЭлементовСхемы - Соответствие из КлючИЗначение:
//  * Ключ - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  * Значение - СтрокаДереваЗначений:
//  ** ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  ** Дополнительный - Булево
//  ** Данные - СтрокаТаблицыЗначений
//  ДанныеЭлементовСхемы - ТаблицаЗначений:
//  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Процедура ЗаполнитьДанныеЭлементовСхемыРегламента(КоллекцияЭлементовСхемы, ДанныеЭлементовСхемы)
	
	Для Каждого ДанныеЭлемента Из ДанныеЭлементовСхемы Цикл
		
		ЭлементСхемы = КоллекцияЭлементовСхемы[ДанныеЭлемента.ТипЭлементаРегламента];
		Если ЭлементСхемы <> Неопределено Тогда
			ЭлементСхемы.Данные = ДанныеЭлемента;
		Иначе
			ИнформацияОтправителя = КоллекцияЭлементовСхемы[
				Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя];
			Если ИнформацияОтправителя <> Неопределено Тогда
				ТипЭлементаРегламента = ДанныеЭлемента.ТипЭлементаРегламента;
				НовыйЭлемент = ВставитьЭлементСхемыРегламента(
					КоллекцияЭлементовСхемы, ИнформацияОтправителя, ТипЭлементаРегламента);
				НовыйЭлемент.Данные = ДанныеЭлемента;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает признак успешности вставки элемента схемы регламента.
// 
// Параметры:
//  ЭлементыСхемы - См. НоваяКоллекцияЭлементовСхемыРегламента
//  ЭлементРодитель - См. НоваяСхемаРегламента
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  Дополнительный - Булево
// 
// Возвращаемое значение:
//  СтрокаДереваЗначений: См. НоваяСхемаРегламента
//
Функция ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ЭлементРодитель, ТипЭлементаРегламента, Дополнительный = Ложь) Экспорт
	ЭлементСхемы = ЭлементРодитель.Строки.Добавить();
	ЭлементСхемы.ТипЭлементаРегламента = ТипЭлементаРегламента;
	ЭлементСхемы.Дополнительный = Дополнительный;
	ЭлементыСхемы.Вставить(ТипЭлементаРегламента, ЭлементСхемы);
	Возврат ЭлементСхемы;
КонецФункции

// Возвращает признак обмена через оператора.
// 
// Параметры:
//  СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
//
// Возвращаемое значение:
//  Булево
//
Функция ЭтоОбменЧерезОператора(СпособОбмена) Экспорт
	Возврат СинхронизацияЭДОКлиентСервер.ЭтоОбменЧерезОператора(СпособОбмена);
КонецФункции

// Возвращает признак внутреннего обмена
// 
// Параметры:
//  СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
//
// Возвращаемое значение:
//  Булево
//
Функция ЭтоВнутреннийОбмен(СпособОбмена) Экспорт
	Возврат СинхронизацияЭДО.ЭтоВнутреннийОбмен(СпособОбмена);
КонецФункции

#КонецОбласти

#Область Прочее

// Общий модуль обработки указанного типа регламента.
// 
// Параметры:
//  ТипРегламента - ПеречислениеСсылка.ТипыРегламентовЭДО - Тип регламента ЭДО.
// 
// Возвращаемое значение:
//  - ОбщийМодуль
//
Функция МенеджерРегламента(ТипРегламента)
	
	Если ТипРегламента = Перечисления.ТипыРегламентовЭДО.УПД Тогда
		Возврат РегламентыЭДО_УПД;
	ИначеЕсли ТипРегламента = Перечисления.ТипыРегламентовЭДО.Неформализованный Тогда
		Возврат РегламентыЭДО_Неформализованный;
	ИначеЕсли ТипРегламента = Перечисления.ТипыРегламентовЭДО.Формализованный Тогда
		Возврат РегламентыЭДО_Формализованный;
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Некорректный тип регламента ЭДО: %1'"), ТипРегламента);
	КонецЕсли;
	
КонецФункции

// Возвращает признак наличия активного аннулирования.
// 
// Параметры:
//  ЭлементыРегламента - ТаблицаЗначений:
//  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЕстьАктивноеАннулирование(ЭлементыРегламента)
	
	КоличествоАктивныхПОА = 0;
	
	Для Каждого Элемент Из ЭлементыРегламента Цикл
		
		Если Элемент.ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ Тогда
			Возврат Истина;
		ИначеЕсли Элемент.ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА Тогда
			КоличествоАктивныхПОА = КоличествоАктивныхПОА + 1;
		ИначеЕсли Элемент.ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА_УОУ Тогда
			КоличествоАктивныхПОА = КоличествоАктивныхПОА - 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КоличествоАктивныхПОА > 0;
	
КонецФункции

// Возвращает признак является ли тип элемента регламента информацией участника ЭДО.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЭтоИнформацияУчастникаЭДО(ТипЭлементаРегламента)
	Возврат ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя
		ИЛИ ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя;
КонецФункции

#КонецОбласти

#КонецОбласти
