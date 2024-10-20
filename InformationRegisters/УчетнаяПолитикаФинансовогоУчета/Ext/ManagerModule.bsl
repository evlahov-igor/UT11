﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значения по умолчанию для ресурсов регистра.
// Имена ключей структуры должны строго соответствовать именам ресурсов регистра.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - структура значений ресурсов регистра.
Функция ЗначенияПоУмолчанию() Экспорт
	СтруктураЗначений = Новый Структура;
	
	СтруктураЗначений.Вставить("МетодОценкиСтоимостиТоваров", Перечисления.МетодыОценкиСтоимостиТоваров.СредняяЗаМесяц);
	СтруктураЗначений.Вставить("УчетГотовойПродукцииПоПлановойСтоимости", Ложь);
	СтруктураЗначений.Вставить("ФормироватьРезервыПоСомнительнымДолгам", Ложь);
	СтруктураЗначений.Вставить("ПериодичностьРезервовПоСомнительнымДолгам", Перечисления.Периодичность.Месяц);
	СтруктураЗначений.Вставить("ПризнаватьРасходыПоИсследованиям", Ложь);
	СтруктураЗначений.Вставить("СтатьяРасходовПоИсследованиям", Неопределено);
	СтруктураЗначений.Вставить("АналитикаРасходовПоИсследованиям", Неопределено);
	СтруктураЗначений.Вставить("ИспользоватьВыделениеДолгосрочныхАктивовОбязательств", Ложь);
	СтруктураЗначений.Вставить("ДлительностьОперационногоЦикла", 12);
	СтруктураЗначений.Вставить("УчетАрендыПоФСБУ25_2018", Истина);
	СтруктураЗначений.Вставить("УчетДисконтированнойКредиторскойЗадолженностиПоставщикам", Ложь);
	СтруктураЗначений.Вставить("СтатьяСписанияПроцентныхРасходов", Неопределено);
	СтруктураЗначений.Вставить("АналитикаСписанияПроцентныхРасходов", Неопределено);
	СтруктураЗначений.Вставить("СрокДляПримененияДисконтирования", 0);
	СтруктураЗначений.Вставить("УчетнаяПолитикаСуществует", Ложь);
	СтруктураЗначений.Вставить("МесяцНачалаФинансовогоГода", 1);
	СтруктураЗначений.Вставить("ДетализироватьДополнительныеРасходыВСебестоимостиТоваров", Ложь);
	
	
	Возврат СтруктураЗначений
	
КонецФункции

