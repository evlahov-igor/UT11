﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ПрайсЛист", ТорговоеПредложение) 
		Или Не ЗначениеЗаполнено(ТорговоеПредложение) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан("РегистрСведений.ТорговыеПредложенияТорговойПлощадки");
	
	ЗаполнитьНастройкиКратностиУпаковок();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Модифицированность = Истина;
	ЗаполнитьНастройкиВыбраннымиЗначениями(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемПродолжение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	ЗаписатьЗакрытьПродолжение(Отказ);
	Если Не Отказ Тогда
		Модифицированность = Ложь; // не выводить подтверждение о закрытии формы еще раз.
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиКратностиУпаковок

&НаКлиенте
Процедура НастройкиКратностиУпаковокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	// Отказ от добавления пустой строки.
	Отказ = Истина;
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения(
			"НастройкиКратностиУпаковокПередНачаломДобавленияПродолжение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Для продолжения необходимо записать изменения.'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Ок);
		
	Иначе
		НастройкиКратностиУпаковокДобавление();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокуНастроек(Команда)
	
	ВыделенныеСтроки = Элементы.НастройкиКратностиУпаковок.ВыделенныеСтроки;
	
	Для Каждого Идентификатор Из ВыделенныеСтроки Цикл
		СтрокаНастроек = НастройкиКратностиУпаковок.НайтиПоИдентификатору(Идентификатор);
		СтрокаКУдалению = НастройкиКУдалению.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКУдалению, СтрокаНастроек);
		СтрокаКУдалению.КратностьУпаковки = 1;
	КонецЦикла;
	
	ИндексНастройки = НастройкиКратностиУпаковок.Количество() - 1;
	Пока ИндексНастройки >= 0 Цикл
		
		Идентификатор = НастройкиКратностиУпаковок[ИндексНастройки].ПолучитьИдентификатор();
		Если ВыделенныеСтроки.Найти(Идентификатор) <> Неопределено Тогда
			НастройкиКратностиУпаковок.Удалить(ИндексНастройки);
		КонецЕсли;
		
		ИндексНастройки = ИндексНастройки - 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьЗакрытьПродолжение( , Истина);
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьЗакрытьПродолжение();
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПродолжение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Для продолжения необходимо записать изменения.'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Ок);
		
	Иначе
		ЗаполнитьНастройкиКратностиУпаковок(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Отказ  = Ложь;
		ЗаписатьЗакрытьПродолжение(Отказ);
		Если Не Отказ Тогда
			ЗаполнитьНастройкиКратностиУпаковок(Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиКратностиУпаковок(КратностьПоУмолчанию = Ложь)
	
	ДанныеТорговыхПредложений = ТорговыеПредложенияСлужебный.
		ДанныеКратностиУпаковокПубликуемыхТорговыхПредложений(ТорговоеПредложение, КратностьПоУмолчанию);
	
	Если ДанныеТорговыхПредложений.Количество() > 0 Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеТорговыхПредложений, НастройкиКратностиУпаковок);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрытьПродолжение(Отказ = Ложь, Закрывать = Ложь)
	
	ОчиститьСообщения();
	
	Если Не Модифицированность Тогда
		Если Закрывать Тогда
			Закрыть();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЗаписатьИЗакрытьНаСервере(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОбИзменении(ТорговоеПредложение);
	
	Модифицированность = Ложь;
	Если Закрывать Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере(Отказ)
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаНастроек Из НастройкиКУдалению Цикл
		РегистрыСведений.ТорговыеПредложенияТорговойПлощадки.ИзменитьКратностьУпаковкиЗаписи(
			ТорговоеПредложение, СтрокаНастроек, Отказ);
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиКУдалению.Очистить();
	
	Для Каждого СтрокаНастроек Из НастройкиКратностиУпаковок Цикл
		Если СтрокаНастроек.КратностьУпаковки <= 1 Тогда
			
			Текст = НСтр("ru = 'Необходимо указать кратность упаковки больше ""1"". (Значение по умолчанию = ""1"")'");
			НомерСтроки = НастройкиКратностиУпаковок.Индекс(СтрокаНастроек);
			Поле = СтрШаблон("НастройкиКратностиУпаковок[%1].КратностьУпаковки", НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(Текст, , Поле, , Отказ);
			Продолжить;
			
		КонецЕсли;
		
		РегистрыСведений.ТорговыеПредложенияТорговойПлощадки.ИзменитьКратностьУпаковкиЗаписи(
			ТорговоеПредложение, СтрокаНастроек, Отказ);
		
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИзменения = ТорговыеПредложенияСлужебный.НовыйПараметрыИзмененияСостоянияТорговыхПредложений();
	ПараметрыИзменения.ТорговыеПредложения.Добавить(ТорговоеПредложение);
	РегистрыСведений.СостоянияСинхронизацииТорговыеПредложения.ИзменитьСостояниеПубликацииПрайсЛистов(ПараметрыИзменения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиВыбраннымиЗначениями(ВыбранныеСтроки)
	
	Для Каждого КлючЗаписи Из ВыбранныеСтроки Цикл
		
		Менеджер = РегистрыСведений.ТорговыеПредложенияТорговойПлощадки.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Менеджер, КлючЗаписи);
		Менеджер.Прочитать();
		
		Если Не Менеджер.Выбран() Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = НастройкиКратностиУпаковок.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Менеджер);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКратностиУпаковокДобавление()
	
	Отбор = Новый Структура;
	Отбор.Вставить("ПрайсЛист", ТорговоеПредложение);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Отбор", Отбор);
	
	ОткрытьФорму(
		"РегистрСведений.ТорговыеПредложенияТорговойПлощадки.Форма.ФормаВыбора", 
		ДополнительныеПараметры, 
		ЭтотОбъект, 
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКратностиУпаковокПередНачаломДобавленияПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		Отказ = Ложь;
		ЗаписатьЗакрытьПродолжение(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		НастройкиКратностиУпаковокДобавление();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
