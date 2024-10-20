﻿
#Область ПрограммныйИнтерфейс

// Процедура вызывается из форм списков в момент получения магнитного кода.
// Выполняет поиск карты лояльности в базе данных и вызывает оповещение "СчитанаКартаЛояльности"
// для формы-владельца.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  Данные - Массив - Массив данных, полученный из считывателя магнитных карт.
//
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Форма, Данные) Экспорт
	
	КартыЛояльности = КартыЛояльностиВызовСервера.НайтиКартыЛояльностиПоДаннымСоСчитывателяМагнитныхКарт(Данные);
	
	Если КартыЛояльности.ЗарегистрированныеКартыЛояльности.Количество() > 0 Тогда
		
		Если КартыЛояльности.ЗарегистрированныеКартыЛояльности.Количество() = 1 Тогда
			
			ВыбраннаяКартаЛояльности = КартыЛояльности.ЗарегистрированныеКартыЛояльности[0]; // см. КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности
			
			Оповестить(
				"СчитанаКартаЛояльности",
				Новый Структура("КартаЛояльности, ФормаВладелец", ВыбраннаяКартаЛояльности.Ссылка, Форма.УникальныйИдентификатор),
				Неопределено);
			
		Иначе
			
			ОткрытьФорму(
				"Справочник.КартыЛояльности.Форма.СчитываниеКартыЛояльности",
				Новый Структура("КодКарты, ТипКода", Данные, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод")),
				Форма,
				Форма.УникальныйИдентификатор);
			
		КонецЕсли;
		
	ИначеЕсли КартыЛояльности.НеЗарегистрированныеКартыЛояльности.Количество() > 0 Тогда
		
		ОткрытьФорму(
			"Справочник.КартыЛояльности.Форма.СчитываниеКартыЛояльности",
			Новый Структура("КодКарты, ТипКода", Данные, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод")),
			Форма,
			Форма.УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается из форм списков в момент получения штрихкода.
// Выполняет поиск карты лояльности в базе данных и вызывает оповещение "СчитанаКартаЛояльности"
// для формы-владельца.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  Штрихкоды - Массив, Строка - Штрихкоды.
//
Процедура ОбработатьШтрихкоды(Форма, Штрихкоды) Экспорт
	
	Если ТипЗнч(Штрихкоды) = Тип("Массив") Тогда
		МассивШтрихкодов = Штрихкоды;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(Штрихкоды);
	КонецЕсли;
	
	Если МассивШтрихкодов.Количество() = 1 Тогда
		
		КартыЛояльности = КартыЛояльностиВызовСервера.НайтиКартыЛояльностиПоШтрихкоду(МассивШтрихкодов[0].Штрихкод);
		
		Если КартыЛояльности.ЗарегистрированныеКартыЛояльности.Количество() > 0 Тогда
			
			Если КартыЛояльности.ЗарегистрированныеКартыЛояльности.Количество() = 1 Тогда
				
				Оповестить(
					"СчитанаКартаЛояльности",
					Новый Структура("КартаЛояльности, ФормаВладелец", КартыЛояльности.ЗарегистрированныеКартыЛояльности[0].Ссылка, Форма.УникальныйИдентификатор),
					Неопределено);
				
			Иначе
				
				ОткрытьФорму(
					"Справочник.КартыЛояльности.Форма.СчитываниеКартыЛояльности",
					Новый Структура("КодКарты, ТипКода", МассивШтрихкодов[0].Штрихкод, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод")),
					Форма,
					Форма.УникальныйИдентификатор);
				
			КонецЕсли;
			
		ИначеЕсли КартыЛояльности.НеЗарегистрированныеКартыЛояльности.Количество() > 0 Тогда
			
			ОткрытьФорму(
				"Справочник.КартыЛояльности.Форма.СчитываниеКартыЛояльности",
				Новый Структура("КодКарты, ТипКода", МассивШтрихкодов[0].Штрихкод, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод")),
				Форма,
				Форма.УникальныйИдентификатор);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// При начале выбора карты лояльности
//
// Параметры:
//  Элемент - ЭлементыФормы - Элемент формы.
//  СтандартнаяОбработка - Булево - Стандартная обработка.
//  Партнер - СправочникСсылка.Партнеры - Партнер.
//  ДатаДокумента - Дата - Дата документа.
//  Организация - СправочникСсылка.Организации, Неопределено - организация.
//  ДополнительныеПараметры - Структура - дополнительные параметры открытия формы.
//
Процедура НачалоВыбораКартыЛояльности(Элемент, СтандартнаяОбработка, Партнер, ДатаДокумента, Организация = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДатаДокумента", ДатаДокумента);
	ПараметрыОткрытия.Вставить("Партнер",       Партнер);
	ПараметрыОткрытия.Вставить("Организация",   Организация);
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ДополнительныеПараметры Цикл
			ПараметрыОткрытия.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;

	ОткрытьФорму(
		"Справочник.КартыЛояльности.Форма.ФормаВыбора",
		ПараметрыОткрытия,
		Элемент);
	
КонецПроцедуры

#Область КомандыПечатиАнкеты

// Процедура выполняет печать анкеты в формате "Microsoft Word"
//
// Параметры:
//  ОписаниеКоманды - Структура - Описание команды.
//
// Возвращаемое значение:
//  Неопределено - 
Функция ПечатьАнкетыMicrosoftWord(ОписаниеКоманды) Экспорт
	
	КартыЛояльностиЛокализацияКлиент.ПечатьАнкетыMicrosoftWord(ОписаниеКоманды);
	
КонецФункции

// Процедура выполняет печать анкеты в формате "Open Office"
//
// Параметры:
//  ОписаниеКоманды - Структура - Описание команды.
//
// Возвращаемое значение:
//  Неопределено - 
Функция ПечатьАнкетыOpenOfficeOrgWriter(ОписаниеКоманды) Экспорт
	
	КартыЛояльностиЛокализацияКлиент.ПечатьАнкетыOpenOfficeOrgWriter(ОписаниеКоманды);
	
КонецФункции

// Процедура выполняет печать анкеты в формате "MXL"
//
// Параметры:
//  ПараметрКоманды - Структура - Описание команды.
//
// Возвращаемое значение:
//  Неопределено - 
Функция ПечатьАнкетыMXL(ПараметрКоманды) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Справочник.КартыЛояльности",
		"Анкета",
		ПараметрКоманды,
		Неопределено);
	
КонецФункции

#КонецОбласти

#КонецОбласти

