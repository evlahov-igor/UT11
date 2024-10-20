﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус.Пустая() Тогда
		Статус = Перечисления.СтатусыНаправленияДеятельности.Используется;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(Назначение, ШаблонНазначения, ЭтотОбъект, "УчетЗатрат", Отказ, Истина, Не УчетЗатрат);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());	
	
	НаправленияДеятельностиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПриЗаписиСправочника(Назначение, 
												ШаблонНазначения,
												ЭтотОбъект,
												УчетНДСУП.ВидДеятельностиПоНалогообложениюНДС(НалогообложениеНДС));
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Запись подчиненной константы.
	ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
	ОбеспечениеСервер.ИспользоватьНазначенияБезЗаказаВычислитьИЗаписать();
	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);
	
	НаправленияДеятельностиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НалогообложениеНДСОпределяетсяВДокументе Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	НаправленияДеятельностиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		Назначение = Справочники.Назначения.ПустаяСсылка();
		Если НалогообложениеНДСОпределяетсяВДокументе Тогда
			НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.КлючиАналитикиУчетаПоПартнерам", "ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
#КонецОбласти

#КонецЕсли