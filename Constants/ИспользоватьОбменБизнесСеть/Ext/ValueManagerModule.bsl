﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.СервисEDI") Тогда
		ОбщийМодульНастройкиEDI = ОбщегоНазначения.ОбщийМодуль("НастройкиEDI");
		ОбщийМодульНастройкиEDI.УстановитьИспользованиеРегламентныхЗаданий();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
