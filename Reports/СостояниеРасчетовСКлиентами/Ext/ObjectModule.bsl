﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета:
//   	* Параметры - Структура:
//   		** ОписаниеКоманды - Структура:
//   			*** ДополнительныеПараметры - Структура.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСКлиентом" Тогда
			
			СформироватьПараметрыСостояниеРасчетовСКлиентом(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСКлиентомПоДокументам" Тогда
			
			ПараметрКоманды = Параметры.ПараметрКоманды;
			
			СтруктураНастроек = НастройкиОтчета(ПараметрКоманды);
			ЗначенияФункциональныхОпций = СтруктураНастроек.ЗначенияФункциональныхОпций;
			
			РасширенныйЗаказ = ЗначенияФункциональныхОпций.ИспользоватьРасширенныеВозможностиЗаказаКлиента;
			
			ЭтоЗаказ = ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ЗаказКлиента")
				ИЛИ ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента");
			
			КлючВарианта = ?(НЕ РасширенныйЗаказ И ЭтоЗаказ,
				ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("СостояниеРасчетовПоОбъектуРасчетовУпрощенныйКонтекст", ЗначенияФункциональныхОпций.БазоваяВерсия),
				ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("СостояниеРасчетовПоОбъектуРасчетовКонтекст", ЗначенияФункциональныхОпций.БазоваяВерсия));
			
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
			
			ЭтаФорма.ФормаПараметры.Отбор = СтруктураНастроек.СтруктураОтборов;
			
			Параметры.КлючВарианта = КлючВарианта;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	
	ВзаиморасчетыСервер.ЗаменитьДокументыРасчетовСКлиентами(ФормаПараметры);
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеПользовательскихНастроекНаСервере.
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	НастроитьПользовательскиеНастройкиПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеПользовательскиеНастройкиКД = КомпоновщикНастроекФормы.ПользовательскиеНастройки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Расчеты = СхемаКомпоновкиДанных.НаборыДанных["Расчеты"]; // НаборДанныхОбъединениеСхемыКомпоновкиДанных -  
	Расчеты.Элементы.ОстаткиРасчетов.Запрос = ТекстЗапросаОстаткиРасчетов();
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
		"ИспользоватьРасширенныеВозможностиЗаказаКлиента",
		ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента"));
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);

	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	//Предупреждение о невыполенном распределении взаиморасчетов.
	ВзаиморасчетыСервер.ВывестиПредупреждениеОбОбновлении(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВПродажах") Тогда
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "АвансДоОбеспечения");
	КонецЕсли;

КонецПроцедуры

