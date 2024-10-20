﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыНабора = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
	ПараметрыНабора.Используется = Константы.ИспользоватьПередачиТоваровМеждуОрганизациями.Получить();
	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ПередачаТоваровМеждуОрганизациями", ПараметрыНабора);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