// Возвращает представление начала финансового года
// 
// Параметры:
//  МесяцНачалаФинансовогоГода - Число - Порядковый номер месяца
// 
// Возвращаемое значение:
//  Строка - Представление месяца начала финансового года
Функция ПредставлениеНачалаФинансовогоГода(МесяцНачалаФинансовогоГода) Экспорт
	
	Если МесяцНачалаФинансовогоГода = 1 Тогда
		Возврат НСтр("ru='Январь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 2 Тогда
		Возврат НСтр("ru='Февраль'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 3 Тогда
		Возврат НСтр("ru='Март'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 4 Тогда
		Возврат НСтр("ru='Апрель'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 5 Тогда
		Возврат НСтр("ru='Май'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 6 Тогда
		Возврат НСтр("ru='Июнь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 7 Тогда
		Возврат НСтр("ru='Июль'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 8 Тогда
		Возврат НСтр("ru='Август'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 9 Тогда
		Возврат НСтр("ru='Сентябрь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 10 Тогда
		Возврат НСтр("ru='Октябрь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 11 Тогда
		Возврат НСтр("ru='Ноябрь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 12 Тогда
		Возврат НСтр("ru='Декабрь'");
	Иначе
		Возврат НСтр("ru='Неопределено'");
	КонецЕсли;
	
КонецФункции

// Возращает текст запроса по данным регистра.
// 
// Возвращаемое значение:
// 	Строка - Текст запроса.
Функция ТекстЗапросаДействующиеПараметрыНалоговУчетныхПолитик() Экспорт
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР КОГДА ТаблицаСрезПоследних.Период ЕСТЬ NULL Тогда
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК УчетнаяПолитикаСуществует,
	|	ТаблицаСрезПоследних.Период КАК Период,
	|	ГоловныеОрганизации.ОбособленноеПодразделение КАК Организация,
	|	ТаблицаСрезПоследних.МетодОценкиСтоимостиТоваров КАК МетодОценкиСтоимостиТоваров,
	|	ТаблицаСрезПоследних.ФормироватьРезервыПоСомнительнымДолгам КАК ФормироватьРезервыПоСомнительнымДолгам,
	|	ТаблицаСрезПоследних.ПериодичностьРезервовПоСомнительнымДолгам КАК ПериодичностьРезервовПоСомнительнымДолгам,
	|	ТаблицаСрезПоследних.УчетГотовойПродукцииПоПлановойСтоимости КАК УчетГотовойПродукцииПоПлановойСтоимости,
	|	ТаблицаСрезПоследних.ПризнаватьРасходыПоИсследованиям КАК ПризнаватьРасходыПоИсследованиям,
	|	ТаблицаСрезПоследних.СтатьяРасходовПоИсследованиям КАК СтатьяРасходовПоИсследованиям,
	|	ТаблицаСрезПоследних.АналитикаРасходовПоИсследованиям КАК АналитикаРасходовПоИсследованиям,
	|	ТаблицаСрезПоследних.ИспользоватьВыделениеДолгосрочныхАктивовОбязательств,
	|	ТаблицаСрезПоследних.ДлительностьОперационногоЦикла,
	|	ТаблицаСрезПоследних.ПорядокУчетаВНА,
	|	ТаблицаСрезПоследних.ПорядокНачисленияАмортизации КАК ПорядокНачисленияАмортизации,
	|	ТаблицаСрезПоследних.УчетАрендыПоФСБУ25_2018 КАК УчетАрендыПоФСБУ25_2018,
	|	ТаблицаСрезПоследних.ВариантПроводокПоОбесценениюВНА КАК ВариантПроводокПоОбесценениюВНА,
	|	ТаблицаСрезПоследних.ВидЦеныТМЦВЭксплуатации КАК ВидЦеныТМЦВЭксплуатации,
	|	ТаблицаСрезПоследних.МесяцНачалаФинансовогоГода КАК МесяцНачалаФинансовогоГода,
	|	ТаблицаСрезПоследних.УчетДисконтированнойКредиторскойЗадолженностиПоставщикам КАК УчетДисконтированнойКредиторскойЗадолженностиПоставщикам,
	|	ТаблицаСрезПоследних.СтатьяСписанияПроцентныхРасходов КАК СтатьяСписанияПроцентныхРасходов,
	|	ТаблицаСрезПоследних.АналитикаСписанияПроцентныхРасходов КАК АналитикаСписанияПроцентныхРасходов,
	|	ТаблицаСрезПоследних.СрокДляПримененияДисконтирования КАК СрокДляПримененияДисконтирования,
	|	ТаблицаСрезПоследних.ДетализироватьДополнительныеРасходыВСебестоимостиТоваров
	|ИЗ
	|	ВтГоловныеОрганизации КАК ГоловныеОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаФинансовогоУчета.СрезПоследних(&Период, Организация В
	|			(ВЫБРАТЬ
	|				ГоловныеОрганизации.Организация
	|			ИЗ
	|				ВтГоловныеОрганизации КАК ГоловныеОрганизации)) КАК ТаблицаСрезПоследних
	|		ПО ГоловныеОрганизации.Организация = ТаблицаСрезПоследних.Организация
	|";
	Возврат ТекстЗапроса
	
КонецФункции

// Формирует текстовое описание установленных параметров.
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации - ссылка на организацию.
// 	ДатаДействия - Дата - период действия настроек.
// 	ДействующиеНастройки - Структура - действующие параметры учетной политики.
// Возвращаемое значение:
// 	Строка - Описание действующих параметров строкой.
Функция ОписаниеДействующихПараметров(Организация, ДатаДействия = Неопределено, ДействующиеНастройки = Неопределено) Экспорт
	
	Если ДействующиеНастройки = Неопределено Тогда
		ДействующиеНастройки = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
			"УчетнаяПолитикаФинансовогоУчета",
			Организация,
			ДатаДействия,
			Ложь);
	КонецЕсли;
	СтрокаШаблон = "%1: %2." + Символы.ПС;
	СтрокаШаблонБулево = "%1." + Символы.ПС;
	Если НЕ ЗначениеЗаполнено(ДействующиеНастройки) Тогда
		СтрокаОписанияНастроек = НСтр("ru='Не заданы параметры.'");
		Возврат СтрокаОписанияНастроек;
	КонецЕсли;
	
	СтрокаОписанияНастроек = СтрШаблон(СтрокаШаблон, 
		НСтр("ru='Начало финансового года'"),
		ПредставлениеНачалаФинансовогоГода(ДействующиеНастройки.МесяцНачалаФинансовогоГода));
	
	СтрокаОписанияНастроек = СтрокаОписанияНастроек 
		+ СтрШаблон(СтрокаШаблон, 
			НСтр("ru='Метод оценки стоимости товаров'"),
			ДействующиеНастройки.МетодОценкиСтоимостиТоваров);
	
	Если ДействующиеНастройки.УчетГотовойПродукцииПоПлановойСтоимости Тогда
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблонБулево,
				НСтр("ru='Готовая продукция учитывается по плановой стоимости'"));
	КонецЕсли;
	
	Если ДействующиеНастройки.ИспользоватьВыделениеДолгосрочныхАктивовОбязательств Тогда
		
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблонБулево,
				НСтр("ru='Используется выделение долгосрочных активов/обязательств'"));
		
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблон,
				НСтр("ru='Длительность операционного цикла в месяцах'"),
				ДействующиеНастройки.ДлительностьОперационногоЦикла);

	КонецЕсли;
	
	
	Если ДействующиеНастройки.УчетДисконтированнойКредиторскойЗадолженностиПоставщикам 
		И ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
			
			СтрокаОписанияНастроек = СтрокаОписанияНастроек
				+ СтрШаблон(СтрокаШаблонБулево,
					НСтр("ru='Ведется учет дисконтированной кредиторской задолженности поставщикам'"));
			
			СтрокаОписанияНастроек = СтрокаОписанияНастроек
				+ СтрШаблон(СтрокаШаблон,
					НСтр("ru='Статья списания процентных расходов дисконтирования'"),
					ДействующиеНастройки.СтатьяСписанияПроцентныхРасходов);
			
 			
			СтрокаОписанияНастроек = СтрокаОписанияНастроек
				+ СтрШаблон(СтрокаШаблон,
					НСтр("ru='Аналитика списания процентных расходов дисконтирования'"),
					ДействующиеНастройки.АналитикаСписанияПроцентныхРасходов);
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДействующиеНастройки.ВидЦеныТМЦВЭксплуатации) Тогда
		
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблон,
				НСтр("ru='Вид цены ТМЦ в эксплуатации'"),
				ДействующиеНастройки.ВидЦеныТМЦВЭксплуатации);
		
	КонецЕсли;
		
	ОписаниеДействующихПараметровЛокализация(СтрокаОписанияНастроек, Организация, ДатаДействия, ДействующиеНастройки);
	
	Возврат СтрокаОписанияНастроек
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Возвращает параметры выбора статей и аналитик.
// 
// Параметры:
//  ПризнаватьРасходыПоИсследованиям - Булево.
//  УчетДисконтированнойКредиторскойЗадолженностиПоставщикам - Булево.
//  
// Возвращаемое значение:
//  Массив из см. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики
//
Функция ПараметрыВыбораСтатейИАналитик(ПризнаватьРасходыПоИсследованиям, УчетДисконтированнойКредиторскойЗадолженностиПоставщикам) Экспорт
	
	МассивПараметров = Новый Массив;
	
	#Область СтатьяРасходовПоИсследованиям
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Запись";
	ПараметрыВыбора.Статья      = "СтатьяРасходовПоИсследованиям";
	
	ПараметрыВыбора.ДоступностьПоОперации = ПризнаватьРасходыПоИсследованиям = Истина;
	ПараметрыВыбора.СкрыватьСтатьюНедоступнуюПоОперации = Ложь;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходовПоИсследованиям";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходовПоИсследованиям");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходовПоИсследованиям");
	
	МассивПараметров.Добавить(ПараметрыВыбора);
	#КонецОбласти
	
	#Область СтатьяСписанияПроцентныхРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Запись";
	ПараметрыВыбора.Статья      = "СтатьяСписанияПроцентныхРасходов";
	
	ПараметрыВыбора.ДоступностьПоОперации = 
		УчетДисконтированнойКредиторскойЗадолженностиПоставщикам 
		И ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов");
	ПараметрыВыбора.СкрыватьСтатьюНедоступнуюПоОперации = Ложь;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаСписанияПроцентныхРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяСписанияПроцентныхРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаСписанияПроцентныхРасходов");
	
	МассивПараметров.Добавить(ПараметрыВыбора);
	#КонецОбласти 
	
	Возврат МассивПараметров;
	
КонецФункции

Процедура ОписаниеДействующихПараметровЛокализация(СтрокаОписанияНастроек, Организация, ДатаДействия, ДействующиеНастройки)
	
	//++ Локализация
	
	СтрокаШаблон = "%1: %2." + Символы.ПС;
	СтрокаШаблонБулево = "%1." + Символы.ПС;


	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.8.103";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("4db80397-fd9c-450a-a10c-cb025337de54");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет регистр ""Учетная политика финансового учета"":
	|- переносит старые настройки учетных политик организаций
	|- заполняет новые реквизиты ""Порядок учета внеоборотных активов"", ""Порядок начисления амортизации"", ""Месяц начала финансового года"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.ПолноеИмя());
	//++ Локализация
	Читаемые.Добавить(Метаданные.РегистрыСведений.УдалитьУчетнаяПолитикаОрганизаций.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.УдалитьУчетныеПолитикиОрганизаций.ПолноеИмя());
	//-- Локализация
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.УчетнаяПолитикаФинансовогоУчета";
	
	Запрос = Новый Запрос;
	
	//++ Локализация	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеРегистра.Период КАК Период,
	|	ДанныеРегистра.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.УдалитьУчетнаяПолитикаОрганизаций КАК ДанныеРегистра
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаФинансовогоУчета КАК УчетнаяПолитикаФинансовогоУчета
	|		ПО (УчетнаяПолитикаФинансовогоУчета.Организация = ДанныеРегистра.Организация)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УдалитьУчетныеПолитикиОрганизаций КАК Политики
	|		ПО (ДанныеРегистра.УчетнаяПолитика = Политики.Ссылка)
	|ГДЕ
	|	УчетнаяПолитикаФинансовогоУчета.Организация ЕСТЬ NULL
	|	И НЕ Политики.Ссылка ЕСТЬ NULL";
	
	Данные = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	//-- Локализация
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Период КАК Период,
	|	ДанныеРегистра.Организация КАК Организация
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДанныеРегистра.Период КАК Период,
	|		ДанныеРегистра.Организация КАК Организация
	|	ИЗ
	|		РегистрСведений.УчетнаяПолитикаФинансовогоУчета КАК ДанныеРегистра
	|	ГДЕ
	|		ДанныеРегистра.МесяцНачалаФинансовогоГода = 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДанныеРегистра.Период КАК Период,
	|		ДанныеРегистра.Организация КАК Организация
	|	ИЗ
	|		РегистрСведений.УчетнаяПолитикаФинансовогоУчета КАК ДанныеРегистра
	|	ГДЕ
	|		ДанныеРегистра.МетодОценкиСтоимостиТоваров = ЗНАЧЕНИЕ(Перечисление.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка)
	|		И НЕ ДанныеРегистра.ДетализироватьДополнительныеРасходыВСебестоимостиТоваров
	|	) КАК ДанныеРегистра";
	
	Данные = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.УчетнаяПолитикаФинансовогоУчета;
	ПолноеИмяОбъекта  = МетаданныеОбъекта.ПолноеИмя();

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ДополнительныеПараметры.ИмяВременнойТаблицы = "ВТДанныеДляОбработки";
	ДополнительныеПараметры.ВыбиратьПорциями = Ложь;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуИзмеренийНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		ПолноеИмяОбъекта,
		МенеджерВременныхТаблиц,
		ДополнительныеПараметры);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	//++ Локализация
	#Область ПереносИзСтарогоСправочника
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеРегистра.Период КАК Период,
	|	ДанныеРегистра.Организация КАК Организация,
	|	ДанныеРегистра.УчетнаяПолитика КАК УчетнаяПолитика
	|ИЗ
	|	РегистрСведений.УдалитьУчетнаяПолитикаОрганизаций КАК ДанныеРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДляОбработки КАК ДанныеДляОбработки
	|		ПО ДанныеДляОбработки.Период = ДанныеРегистра.Период
	|		И ДанныеДляОбработки.Организация = ДанныеРегистра.Организация
	|ИТОГИ
	|ПО
	|	УчетнаяПолитика";
	
	ВыборкаУчетнаяПолитика = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "УчетнаяПолитика");
	
	Пока ВыборкаУчетнаяПолитика.Следующий() Цикл
	
		НачатьТранзакцию();
		
		Попытка
		
			БлокировкаУчетнаяПолитика = Новый БлокировкаДанных;
			
			ЭлементБлокировки = БлокировкаУчетнаяПолитика.Добавить("Справочник.УдалитьУчетныеПолитикиОрганизаций");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаУчетнаяПолитика.УчетнаяПолитика);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			
			БлокировкаУчетнаяПолитика.Заблокировать();
			
			ЗапросУчетнаяПолитика = Новый Запрос();
			ЗапросУчетнаяПолитика.Текст = "ВЫБРАТЬ
			|	УчетнаяПолитика.МетодОценкиСтоимостиТоваров,
			|	УчетнаяПолитика.УчетГотовойПродукцииПоПлановойСтоимости
			|ИЗ
			|	Справочник.УдалитьУчетныеПолитикиОрганизаций КАК УчетнаяПолитика
			|ГДЕ
			|	УчетнаяПолитика.Ссылка = &УчетнаяПолитика";
			
			ЗапросУчетнаяПолитика.УстановитьПараметр("УчетнаяПолитика", ВыборкаУчетнаяПолитика.УчетнаяПолитика);
			
			РезультатЗапросаУчетнаяПолитика = ЗапросУчетнаяПолитика.Выполнить();
			
			Если РезультатЗапросаУчетнаяПолитика.Пустой() Тогда
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка получения настроек учетной политики ""%1"".'",
					ОбщегоНазначения.КодОсновногоЯзыка()), 
					ВыборкаУчетнаяПолитика.УчетнаяПолитика);
				ВызватьИсключение ТекстОшибки;
			Иначе
				НастройкаУчетнойПолитики = РезультатЗапросаУчетнаяПолитика.Выгрузить()[0];
			КонецЕсли;
			
			Выборка = ВыборкаУчетнаяПолитика.Выбрать(ОбходРезультатаЗапроса.Прямой);	
			
			Пока Выборка.Следующий() Цикл
				
				НаборЗаписей = РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
				НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
				
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
				ЗаполнитьЗначенияСвойств(НоваяЗапись, НастройкаУчетнойПолитики);
							
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные в регистр %ИмяРегистра% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяОбъекта);
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, Неопределено, ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	#КонецОбласти
	//-- Локализация
	
	#Область ДобавлениеНовыхЗаписей
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДляОбработки.Период КАК Период,
	|	ДанныеДляОбработки.Организация КАК Организация
	|ИЗ
	|	ВТДанныеДляОбработки КАК ДанныеДляОбработки";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		НачатьТранзакцию();
		
		Попытка
		
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УчетнаяПолитикаФинансовогоУчета");
			ЭлементБлокировки.УстановитьЗначение("Организация", Выборка.Организация);
			ЭлементБлокировки.УстановитьЗначение("Период", Выборка.Период);
			

			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
			НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
			
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
				
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные в регистр %ИмяРегистра% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяОбъекта);
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, Неопределено, ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
	
	КонецЦикла;
	
	#КонецОбласти
	
	#Область ОбновлениеСуществующихНастроек
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДляОбработки.Период КАК Период,
	|	ДанныеДляОбработки.Организация КАК Организация
	|ИЗ
	|	ВТДанныеДляОбработки КАК ДанныеДляОбработки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;

			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Период", Выборка.Период);
			ЭлементБлокировки.УстановитьЗначение("Организация", Выборка.Организация);
			
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.УчетнаяПолитикаФинансовогоУчета.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
			НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
			НаборЗаписей.Прочитать();
			
			Для Каждого ЗаписьРегистра Из НаборЗаписей Цикл
				
				Если ЗаписьРегистра.МесяцНачалаФинансовогоГода = 0 Тогда
					ЗаписьРегистра.МесяцНачалаФинансовогоГода = 1;
				КонецЕсли;
				
				
				Если ЗаписьРегистра.МетодОценкиСтоимостиТоваров = Перечисления.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка
				 И НЕ ЗаписьРегистра.ДетализироватьДополнительныеРасходыВСебестоимостиТоваров Тогда
				 	ЗаписьРегистра.ДетализироватьДополнительныеРасходыВСебестоимостиТоваров = Истина;
				КонецЕсли;
					
			КонецЦикла;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные в регистр %ИмяРегистра% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПредставлениеОшибки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяОбъекта);
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, 
				Неопределено, 
				ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	#КонецОбласти
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
