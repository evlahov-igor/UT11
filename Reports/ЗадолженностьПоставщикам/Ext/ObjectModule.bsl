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
	
	// Установка значений по умолчанию
	УстановитьОбязательныеНастройки(КомпоновщикНастроекФормы, Истина);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

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
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСПоставщиком" Тогда
			
			СформироватьПараметрыСостояниеРасчетовСПоставщиком(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСПоставщикомПоДокументам" Тогда
			
			ПараметрКоманды = Параметры.ПараметрКоманды;
			
			СтруктураНастроек = НастройкиОтчета(ПараметрКоманды);
			ЗначенияФункциональныхОпций = СтруктураНастроек.ЗначенияФункциональныхОпций;
			
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
			
			СформироватьПараметрыОтчета(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
			Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ЗадолженностьПоставщикамПоОбъектуРасчетовКонтекст", 
			                                                                    ЗначенияФункциональныхОпций.БазоваяВерсия);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;

КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТекстЗапроса = ТекстЗапроса();
	ВзаиморасчетыСервер.ДобавитьОтборыВыбранныхПолейВЗапрос(ТекстЗапроса, НастройкиОтчета, СхемаКомпоновкиДанных.ВычисляемыеПоля, "Расчеты");
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	//Предупреждение о невыполенном распределении взаиморасчетов.
	ВзаиморасчетыСервер.ВывестиПредупреждениеОбОбновлении(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
КонецПроцедуры

Процедура УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрДатаОстатков = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	ПараметрДатаОстатков.Использование = Истина;
	
	ПараметрДатаОтчетаГраница = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчетаГраница");
	ПараметрДатаОтчетаГраница.Использование = Истина;
	
	Если ТипЗнч(ПараметрДатаОстатков.Значение) = Тип("СтандартнаяДатаНачала") Тогда
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение.Дата) Тогда
			ПараметрДатаОстатков.Значение.Дата = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение.Дата), ВидГраницы.Включая);
	Иначе
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение) Тогда
			ПараметрДатаОстатков.Значение = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение), ВидГраницы.Включая);
	КонецЕсли;
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
КонецПроцедуры