Процедура НастроитьПользовательскиеНастройкиПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВПродажах") Тогда
		КомпоновкаДанныхСервер.ОтключитьВыбранноеПолеВПользовательскихНастройках(КомпоновщикНастроекФормы, "АвансДоОбеспечения");
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстЗапросаОстаткиРасчетов()
	
	Возврат
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|	ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Статус КАК Статус,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Соглашение КАК Соглашение,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.Соглашение.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ДанныеДокумента.СуммаАвансаДоОбеспечения КАК СуммаАвансаДоОбеспечения,
	|	ДанныеДокумента.СуммаПредоплатыДоОтгрузки КАК СуммаПредоплатыДоОтгрузки
	|ПОМЕСТИТЬ ОбъектыРасчетов
	|ИЗ
	|	Документ.ЗаказКлиента КАК ДанныеДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Статус КАК Статус,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Соглашение КАК Соглашение,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.Соглашение.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.СуммаЗамены КАК СуммаДокумента,
	|	ДанныеДокумента.СуммаАвансаДоОбеспечения КАК СуммаАвансаДоОбеспечения,
	|	ДанныеДокумента.СуммаПредоплатыДоОтгрузки КАК СуммаПредоплатыДоОтгрузки
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ДанныеДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ВЫБОР КОГДА ДанныеДокумента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.КПредоплате) ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.КОбеспечению)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.Закрыт)
	|	КОНЕЦ КАК Статус,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Соглашение КАК Соглашение,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.Соглашение.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК СуммаДокумента,
	|	0 КАК СуммаАвансаДоОбеспечения,
	|	СУММА(ЕСТЬNULL(ЭтапыГрафика.СуммаВзаиморасчетов,0)) КАК СуммаПредоплатыДоОтгрузки
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.ЭтапыГрафикаОплаты КАК ЭтапыГрафика
	|		ПО ДанныеДокумента.Ссылка = ЭтапыГрафика.Ссылка
	|			И ЭтапыГрафика.ВариантОплаты В (ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроляОплатыКлиентом.ПредоплатаДоОтгрузки),
	|													ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроляОплатыКлиентом.АвансДоОбеспечения))
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	РасчетыСКлиентами.ОбъектРасчетов КАК ЗаказКлиента,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.ОбъектРасчетов.Объект ССЫЛКА Справочник.ДоговорыКонтрагентов
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК РасчетыПоДоговору,
	|	РасчетыСКлиентами.Валюта КАК Валюта,
	|	АналитикаПоПартнерам.Партнер КАК Партнер,
	|	АналитикаПоПартнерам.Организация КАК Организация,
	|	АналитикаПоПартнерам.Контрагент КАК Контрагент,
	|	АналитикаПоПартнерам.Договор КАК Договор,
	|	АналитикаПоПартнерам.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.СуммаКонечныйОстаток > 0
	|			ТОГДА РасчетыСКлиентами.СуммаКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДолгКлиента,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.СуммаКонечныйОстаток < 0
	|			ТОГДА -РасчетыСКлиентами.СуммаКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НашДолг,
	|	РасчетыСКлиентами.СуммаКонечныйОстаток КАК СальдоДолга,
	|	РасчетыСКлиентами.ОплачиваетсяКонечныйОстаток КАК Оплачивается,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.КОплатеКонечныйОстаток > 0
	|			ТОГДА РасчетыСКлиентами.КОплатеКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КОплате,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.КОплатеКонечныйОстаток < 0
	|			И (РасчетыСКлиентами.ОбъектРасчетов.Объект Ссылка Документ.ВозвратТоваровОтКлиента
	|				ИЛИ РасчетыСКлиентами.ОбъектРасчетов.Объект Ссылка Документ.ЗаявкаНаВозвратТоваровОтКлиента)
	|			ТОГДА -РасчетыСКлиентами.КОплатеКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КВозвратуДС,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.КОтгрузкеКонечныйОстаток < 0
	|			ТОГДА -РасчетыСКлиентами.КОтгрузкеКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КОтгрузке,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.ОтгружаетсяКонечныйОстаток > 0
	|			ТОГДА РасчетыСКлиентами.ОтгружаетсяКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Отгружается,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0) > 0
	|				И РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток
	|					< ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения,0)
	|			ТОГДА Заказ.СуммаАвансаДоОбеспечения - (РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК АвансДоОбеспечения,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0) > 0
	|				И ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0) > 0
	|				И РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток
	|					< ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|			ТОГДА Заказ.СуммаПредоплатыДоОтгрузки
	|		КОГДА ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0) > 0
	|				И РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток
	|					< ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0) + ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|				И РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток
	|					>= ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|			ТОГДА Заказ.СуммаПредоплатыДоОтгрузки + Заказ.СуммаАвансаДоОбеспечения - (РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПредоплатаДоОтгрузки,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентами.ОбъектРасчетов.Объект <> НЕОПРЕДЕЛЕНО
	|				И Заказ.Ссылка ЕСТЬ NULL 
	|				И РасчетыСКлиентами.КОплатеКонечныйОстаток > 0
	|			ТОГДА РасчетыСКлиентами.КОплатеКонечныйОстаток
	|		КОГДА РасчетыСКлиентами.КОплатеПриход - ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|				- ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0) > 0
	|			И РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток <=
	|				ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0) + ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|			ТОГДА РасчетыСКлиентами.КОплатеПриход - ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|					- ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0)
	|		КОГДА РасчетыСКлиентами.КОплатеПриход - ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|				- ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0) > 0
	|			И РасчетыСКлиентами.КОплатеПриход - РасчетыСКлиентами.КОплатеКонечныйОстаток
	|				> ЕСТЬNULL(Заказ.СуммаПредоплатыДоОтгрузки, 0) + ЕСТЬNULL(Заказ.СуммаАвансаДоОбеспечения, 0)
	|			ТОГДА РасчетыСКлиентами.КОплатеКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КредитПослеОтгрузки
	|	
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.ОстаткиИОбороты(, ) КАК РасчетыСКлиентами
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОбъектыРасчетов КАК Заказ
	|		ПО РасчетыСКлиентами.ОбъектРасчетов.Объект = Заказ.Ссылка
	|		{ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|		ПО РасчетыСКлиентами.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики}
	|ГДЕ
	|	АналитикаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	И (РасчетыСКлиентами.КОплатеКонечныйОстаток <> 0 
	|			ИЛИ РасчетыСКлиентами.КОтгрузкеКонечныйОстаток <> 0
	|			ИЛИ РасчетыСКлиентами.ОтгружаетсяКонечныйОстаток <> 0
	|			ИЛИ РасчетыСКлиентами.СуммаКонечныйОстаток <> 0)
	|{ГДЕ
	|	(АналитикаПоПартнерам.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|";
	
КонецФункции

Процедура СформироватьПараметрыСостояниеРасчетовСКлиентом(ПараметрКоманды, ПараметрыФормы, Параметры)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	Если ЭтоМассив Тогда
		ЕстьПодчиненныеПартнеры = Ложь;
		Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
			Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
				ЕстьПодчиненныеПартнеры = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
	КонецЕсли;
	
	ЭтоБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
	Если ЕстьПодчиненныеПартнеры Тогда
		ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
		ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		ЗначениеОтбора = ПараметрКоманды;
			Если ЭтоМассив Тогда
				ЗначениеОтбора = Новый СписокЗначений;
				ЗначениеОтбора.ЗагрузитьЗначения(ПараметрКоманды);
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
			ЭлементОтбора.ПравоеЗначение = ЗначениеОтбора;
		ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
		Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
		ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
		Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
		
		ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("СостояниеРасчетовСКлиентамиКонтекст", ЭтоБазовая);
		
	Иначе
		ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		
		Если ЭтоМассив И ПараметрКоманды.Количество() = 1 Тогда
			ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("СостояниеРасчетовСКлиентомКонтекст", ЭтоБазовая);
		Иначе
			ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("СостояниеРасчетовСКлиентамиКонтекст", ЭтоБазовая);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция НастройкиОтчета(ПараметрКоманды)
	
	ЗначенияФункциональныхОпций = Новый Структура;
	ЗначенияФункциональныхОпций.Вставить("ИспользоватьРасширенныеВозможностиЗаказаКлиента", 
	                                     ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента"));
	ЗначенияФункциональныхОпций.Вставить("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	Типы = Новый Массив;
	Типы.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтКлиента"));
	Типы.Добавить(Тип("ДокументСсылка.ВыкупТоваровХранителем"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента"));
	Типы.Добавить(Тип("ДокументСсылка.КорректировкаРеализации"));
	Типы.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	Типы.Добавить(Тип("ДокументСсылка.ВыкупВозвратнойТарыКлиентом"));
	Типы.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
	Типы.Добавить(Тип("ДокументСсылка.РеализацияУслугПрочихАктивов"));
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ЗначенияФункциональныхОпций", ЗначенияФункциональныхОпций);
	СтруктураНастроек.Вставить("СтруктураОтборов",
	                           ВзаиморасчетыСервер.СтруктураОтборовОтчетовРасчетыСКлиентами(ПараметрКоманды,
	                                                                                        "СостояниеРасчетовСКлиентами",
	                                                                                         "СостояниеРасчетовСКлиентомПоДокументам", 
	                                                                                         Типы));
	Возврат СтруктураНастроек;
	
КонецФункции

Функция ИмяКлючаВариантаВЗависимостиОтФлагаБазовая(ИмяКлючаВарианта, ЭтоБазовая)
	
	Если Не ЭтоБазовая Тогда
		Возврат ИмяКлючаВарианта;
	КонецЕсли;
	
	Если ИмяКлючаВарианта = "СостояниеРасчетовСКлиентами" Тогда
		Возврат "СостояниеРасчетовСКлиентамиБазовая";
	ИначеЕсли ИмяКлючаВарианта = "СостояниеРасчетовПоОбъектуРасчетовКонтекст" Тогда
		Возврат "СостояниеРасчетовПоОбъектуРасчетовКонтекстБазовая";
	ИначеЕсли ИмяКлючаВарианта = "СостояниеРасчетовСКлиентомКонтекст" Тогда
		Возврат "СостояниеРасчетовСКлиентомКонтекстБазовая";
	ИначеЕсли ИмяКлючаВарианта = "СостояниеРасчетовСКлиентамиКонтекст" Тогда
		Возврат "СостояниеРасчетовСКлиентамиКонтекстБазовая";
	ИначеЕсли ИмяКлючаВарианта = "СостояниеРасчетовПоОбъектуРасчетовУпрощенныйКонтекст" Тогда
		Возврат "СостояниеРасчетовПоОбъектуРасчетовУпрощенныйКонтекстБазовая";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли