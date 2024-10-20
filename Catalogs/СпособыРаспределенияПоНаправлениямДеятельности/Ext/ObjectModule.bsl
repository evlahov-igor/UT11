﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если ПравилоРаспределения <> Перечисления.ПравилаРаспределенияПоНаправлениямДеятельности.ПропорциональноКоэффициентам Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправленияДеятельности");
		МассивНепроверяемыхРеквизитов.Добавить("НаправленияДеятельности.Коэффициент");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если ПравилоРаспределения <> Перечисления.ПравилаРаспределенияПоНаправлениямДеятельности.ПропорциональноКоэффициентам
	   И НаправленияДеятельности.Итог("Коэффициент") <> 0
	Тогда
		Массив = Новый Массив(НаправленияДеятельности.Количество());	
		НаправленияДеятельности.ЗагрузитьКолонку(Массив, "Коэффициент");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