Функция ТекстЗапроса()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Расчеты.Организация                          КАК Организация,
	|	Расчеты.Партнер                              КАК Партнер,
	|	Расчеты.Контрагент                           КАК Контрагент,
	|	Расчеты.Договор                              КАК Договор,
	|	Расчеты.НаправлениеДеятельности              КАК НаправлениеДеятельности,
	|	Расчеты.ОбъектРасчетов                       КАК ОбъектРасчетов,
	|	Расчеты.Валюта                               КАК Валюта,
	|	Расчеты.РасчетныйДокумент                    КАК РасчетныйДокумент,
	|	Расчеты.ДатаПлановогоПогашения               КАК ДатаПлановогоПогашения,
	|	Расчеты.ДатаВозникновения                    КАК ДатаВозникновения,
	|	СУММА(Расчеты.НашДолг)                       КАК НашДолг,
	|	СУММА(Расчеты.ДолгПоставщика)                КАК ДолгПоставщика,
	|	
	|	СУММА(Расчеты.ПлановаяОплатаАванс)           КАК ПлановаяОплатаАванс,
	|	СУММА(Расчеты.ПлановаяОплатаПредоплата)      КАК ПлановаяОплатаПредоплата,
	|	СУММА(Расчеты.ПлановаяОплатаКредит)          КАК ПлановаяОплатаКредит,
	|	СУММА(Расчеты.ПлановаяОплатаНезависимо)      КАК ПлановаяОплатаНезависимо,
	|	СУММА(Расчеты.ПлановаяОплатаПросрочено)      КАК ПлановаяОплатаПросрочено,
	|	СУММА(Расчеты.Оплачивается)                  КАК Оплачивается,
	|	
	|	СУММА(Расчеты.ПлановоеПоступление)           КАК ПлановоеПоступление,
	|	СУММА(Расчеты.ПлановоеПоступлениеПросрочено) КАК ПлановоеПоступлениеПросрочено
	|ИЗ (
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                                     КАК Организация,
	|		АналитикаУчета.Партнер                                         КАК Партнер,
	|		АналитикаУчета.Контрагент                                      КАК Контрагент,
	|		АналитикаУчета.Договор                                         КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности                         КАК НаправлениеДеятельности,
	|		РасчетыПоСрокам.ОбъектРасчетов                                 КАК ОбъектРасчетов,
	|		РасчетыПоСрокам.Валюта                                         КАК Валюта,
	|		РасчетыПоСрокам.РасчетныйДокумент                              КАК РасчетныйДокумент,
	|		РасчетыПоСрокам.ДатаПлановогоПогашения                         КАК ДатаПлановогоПогашения,
	|		РасчетыПоСрокам.ДатаВозникновения                              КАК ДатаВозникновения,
	|		РасчетыПоСрокам.ДолгОстаток                                    КАК НашДолг,
	|		РасчетыПоСрокам.ПредоплатаОстаток                              КАК ДолгПоставщика,
	|		
	|		0                                                              КАК ПлановаяОплатаАванс,
	|		0                                                              КАК ПлановаяОплатаПредоплата,
	|		0                                                              КАК ПлановаяОплатаКредит,
	|		0                                                              КАК ПлановаяОплатаНезависимо,
	|		0                                                              КАК ПлановаяОплатаПросрочено,
	|		0                                                              КАК Оплачивается,
	|		
	|		0                                                              КАК ПлановоеПоступление,
	|		0                                                              КАК ПлановоеПоступлениеПросрочено
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщикамиПоСрокам.Остатки(&ДатаОтчетаГраница) КАК РасчетыПоСрокам
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПоСрокам.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                                    КАК Организация,
	|		АналитикаУчета.Партнер                                        КАК Партнер,
	|		АналитикаУчета.Контрагент                                     КАК Контрагент,
	|		АналитикаУчета.Договор                                        КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности                        КАК НаправлениеДеятельности,
	|		РасчетыПланОплат.ОбъектРасчетов                               КАК ОбъектРасчетов,
	|		РасчетыПланОплат.Валюта                                       КАК Валюта,
	|		РасчетыПланОплат.ДокументПлан                                 КАК ДокументПлан,
	|		РасчетыПланОплат.ДатаПлановогоПогашения                       КАК ДатаПлановогоПогашения,
	|		РасчетыПланОплат.ДатаВозникновения                            КАК ДатаВозникновения,
	|		0                                                             КАК НашДолг,
	|		0                                                             КАК ДолгПоставщика,
	|		
	|		ВЫБОР
	|			КОГДА РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроляОплатыПоставщику.АвансДоПодтверждения)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток 
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                         КАК ПлановаяОплатаАванс,
	|		ВЫБОР
	|			КОГДА РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроляОплатыПоставщику.ПредоплатаДоПоступления)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток 
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                         КАК ПлановаяОплатаПредоплата,
	|		ВЫБОР
	|			КОГДА РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроляОплатыПоставщику.КредитСдвиг)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток 
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                          КАК ПлановаяОплатаКредит,
	|		ВЫБОР
	|			КОГДА РасчетыПланОплат.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроляОплатыПоставщику.КредитПослеПоступления)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток 
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                          КАК ПлановаяОплатаНезависимо,
	|		ВЫБОР 
	|			КОГДА РасчетыПланОплат.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета,ДЕНЬ)
	|				ТОГДА РасчетыПланОплат.КОплатеОстаток
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                                          КАК ПлановаяОплатаПросрочено,
	|		0                                                              КАК Оплачивается,
	|		
	|		0                                                              КАК ПлановоеПоступление,
	|		0                                                              КАК ПлановоеПоступлениеПросрочено
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщикамиПланОплат.Остатки(&ДатаОтчетаГраница) КАК РасчетыПланОплат
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланОплат.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                  КАК Организация,
	|		АналитикаУчета.Партнер                      КАК Партнер,
	|		АналитикаУчета.Контрагент                   КАК Контрагент,
	|		АналитикаУчета.Договор                      КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|		РасчетыПланПоставок.ОбъектРасчетов          КАК ОбъектРасчетов,
	|		РасчетыПланПоставок.Валюта                  КАК Валюта,
	|		РасчетыПланПоставок.ДокументПлан            КАК ДокументПлан,
	|		РасчетыПланПоставок.ДатаПлановогоПогашения  КАК ДатаПлановогоПогашения,
	|		РасчетыПланПоставок.ДатаВозникновения       КАК ДатаВозникновения,
	|		0                                           КАК НашДолг,
	|		0                                           КАК ДолгПоставщика,
	|		
	|		0                                           КАК ПлановаяОплатаАванс,
	|		0                                           КАК ПлановаяОплатаПредоплата,
	|		0                                           КАК ПлановаяОплатаКредит,
	|		0                                           КАК ПлановаяОплатаНезависимо,
	|		0                                           КАК ПлановаяОплатаПросрочено,
	|		0                                           КАК Оплачивается,
	|		
	|		РасчетыПланПоставок.СуммаОстаток            КАК ПлановоеПоступление,
	|		ВЫБОР 
	|			КОГДА РасчетыПланПоставок.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета,ДЕНЬ)
	|				ТОГДА РасчетыПланПоставок.СуммаОстаток
	|			ИНАЧЕ 0 
	|		КОНЕЦ                                       КАК ПлановоеПоступлениеПросрочено
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщикамиПланПоставок.Остатки(&ДатаОтчетаГраница) КАК РасчетыПланПоставок
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланПоставок.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                КАК Организация,
	|		АналитикаУчета.Партнер                    КАК Партнер,
	|		АналитикаУчета.Контрагент                 КАК Контрагент,
	|		АналитикаУчета.Договор                    КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности    КАК НаправлениеДеятельности,
	|		РасчетыСПоставщиками.ОбъектРасчетов       КАК ОбъектРасчетов,
	|		РасчетыСПоставщиками.Валюта               КАК Валюта,
	|		Неопределено                              КАК ДокументПлан,
	|		ДАТАВРЕМЯ(1,1,1)                          КАК ДатаПлановогоПогашения,
	|		ДАТАВРЕМЯ(1,1,1)                          КАК ДатаВозникновения,
	|		0                                         КАК НашДолг,
	|		0                                         КАК ДолгПоставщика,
	|		
	|		0                                         КАК ПлановаяОплатаАванс,
	|		0                                         КАК ПлановаяОплатаПредоплата,
	|		0                                         КАК ПлановаяОплатаКредит,
	|		0                                         КАК ПлановаяОплатаНезависимо,
	|		0                                         КАК ПлановаяОплатаПросрочено,
	|		-РасчетыСПоставщиками.ОплачиваетсяОстаток КАК Оплачивается,
	|		
	|		0                                         КАК ПлановоеПоступление,
	|		0                                         КАК ПлановоеПоступлениеПросрочено
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(&ДатаОтчетаГраница) КАК РасчетыСПоставщиками
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|		ПО АналитикаУчета.КлючАналитики = РасчетыСПоставщиками.АналитикаУчетаПоПартнерам
	|	ГДЕ
	|		РасчетыСПоставщиками.ОплачиваетсяОстаток < 0 
	|		И Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}) КАК Расчеты
	|СГРУППИРОВАТЬ ПО
	|	Расчеты.Организация,
	|	Расчеты.Партнер,
	|	Расчеты.Контрагент,
	|	Расчеты.Договор,
	|	Расчеты.НаправлениеДеятельности,
	|	Расчеты.ОбъектРасчетов,
	|	Расчеты.Валюта,
	|	Расчеты.РасчетныйДокумент,
	|	Расчеты.ДатаПлановогоПогашения,
	|	Расчеты.ДатаВозникновения
	|ИМЕЮЩИЕ
	|	(&ОтборыВыбранныхПолей)
	|";
	
	Возврат ТекстЗапроса;
