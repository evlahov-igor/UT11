﻿////////////////////////////////////////////////////////////////////////////////////
// Модуль "ВстречнаяКорректировкаНазначенияКлиент", содержит процедуры и функции для
// работы с механизмом встречной корректировки.
//
////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//Возвращает параметры встречной корректировки назначения
//
// Возвращаемое значение:
//  Структура - с ключами:
//   * Заказ            - ДокументСсылка.ЗаказНаПроизводство2_2 - 
//   * Номенклатура     - СправочникСсылка.Номенклатура - 
//   * Характеристика   - СправочникСсылка.ХарактеристикиНоменклатуры - 
//   * Назначение       - СправочникСсылка.Назначения - 
//   * КлючНоменклатура - УникальныйИдентификатор - 
//   * КлючПартия       - УникальныйИдентификатор - 
//   * Количество       - Число - 
//
Функция ПараметрыВстречнойКорректировкиНазначения() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Заказ");
	Параметры.Вставить("Номенклатура");
	Параметры.Вставить("Характеристика");
	Параметры.Вставить("Назначение");
	Параметры.Вставить("КлючНоменклатура");
	Параметры.Вставить("КлючПартия");
	Параметры.Вставить("Количество");
	
	Возврат Параметры;
	
КонецФункции

//Заполняет параметры встречной корректировки назначения
//
// Параметры:
//  Параметры            - см. ПараметрыВстречнойКорректировкиНазначения
//  ИсходныеДанные       - СтрокаТаблицыЗначений, Структура - 
//  ДополнительныеДанные - Структура, Неопределено - 
//
Процедура ЗаполнитьПараметрыВстречнойКорректировкиНазначения(
			Параметры, ИсходныеДанные, ДополнительныеДанные = Неопределено) Экспорт
	
	ЗаполнитьЗначенияСвойств(Параметры, ИсходныеДанные);
	Параметры.Количество = ИсходныеДанные.Дефицит;
	
	Если ДополнительныеДанные <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Параметры, ДополнительныеДанные);
	КонецЕсли;
	
КонецПроцедуры

//Возвращает описание команды открытие формы Обработка.ЗаполнениеКорректировкиНазначения.Форма.ФормаОбъекта
//
// Параметры:
//  Форма                        - ФормаКлиентскогоПриложения - 
//  Данные                       - СтрокаТаблицыЗначений, Структура - 
//  ДанныеВстречнойКорректировки - см. ВстречнаяКорректировкаНазначенияВызовСервера.ДанныеВстречнойКорректировкиНазначения
//
// Возвращаемое значение:
//  Структура - с ключами:
//   * Форма             - ФормаКлиентскогоПриложения - 
//   * Количество        - Число - 
//   * ОбъектыОснований  - Массив - 
//   * Назначение        - СправочникСсылка.Назначения - 
//   * ТоварыОтбор       - см. ВстречнаяКорректировкаНазначения.ТоварыОтбораВстречнойКорректировкиНазначения
//
Функция ОписаниеКоманды(Форма, Данные, ДанныеВстречнойКорректировки) Экспорт
	
	ОбъектыОснований = Новый Массив;
	ОбъектыОснований.Добавить(Данные.Заказ);
	
	ОписаниеКоманды = Новый Структура;
	ОписаниеКоманды.Вставить("Форма",            Форма);
	ОписаниеКоманды.Вставить("ОбъектыОснований", ОбъектыОснований);
	ОписаниеКоманды.Вставить("Назначение",       Данные.Назначение);
	ОписаниеКоманды.Вставить("Количество",       Данные.Количество);
	ОписаниеКоманды.Вставить("ТоварыОтбор",      ДанныеВстречнойКорректировки.ТоварыОтбор);
	
	Возврат ОписаниеКоманды;
	
КонецФункции

#КонецОбласти