КонецФункции

Процедура СформироватьПараметрыСостояниеРасчетовСПоставщиком(ПараметрКоманды, ПараметрыФормы, Параметры)
	
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
	
	ЭтотБазоваяВерсия = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
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
		
		Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ЗадолженностьПоставщикамКонтекст", 
			                                                                 ЭтотБазоваяВерсия);
	Иначе
		ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		
		Если ЭтоМассив И ПараметрКоманды.Количество() = 1 Тогда
			Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ЗадолженностьПоставщикуКонтекст", 
			                                                                    ЭтотБазоваяВерсия);
		Иначе
			Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ЗадолженностьПоставщикамКонтекст", 
			                                                                    ЭтотБазоваяВерсия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьПараметрыОтчета(ПараметрКоманды, ПараметрыФормы, Параметры)
	
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
	
	Если ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Партнеры") Тогда
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
		Иначе
			ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
			ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
		ИЛИ ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		ПараметрыФормы.Отбор = Новый Структура("Договор", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
	ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ОбъектыРасчетов") Тогда
		Если ЭтоМассив Тогда
			ПараметрыФормы.Отбор = Новый Структура("ОбъектРасчетов", ПараметрКоманды);
			ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		Иначе
			ПараметрыФормы.Отбор = Новый Структура("ОбъектРасчетов", ПервыйЭлемент);
			ПараметрыФормы.КлючНазначенияИспользования = ПервыйЭлемент;
			Параметры.КлючНазначенияИспользования = ПервыйЭлемент;
		КонецЕсли;
	Иначе
		ОбъектРасчетов = ОбъектыРасчетовСервер.ОбъектРасчетовИзСсылки(ПервыйЭлемент);
		ПараметрыФормы.Отбор = Новый Структура("ОбъектРасчетов", ОбъектРасчетов);
		ПараметрыФормы.КлючНазначенияИспользования = ОбъектРасчетов;
		Параметры.КлючНазначенияИспользования = ОбъектРасчетов;
	КонецЕсли;
	
КонецПроцедуры

Функция НастройкиОтчета(ПараметрКоманды)
	
	ЗначенияФункциональныхОпций = Новый Структура;
	ЗначенияФункциональныхОпций.Вставить("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ЗначенияФункциональныхОпций", ЗначенияФункциональныхОпций);
	
	Возврат СтруктураНастроек
	
КонецФункции

Функция ИмяКлючаВариантаВЗависимостиОтФлагаБазовая(ИмяКлючаВарианта, ЭтоБазовая)
	
	Если Не ЭтоБазовая Тогда
		Возврат ИмяКлючаВарианта;
	КонецЕсли;
	
	Если ИмяКлючаВарианта = "ЗадолженностьПоставщикам" Тогда
		Возврат "ЗадолженностьПоставщикамБазовая";
	ИначеЕсли ИмяКлючаВарианта = "ЗадолженностьПоставщикамПоОбъектуРасчетовКонтекст" Тогда
		Возврат "ЗадолженностьПоставщикамПоОбъектуРасчетовКонтекстБазовая";
	ИначеЕсли ИмяКлючаВарианта = "ЗадолженностьПоставщикуКонтекст" Тогда
		Возврат "ЗадолженностьПоставщикуКонтекстБазовая";
	ИначеЕсли ИмяКлючаВарианта = "ЗадолженностьПоставщикамКонтекст" Тогда
		Возврат "ЗадолженностьПоставщикамКонтекстБазовая";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли